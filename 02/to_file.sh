#!/bin/bash

OUTPUT="$OUTPUT_DATA"

read -p "Записать данные в файл? (Y/N): " ANSWER

if [[ "$ANSWER" == "Y" || "$ANSWER" == "y" ]]; then
    FILENAME=$(date +"%d_%m_%y_%H_%M_%S.status")
    echo "$OUTPUT" > "$FILENAME"
    echo "Данные записаны в файл: $FILENAME"
else
    echo "Сохранение отменено."
fi