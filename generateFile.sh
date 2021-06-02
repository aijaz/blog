#!/usr/bin/env bash

set -e

FILE=$1
TYPE=$2
BASEFILE=$(basename "${FILE}" ".${TYPE}")
BASEDIR=$PWD
INPUTDIR=${BASEDIR}/content
OUTPUTDIR=${BASEDIR}/output
PUBLISHCONF=${BASEDIR}/publishconf.py

echo pelican "${INPUTDIR}" -o "${OUTPUTDIR}" -s "${PUBLISHCONF}" "${PELICANOPTS}" --write-selected "${FILE}"
pelican "${INPUTDIR}" -o "${OUTPUTDIR}" -s "${PUBLISHCONF}" "${PELICANOPTS}" --write-selected "${FILE}"

find "${OUTPUTDIR}" -type f -name "${BASEFILE}.html" -exec ./imageCaption.pl --publish --file={} \;

zopfli "${FILE}"
