#!/bin/bash

COLORS=(
    [1]="\033[47m"   # white background
    [2]="\033[41m"   # red background
    [3]="\033[42m"   # green background
    [4]="\033[44m"   # blue background
    [5]="\033[45m"   # purple background
    [6]="\033[40m"   # black background
)

FONT_COLORS=(
    [1]="\033[97m"   # white font
    [2]="\033[31m"   # red font
    [3]="\033[32m"   # green font
    [4]="\033[34m"   # blue font
    [5]="\033[35m"   # purple font
    [6]="\033[30m"   # black font
)

RESET="\033[0m"

if [[ $# -ne 4 ]]; then
    echo "you need to input 4 parametrs"
    echo "colors: 1-white, 2-red, 3-green, 4-blue, 5-purple, 6-black"
    exit 1
fi

for param in "$@"; do
    if ! [[ "$param" =~ ^[1-6]$ ]]; then
        echo "params should be in range [1 до 6]"
        echo "but got: $param"
        exit 1
    fi
done

if [[ $1 -eq $2 ]]; then
    echo "background and font colors should be different, but got the same (1 and 2)"
    echo "please, try again"
    exit 1
fi

if [[ $3 -eq $4 ]]; then
    echo "background and font colors should be different, but got the same (3 and 4)"
    echo "please, try again"
    exit 1
fi

HOSTNAME=$(hostname)

TIMEZONE_NAME=$(timedatectl show --property=Timezone --value)
UTC_OFFSET=$(date +%:z)
TIMEZONE="$TIMEZONE_NAME UTC $UTC_OFFSET"

USER=$(whoami)

OS=$(. /etc/os-release && echo "$NAME $VERSION")

DATE=$(date +"%d %b %Y %H:%M:%S")

UPTIME_SEC=$(awk '{print int($1)}' /proc/uptime)
UPTIME=$(uptime -p)

IFACE=$(ip -o -4 addr show | awk '!/ lo /{print $2; exit}')
IP=$(ip -o -4 addr show "$IFACE" | awk '{print $4}' | cut -d/ -f1)
PREFIX=$(ip -o -4 addr show "$IFACE" | awk '{print $4}' | cut -d/ -f2)
MASK=$(ipcalc "$IP/$PREFIX" 2>/dev/null | grep -i netmask | awk '{print $2}')

GATEWAY=$(ip route | awk '/default/ {print $3; exit}')

RAM_TOTAL=$(free -b | awk '/Mem:/ {printf "%.3f", $2/1024/1024/1024}')
RAM_USED=$(free -b | awk '/Mem:/ {printf "%.3f", $3/1024/1024/1024}')
RAM_FREE=$(free -b | awk '/Mem:/ {printf "%.3f", $4/1024/1024/1024}')

SPACE_ROOT=$(df -B1 / | awk 'NR==2 {printf "%.2f", $2/1024/1024}')
SPACE_ROOT_USED=$(df -B1 / | awk 'NR==2 {printf "%.2f", $3/1024/1024}')
SPACE_ROOT_FREE=$(df -B1 / | awk 'NR==2 {printf "%.2f", $4/1024/1024}')

print_colored() {
    local label="$1"
    local value="$2"
    local label_bg="${COLORS[$3]}"
    local label_fg="${FONT_COLORS[$4]}"
    local value_bg="${COLORS[$5]}"
    local value_fg="${FONT_COLORS[$6]}"
    
    echo -e "${label_bg}${label_fg}${label}${RESET} = ${value_bg}${value_fg}${value}${RESET}"
}

print_colored "HOSTNAME" "$HOSTNAME" "$1" "$2" "$3" "$4"
print_colored "TIMEZONE" "$TIMEZONE" "$1" "$2" "$3" "$4"
print_colored "USER" "$USER" "$1" "$2" "$3" "$4"
print_colored "OS" "$OS" "$1" "$2" "$3" "$4"
print_colored "DATE" "$DATE" "$1" "$2" "$3" "$4"
print_colored "UPTIME" "$UPTIME" "$1" "$2" "$3" "$4"
print_colored "UPTIME_SEC" "$UPTIME_SEC" "$1" "$2" "$3" "$4"
print_colored "IP" "$IP" "$1" "$2" "$3" "$4"
print_colored "MASK" "$MASK" "$1" "$2" "$3" "$4"
print_colored "GATEWAY" "$GATEWAY" "$1" "$2" "$3" "$4"
print_colored "RAM_TOTAL" "${RAM_TOTAL} GB" "$1" "$2" "$3" "$4"
print_colored "RAM_USED" "${RAM_USED} GB" "$1" "$2" "$3" "$4"
print_colored "RAM_FREE" "${RAM_FREE} GB" "$1" "$2" "$3" "$4"
print_colored "SPACE_ROOT" "${SPACE_ROOT} MB" "$1" "$2" "$3" "$4"
print_colored "SPACE_ROOT_USED" "${SPACE_ROOT_USED} MB" "$1" "$2" "$3" "$4"
print_colored "SPACE_ROOT_FREE" "${SPACE_ROOT_FREE} MB" "$1" "$2" "$3" "$4"