#!/bin/bash -e

if [[ $# -eq 0 ]]; then
  /usr/local/bin/gnunet-arm \
    --config=/etc/gnunet.conf \
    --start && \
  /usr/local/bin/gnunet-arm \
    --monitor
elif [[ -z $1 ]] || [[ ${1:0:1} == '-' ]]; then
  exec /usr/local/bin/gnunet-arm "$@"
else
  exec "$@"
fi
