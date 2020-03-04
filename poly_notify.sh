#!/usr/bin/env bash

POLYBAR_CONFIG="${HOME}/.config/polybar/config"
NOTIFY_QUEUE=/tmp/polybar_notify
NOTIFY_LENGTH=3

cmd="${1}"
args="${@:2}"

echo "${args}" >> "${NOTIFY_QUEUE}"
initial_queue_stat="$(stat -c '%Y' ${NOTIFY_QUEUE})"

if [[ ! -f /tmp/polybar_config_bak ]]; then
    cp "${POLYBAR_CONFIG}" /tmp/polybar_config_bak
fi

if ! grep -q "modules-right = notify" "${POLYBAR_CONFIG}"; then
    sed -i "s/modules-right.*/modules-right = notify/" "${POLYBAR_CONFIG}"
fi

sleep "${NOTIFY_LENGTH}"

after_queue_stat="$(stat -c '%Y' ${NOTIFY_QUEUE})"

if [[ "${initial_queue_stat}" = "${after_queue_stat}" ]]; then
    cp /tmp/polybar_config_bak "${POLYBAR_CONFIG}"
    rm /tmp/polybar_config_bak
fi
