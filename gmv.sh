GMV_BRANCH=master

get_current() {
  git log --oneline -1 | cut -d' ' -f1
}

bt() {
  local CUR=$(get_current)
  git log --oneline $GMV_BRANCH | awk '/^'$CUR'/ {CUR=NR; LINE=$0} {TOT=NR} END {print CUR "/" TOT "  " LINE}'
}

up() {
  local CUR=$(get_current)
  local NEXT=$(git log --oneline $GMV_BRANCH | grep -B1 "^$CUR" | head -1 | awk '{print $1}')
  [ $CUR = $NEXT ] || git co $NEXT > /dev/null 2>&1 
  bt
}

dn() {
  local CUR=$(get_current)
  local NEXT=$(git log --oneline $GMV_BRANCH | grep -A1 "^$CUR" | tail -1 | awk '{print $1}')
  [ $CUR = $NEXT ] || git co $NEXT > /dev/null 2>&1 
  bt
}

show() {
  git log -p -1
}
