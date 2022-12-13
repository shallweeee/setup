#! /bin/bash

# VR-PARK 디바이스를 우분투 22.04 에서 미디어 콘트롤러로 설정
# 장치 연결 후 @B 모드로 전환 필요

install_udev_rule() {
  local udev_rule=/etc/udev/rules.d/80-vrpark.rules 
  [ -f $udev_rule ] ||
  cat << EOF | sudo tee $udev_rule
ACTION=="bind", SUBSYSTEM=="hid", ENV{HID_NAME}=="VR-PARK", RUN+="$(realpath $0)"
EOF
}

install_udev_rule

# 안정화
sleep 1

USER="$(realpath "$0" | cut -d/ -f3)"
USERID="$(id -u $USER)"
XKB_ROOT="/tmp/$USER/xkb"

# 매핑 생성
# @B 모드
# 위/왼쪽     - 소리 크게
# 아래/오른쪽 - 소리 작게
# C           - 재생/일시정지
# D           - 전체화면 (f)
# A           - 오른쪽
# B           - 왼쪽
mkdir -p $XKB_ROOT/symbols
cat << EOF > $XKB_ROOT/symbols/custom
xkb_symbols "media" {
  key <I171> { [ XF86AudioLowerVolume ] };
  key <I172> { [ Right ] };
  key <I173> { [ XF86AudioRaiseVolume ] };
  key <I180> { [ Left ] };
  key <VOL+> { [ XF86AudioPlay, XF86AudioPause ] };
  key <VOL-> { type="ALPHABETIC", symbols[Group1]=[ f, F ] };
};
EOF

# xinput 은 DISPLAY 와 XAUTHORITY 변수가 필요
# 우분투 22.04 에서의 설정
export DISPLAY=${DISPLAY:=:1}
export XAUTHORITY=${XAUTHORITY:="/run/user/$USERID/gdm/Xauthority"}

kbd_id=$(xinput list | sed -n 's/.*VR-PARK.*id=\([0-9]*\).*keyboard.*/\1/p')
[ "$kbd_id" ] &&
  setxkbmap -device $kbd_id -print |
  sed 's/\(xkb_symbols.*\)"/\1+custom(media)"/' |
  xkbcomp -I$XKB_ROOT -i $kbd_id -synch - $DISPLAY 2>/dev/null
