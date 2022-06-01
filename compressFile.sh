#!/usr/bin/env bash


set -e

cd output_stage

for FILE in `find output -type f -not -name '*.gz' -not -name '*.gif' -not -name '*.jpg' -not -name '*.png' -not -name '.DS_Store' `; do
  GZFILE=${FILE}.gz

  echo $FILE
  if [ -f "${GZFILE}" ];  then
      if [ "${FILE}" -nt "${GZFILE}" ]; then
      echo "Compressing newer than '$GZFILE'"
      zopfli "${FILE}"
    fi
  else
     echo "Compressing to non-existent '$GZFILE'"
    zopfli "${FILE}"
  fi
done


