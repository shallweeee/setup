#! /bin/bash

APPS=~/.local/share/applications
SPEC=https://specifications.freedesktop.org/desktop-entry-spec/latest/ar01s06.html

usage() {
  echo "usage: ${0##*/} <exec path>"
  exit
}

error() {
  echo "$*"
  exit 1
}

[ -z "$1" ] && usage
[ -x "$1" ] || error "$1 은 실행가능하지 않습니다."

# desktop 파일 이름과 실행 파일 이름이 같아야 함
exec=$(realpath "$1")
name=$(basename "$exec")
desktop="${APPS}/${name}.desktop"

if [ -f "$desktop" ]; then
  read -p "파일이 이미 존재합니다. 바꾸시겠습니까? [yN] " ans
  [ x$ans = xy ] || [ x$ans = xY ] || exit
fi

mkdir -p $APPS
cat << EOF > "$desktop"
[Desktop Entry]
Version=1.0
Type=Application
Name=$name
Terminal=false
Exec=$exec
Icon=
EOF

echo
echo "$desktop 을 생성했습니다."
echo "자세한 사항은 $SPEC 를 참고하세요."
echo "프로그램 > $name 검색 후, 즐겨찾기 추가 또는 실행하세요"
