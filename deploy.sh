#!/bin/sh -e

load_tmp_env() { (set -a && source "$1" && shift && "${@}") }

load_tmp_env "./.env" zsh build.zsh
