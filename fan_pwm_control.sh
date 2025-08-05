#!/bin/bash

TEMP1=25
PWM1=0

TEMP2=35
PWM2=130

TEMP_MAX=100
PWM_MAX=255

while true; do
    temp_mil=$(cat /sys/class/thermal/thermal_zone0/temp)
    temp=$(echo "scale=1; $temp_mil / 1000" | bc)

    if (( $(echo "$temp <= $TEMP1" | bc -l) )); then
        pwm_val=$PWM1
    elif (( $(echo "$temp <= $TEMP2" | bc -l) )); then
        # 线性映射30-40℃对应0-70 PWM
        pwm_val_float=$(echo "scale=2; ($temp - $TEMP1) * ($PWM2 - $PWM1) / ($TEMP2 - $TEMP1) + $PWM1" | bc)
        pwm_val=$(printf "%.0f" $pwm_val_float)
    elif (( $(echo "$temp < $TEMP_MAX" | bc -l) )); then
        # 线性映射40-100℃对应70-255 PWM
        pwm_val_float=$(echo "scale=2; ($temp - $TEMP2) * ($PWM_MAX - $PWM2) / ($TEMP_MAX - $TEMP2) + $PWM2" | bc)
        pwm_val=$(printf "%.0f" $pwm_val_float)
    else
        pwm_val=$PWM_MAX
    fi

    echo "Temperature: ${temp}°C, PWM: $pwm_val"

    echo $pwm_val | sudo tee /sys/devices/platform/pwm-fan/hwmon/hwmon*/pwm1 > /dev/null

    sleep 3
done
