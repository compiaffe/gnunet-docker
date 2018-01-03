#!/bin/bash -e

echo "${LOCAL_PORT_RANGE:-49152 65535}" > /proc/sys/net/ipv4/ip_local_port_range

if [[ $# -eq 0 ]]; then
  exec gnunet-arm \
    --config=/etc/gnunet.conf \
    --start \
    --monitor
elif [[ -z $1 ]] || [[ ${1:0:1} == '-' ]]; then
  exec gnunet-arm "$@"
else
  exec "$@"
fi
