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

COLOR_NAMES=(
    [1]="white"
    [2]="red"
    [3]="green"
    [4]="blue"
    [5]="purple"
    [6]="black"
)

RESET="\033[0m"

DEFAULT_COLUMN1_BG=1   # white
DEFAULT_COLUMN1_FONT=6 # black
DEFAULT_COLUMN2_BG=4   # blue
DEFAULT_COLUMN2_FONT=1 # white

read_config() {
    local config_file="config.conf"

    if [[ ! -f "$config_file" ]]; then
        echo "warning: there is no $config_file. we'll use default colors"
        return 1
    fi

    while IFS='=' read -r key value; do
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        if [[ ! "$value" =~ ^[1-6]$ ]]; then
            continue
        fi
        
        case "$key" in
            column1_background)
                COLUMN1_BG="$value"
                ;;
            column1_font_color)
                COLUMN1_FONT="$value"
                ;;
            column2_background)
                COLUMN2_BG="$value"
                ;;
            column2_font_color)
                COLUMN2_FONT="$value"
                ;;
        esac
    done < "$config_file"
}

check_colors() {
    local error=0
    
    if [[ "$COLUMN1_BG" -eq "$COLUMN1_FONT" ]]; then
        echo "background and font colors should be different"
        echo "please, change column1_background or column1_font_color in config.conf"
        error=1
    fi
    
    if [[ "$COLUMN2_BG" -eq "$COLUMN2_FONT" ]]; then
        echo "background and font colors should be different"
        echo "please, change column2_background or column2_font_color in config.conf"
        error=1
    fi
    
    return $error
}

COLUMN1_BG="$DEFAULT_COLUMN1_BG"
COLUMN1_FONT="$DEFAULT_COLUMN1_FONT"
COLUMN2_BG="$DEFAULT_COLUMN2_BG"
COLUMN2_FONT="$DEFAULT_COLUMN2_FONT"

BG1_SET=0
FONT1_SET=0
BG2_SET=0
FONT2_SET=0

read_config

if ! check_colors; then
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

print_colored "HOSTNAME" "$HOSTNAME" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "TIMEZONE" "$TIMEZONE" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "USER" "$USER" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "OS" "$OS" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "DATE" "$DATE" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "UPTIME" "$UPTIME" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "UPTIME_SEC" "$UPTIME_SEC" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "IP" "$IP" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "MASK" "$MASK" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "GATEWAY" "$GATEWAY" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "RAM_TOTAL" "${RAM_TOTAL} GB" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "RAM_USED" "${RAM_USED} GB" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "RAM_FREE" "${RAM_FREE} GB" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "SPACE_ROOT" "${SPACE_ROOT} MB" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "SPACE_ROOT_USED" "${SPACE_ROOT_USED} MB" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"
print_colored "SPACE_ROOT_FREE" "${SPACE_ROOT_FREE} MB" "$COLUMN1_BG" "$COLUMN1_FONT" "$COLUMN2_BG" "$COLUMN2_FONT"

echo

echo -n "Column 1 background = "
if [[ "$COLUMN1_BG" -eq "$DEFAULT_COLUMN1_BG" ]] && [[ -z "$(grep '^column1_background=' config.conf 2>/dev/null)" ]]; then
    echo "default (${COLOR_NAMES[$COLUMN1_BG]})"
else
    echo "${COLUMN1_BG} (${COLOR_NAMES[$COLUMN1_BG]})"
fi

echo -n "Column 1 font color = "
if [[ "$COLUMN1_FONT" -eq "$DEFAULT_COLUMN1_FONT" ]] && [[ -z "$(grep '^column1_font_color=' config.conf 2>/dev/null)" ]]; then
    echo "default (${COLOR_NAMES[$COLUMN1_FONT]})"
else
    echo "${COLUMN1_FONT} (${COLOR_NAMES[$COLUMN1_FONT]})"
fi

echo -n "Column 2 background = "
if [[ "$COLUMN2_BG" -eq "$DEFAULT_COLUMN2_BG" ]] && [[ -z "$(grep '^column2_background=' config.conf 2>/dev/null)" ]]; then
    echo "default (${COLOR_NAMES[$COLUMN2_BG]})"
else
    echo "${COLUMN2_BG} (${COLOR_NAMES[$COLUMN2_BG]})"
fi

echo -n "Column 2 font color = "
if [[ "$COLUMN2_FONT" -eq "$DEFAULT_COLUMN2_FONT" ]] && [[ -z "$(grep '^column2_font_color=' config.conf 2>/dev/null)" ]]; then
    echo "default (${COLOR_NAMES[$COLUMN2_FONT]})"
else
    echo "${COLUMN2_FONT} (${COLOR_NAMES[$COLUMN2_FONT]})"
fi