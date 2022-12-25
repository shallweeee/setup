#! /bin/bash

IMAGE=ArchLinuxARM-rpi-aarch64-latest.tar.gz
UMOUNT_ERR_CNT=3

DEV=${1#/dev/}
FDEV=/dev/$DEV

error() {
  echo "$*"
  exit 1
}

log() {
  echo -e "\033[01;32m$*\033[00m"
}

usage() {
  header | head -2
  echo "usage: ${0##*/} <device>"
  echo "  device: mmcblk0 in case of /dev/mmcblk0"
  exit
}

header() {
  echo "Arch Linux Raspberry Pi 4 aarch64 Installer"
  echo
  echo "Check the latest install instructions at"
  echo "https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4"
  echo
  echo "Device $FDEV"
  echo
}

footer() {
  cat << EOF
8. Insert the SD card into the Raspberry Pi, connect ethernet, and apply 5V power.
9. Use the serial console or SSH to the IP address given to the board by your router.
    * Login as the default user alarm with the password alarm.
    * The default root password is root. ($ su -)
10. Initialize the pacman keyring and populate the Arch Linux ARM package signing keys:
    pacman-key --init
    pacman-key --populate archlinuxarm

Appendix A.
    pacman -Syu
    pacman -S sudo
    echo 'alarm ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers
    passwd alarm
    passwd
    shutdown -r 0
EOF
}

check_disk_size() {
  local size=$(sudo fdisk -l | grep -w "$FDEV:" | awk '{print $5}')
  [ -z "$size" ] || [ $size -gt $((32 * 1024 * 1024 * 1024)) ] && error "unsupported disk size $size"
}

check_dependencies() {
  which bsdtar >/dev/null && return
  sudo apt install libarchive-tools
}

umount_partitions() {
  mount | grep -q "^${FDEV}p" || return 0
  [ ! x$1 = x ] && [ $1 -ge $UMOUNT_ERR_CNT ] && error "umount error"

  mount | grep "^${FDEV}p" | awk '{print $1}' | while read part; do
    echo "umount $part"
    sudo umount "$part"
  done
  sleep 1
  umount_partitions $(($1 + 1))
}

make_partitions() {
  log "1. Start fdisk to partition the SD card"
  log "2. Partitioning"
  sed -e 's/\s*#.*//' << EOF | sudo fdisk ${FDEV}
o # clear out any partitions
n # add a new partition
p # primary partition
1 # partition number 1
  # default - first sector
+200M # 200MB for boot partition
t # change a partition type
c # W95 FAT32 (LBA)
n # add a new partition
p # primary partition
2 # partition number 2
  # default - first sector
  # default - left size for root partition
w # write
EOF
}

mount_partitions() {
  log "3. Create and mount the FAT filesystem"
  umount boot 2> /dev/null
  sudo mkfs.vfat ${FDEV}p1
  mkdir -p boot
  sudo mount ${FDEV}p1 boot

  log "4. Create and mount the ext4 filesystem"
  umount root 2> /dev/null
  sudo mkfs.ext4 -F ${FDEV}p2
  mkdir -p root
  sudo mount ${FDEV}p2 root
}

install_image() {
  log "5.1. Download"
  wget -c http://os.archlinuxarm.org/os/$IMAGE{,.md5}
  md5sum -c $IMAGE.md5 || error 'md5 error'

  log "5.2. Extract the root filesystem (as root, not via sudo)"
  sudo bsdtar -xpf $IMAGE -C root

  log "6. Move boot files to the first partition"
  sudo mv root/boot/* boot

  log "* Before unmounting the partitions, update /etc/fstab for the different SD block device compared to the Raspberry Pi 3"
  sudo sed -i 's/mmcblk0/mmcblk1/g' root/etc/fstab

  log "* Sync. (It'll take time, please be patient)"
  sync

  log "7. Unmount the two partitions"
  umount_partitions
}

[ -z "$1" ] && usage
[ -b $FDEV ] || usage "no device $DEV"

check_disk_size
check_dependencies
header
umount_partitions &&
make_partitions &&
mount_partitions &&
install_image &&
footer
