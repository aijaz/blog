#!/usr/bin/env bash

set -e

FILE=$1
GZFILE=${FILE}.gz

if [ -f "${GZFILE}" ];  then
  if [ "${FILE}" -nt "${GZFILE}" ]; then
    zopfli "${FILE}"
  fi
else
  zopfli "${FILE}"
fi
