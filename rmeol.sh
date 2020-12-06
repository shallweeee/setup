#! /bin/bash

has_eol() {
  tail -1 "$1" | od -An -tx1 | awk '{print $NF}' | grep -q 0a
}

get_size() {
  ls -l "$1" | awk '{print $5}'
}

remove_eol() {
  has_eol "$1" || exit 0

  local tmp=tmp.$$
  local size=$(get_size "$1")

  dd if="$1" of=$tmp bs=$((size - 1)) count=1
  mv -f $tmp "$1" || rm -f $tmp
}

for f in "$@"; do
  remove_eol "$f"
done
