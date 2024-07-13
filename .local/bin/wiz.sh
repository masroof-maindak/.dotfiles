
#!/bin/sh

# Original script: https://github.com/depsterr/mfetch
# Edited to my tastes.
read -r host < /proc/sys/kernel/hostname

#Get WM name
id=$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)
id=${id##* }
wm=$(xprop -id "$id" -notype -len 100 -f _NET_WM_NAME 8t)
wm=${wm/*WM_NAME = }
wm=${wm/\"}
wm=${wm/\"*}

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    OS="${OS%Linux}"
fi

#Get kernel name
KERNEL=$(uname -r)
KERNEL="${KERNEL%-arch?-?}"

c0='[0m';
c1='[33m';
c6='[31m'

# Output
printf '%s\n' "

    ${c1}     .-.         
    ${c1}  __/   (         ${USER}${c0}@${c1}${host}
    ${c1}, '-.____\\        ${c6}distro${c0}    ${OS}
    ${c1} u=='/  \\         ${c6}kernel${c0}    ${KERNEL}
    ${c1}    /_/  \\        ${c6}shell${c0}     ${SHELL##*/}
    ${c1}  .-''   |        ${c6}wm${c0}        ${wm}
    ${c1} (  ${c6}____${c1}/${c6}____${c0}

"
