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