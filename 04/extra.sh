#!/bin/bash

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