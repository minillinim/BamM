#!/usr/bin/env bash
set -ue
#
# This file hides some docker mess from the user
#

bamm_image="minillinim/bamm:latest"

display_usage() {
  echo "

  Usage for image: ${bamm_image}

  This is a bash wrapper of the BamM docker image. When run, it will map the current
  folder you're in to /app/data inside the image. So always specify paths to data
  relative to a subset of a SUB-directory of the folder you're in when you it.

  Assuming a folder structure like:

    /path/to/current/folder
    ├── contigs
    │   └── assembly.fasta
    ├── reads
    │   ├── sample1.fastq
    │   ├── ...

  Then you can run:

    /path/to/bamm.sh make -d contigs/assembly.fa -i reads/sample1.fastq ...

  You can run any command in BamM like this. See BamM help below
  "
  docker run --rm -it "${bamm_image}"

  exit ${1}
}

# Process the arguments
subcommand="${1:-help}" && shift || true
if [[ ${subcommand} == "help" ]]; then
  display_usage 0
fi

if [[ ${subcommand} == "build" ]]; then
  docker build -t minillinim/bamm:latest "${1}"
  exit 0
fi

docker \
  run \
  -v $PWD:/app/data \
  --rm -it \
  "${bamm_image}" \
  /bin/bash -c "cd /app/data && bamm ${subcommand} $*"
