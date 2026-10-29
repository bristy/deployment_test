#!/usr/bin/env bash
set -euo pipefail

curl -sf --get "https://api.openweathermap.org/data/2.5/weather" \
  --data-urlencode "q=$1" \
  --data-urlencode "appid=$OPENWEATHER_API_KEY" \
  --data-urlencode "units=metric" \
  | jq '{place: .name, temp_c: .main.temp, feels_like_c: .main.feels_like, conditions: .weather[0].description, wind_ms: .wind.speed}'
