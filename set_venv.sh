#! /bin/bash

CONDA_ROOT=~/.local/miniforge3

usage() {
    echo "usage: ${0##*/} <conda env name> [venv name]"
    exit 1
}

while getopts ":h" opt; do
    case $opt in
        h) usage ;;
    esac
done
shift $((OPTIND - 1))

conda_env_name=$1
venv_name=${2:-venv}

[ -z "$conda_env_name" ] && usage

. "${CONDA_ROOT}/etc/profile.d/conda.sh" &&
conda activate $conda_env_name &&
rm -rf $venv_name &&
python -m venv $venv_name
