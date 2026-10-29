---
name: weather
description: "Current weather and today's forecast for a place, from OpenWeatherMap."
metadata: {"openclaw":{"emoji":"🌦️","requires":{"bins":["curl","jq"],"env":["OPENWEATHER_API_KEY"]},"primaryEnv":"OPENWEATHER_API_KEY"}}
---

# Weather

```bash
{baseDir}/scripts/weather.sh "<place>"
```

Pass the place as the user wrote it, for example "New Paltz, NY".
