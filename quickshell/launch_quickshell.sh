#!/bin/bash

for monitor in $(hyprctl monitors | grep "name:" | awk '{print $2}'); do
    quickshell -m "$monitor" &
done
