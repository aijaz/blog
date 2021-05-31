#!/usr/bin/env bash

set -e

FILE=$1
GZFILE=${FILE}.gz

echo "FILE: ${FILE}, GZFILE={$GZFILE}"

if [ -f "${GZFILE}" ];  then
  if [ "${FILE}" -nt "${GZFILE}" ]; then
    echo "Compressing1 ${FILE}"
    zopfli "${FILE}"
  else
    echo "Skipping ${FILE}"
  fi
else
  echo "Compressing2 ${FILE}"
  zopfli "${FILE}"
fi
