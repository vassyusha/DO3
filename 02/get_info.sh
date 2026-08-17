#!/bin/bash

export HOSTNAME=$(hostname)

TIMEZONE_NAME=$(timedatectl show --property=Timezone --value)
UTC_OFFSET=$(date +%:z)
export TIMEZONE="$TIMEZONE_NAME UTC $UTC_OFFSET"

export USER=$(whoami)

export OS=$(. /etc/os-release && echo "$NAME $VERSION")

export DATE=$(date +"%d %b %Y %H:%M:%S")

export UPTIME_SEC=$(awk '{print int($1)}' /proc/uptime)
export UPTIME=$(uptime -p)

IFACE=$(ip -o -4 addr show | awk '!/ lo /{print $2; exit}')
export IP=$(ip -o -4 addr show "$IFACE" | awk '{print $4}' | cut -d/ -f1)
PREFIX=$(ip -o -4 addr show "$IFACE" | awk '{print $4}' | cut -d/ -f2)
export MASK=$(ipcalc "$IP/$PREFIX" 2>/dev/null | grep -i netmask | awk '{print $2}')

export GATEWAY=$(ip route | awk '/default/ {print $3; exit}')

export RAM_TOTAL=$(free -b | awk '/Mem:/ {printf "%.3f", $2/1024/1024/1024}')
export RAM_USED=$(free -b | awk '/Mem:/ {printf "%.3f", $3/1024/1024/1024}')
export RAM_FREE=$(free -b | awk '/Mem:/ {printf "%.3f", $4/1024/1024/1024}')

export SPACE_ROOT=$(df -B1 / | awk 'NR==2 {printf "%.2f", $2/1024/1024}')
export SPACE_ROOT_USED=$(df -B1 / | awk 'NR==2 {printf "%.2f", $3/1024/1024}')
export SPACE_ROOT_FREE=$(df -B1 / | awk 'NR==2 {printf "%.2f", $4/1024/1024}')