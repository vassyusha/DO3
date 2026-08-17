#!/bin/bash

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

OUTPUT="HOSTNAME = $HOSTNAME
TIMEZONE = $TIMEZONE
USER = $USER
OS = $OS
DATE = $DATE
UPTIME = $UPTIME
UPTIME_SEC = $UPTIME_SEC
IP = $IP
MASK = $MASK
GATEWAY = $GATEWAY
RAM_TOTAL = ${RAM_TOTAL} GB
RAM_USED = ${RAM_USED} GB
RAM_FREE = ${RAM_FREE} GB
SPACE_ROOT = ${SPACE_ROOT} MB
SPACE_ROOT_USED = ${SPACE_ROOT_USED} MB
SPACE_ROOT_FREE = ${SPACE_ROOT_FREE} MB"

echo "$OUTPUT"

export OUTPUT_DATA="$OUTPUT"
bash ./to_file.sh