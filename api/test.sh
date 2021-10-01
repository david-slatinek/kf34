#!/bin/bash

KEY=""
TYPE=""
URL=""
URL_IMAGE=""
HEADER="Content-Type: application/json"

curl "$URL" -s -o /dev/null --write-out '%{time_total}\n' \
-H "$HEADER" \
-H "X-API-Key: $KEY" \
-d '{"query":"query GetMax { getMax(device_type: '"$TYPE"') { success error data captured }}"}'

curl "$URL" -s -o /dev/null --write-out '%{time_total}\n' \
-H "$HEADER" \
-H "X-API-Key: $KEY" \
-d '{"query":"query GetMin { getMin(device_type: '"$TYPE"') { success error data captured }}"}'

curl "$URL" -s -o /dev/null --write-out '%{time_total}\n' \
-H "$HEADER" \
-H "X-API-Key: $KEY" \
-d '{"query":"query GetMaxToday { getMaxToday(device_type: '"$TYPE"') { success error data captured }}"}'

curl "$URL" -s -o /dev/null --write-out '%{time_total}\n' \
-H "$HEADER" \
-H "X-API-Key: $KEY" \
-d '{"query":"query GetMinToday { getMinToday(device_type: '"$TYPE"') { success error data captured }}"}'

curl "$URL" -s -o /dev/null --write-out '%{time_total}\n' \
-H "$HEADER" \
-H "X-API-Key: $KEY" \
-d '{"query":"query GetAverageToday { getAverageToday(device_type: '"$TYPE"') { success error data }}"}'

curl "$URL" -s -o /dev/null --write-out '%{time_total}\n' \
-H "$HEADER" \
-H "X-API-Key: $KEY" \
-d '{"query":"query GetMedianToday { getMedianToday(device_type: '"$TYPE"') { success error data }}"}'

curl "$URL" -s -o /dev/null --write-out '%{time_total}\n' \
-H "$HEADER" \
-H "X-API-Key: $KEY" \
-d '{"query":"query GetStandardDeviationToday { getStandardDeviationToday(device_type: '"$TYPE"') { success error data }}"}'

curl "$URL" -s -o /dev/null --write-out '%{time_total}\n' \
-H "$HEADER" \
-H "X-API-Key: $KEY" \
-d '{"query":"query GetToday { getToday(device_type: '"$TYPE"') { success error data { id_data capture value fk_device } } }"}'

curl "$URL" -s -o /dev/null --write-out '%{time_total}\n' \
-H "$HEADER" \
-H "X-API-Key: $KEY" \
-d '{"query":"query GetLatest { getLatest(device_type: '"$TYPE"') { success error data { id_data capture value fk_device } } }"}'

curl "$URL_IMAGE" -s -o /dev/null --write-out '%{time_total}\n' \
-H "$HEADER" \
-H "X-API-Key: $KEY" \
-d '{"device_type": "'$TYPE'"}'
