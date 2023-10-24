#! /usr/bin/env bash

sh="${SHELL##*/}"
pm="$(pacman -Qq | wc -l)"
up="$(awk '{print int($1 / 3600)}' /proc/uptime)"
at="$(uname -n)"
me="$(whoami)"

id=$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)
id=${id##* }

wm=$(xprop -id "$id" -notype -len 100 -f _NET_WM_NAME 8t)
wm=${wm##*WM_NAME = \"}
wm=${wm%%\"*}

c0='[0m'
c1='[31m'
c2='[32m'
c3='[33m'
c4='[34m'
c5='[35m'
c6='[36m'

cat <<-EOF

${c1}@      ${c1}...    ${at}${c0}
${c2}me     ${c2}...    ${me}${c0}
${c3}sh     ${c3}...    ${sh}${c0}
${c4}wm     ${c4}...    ${wm}${c0}
${c5}up     ${c5}...    ${up}h${c0}
${c6}pm     ${c6}...    ${pm}${c0}

EOF
