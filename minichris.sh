#!/bin/bash
set -xe 
# -----------------------------------------------------------------------------
#
#                       TERMINAL OUTPUT COLOR HELPERS
#
# -----------------------------------------------------------------------------

# override tput so that it doesn't run in environments which does not support color

__REAL_TPUT=$(which tput)

function tput () {
  if ! [ -v CI ] && [[ "$TERM" = xterm* ]]; then
    $__REAL_TPUT "$@"
  fi
}

# define output colors
BOLD="$(tput bold)"
DIM="$(tput dim)"
UNDERLINE="$(tput smul)"
RESET="$(tput sgr0)"
RED="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"

# Apply styles to text
function style_text () {
  printf "$1%s$RESET" "$2"
}


# -----------------------------------------------------------------------------
#
#                               HELPER FUNCTIONS
#
# -----------------------------------------------------------------------------


function minichris_chrisomatic () {
  if ! [ -v CI ]; then
    tty_flags=-it
  fi

  noisy_sh podman run --rm $tty_flags \
    --pod $CUBE_POD \
    --security-opt label=disable \
    -v "\"$(pwd "$HERE")/chrisomatic.yml:/chrisomatic.yml:ro\"" \
    -v "$SOCK:/var/run/docker.sock:rw" \
    ghcr.io/fnndsc/chrisomatic:0.4.1 chrisomatic "$@"
}

function minichris_down () {
  noisy_sh "cat $HERE/kube/*.yml $HERE/pfcon-podman.yml | exec podman kube down --force -"
}

function minichris_up () {
  start_cube
  start_pfcon
  minichris_chrisomatic
}

function start_cube () {
  watch_for_logs $INIT_CONTAINER &
  noisy_sh "cat $HERE/kube/*.yml | podman kube play --replace -"
  reap_background_wait
}

function start_pfcon () {
  local hard_coded_sock=/run/user/1000/podman/podman.sock
  noisy_sh "sed \"s#$hard_coded_sock#$SOCK#\" $HERE/pfcon-podman.yml | podman kube play --replace -"
}

# Follow the logs of a container which has not yet been created and/or started.
# Returns the lock file for the waiting process, refer to run_in_background
function watch_for_logs () {
  wait_until_running $1
  noisy_sh podman logs --follow $1
}

# Poll Podman until a container is running.
function wait_until_running () {
  while sleep 0.5; do
    if [ -n "$(podman ps -f name=$1 -f status=running --quiet)" ]; then
      break
    fi
  done
}

# Check whether there is a background job running.
function is_bg_running () {
  # we need to check twice:
  # if bg finished, `jobs %%` will indicate "done" the first time, then error on the next.
  # if bg running, `jobs %%` will indicate "running" twice.
  # if no bg job, `jobs %%` will error on the first call.
  jobs %% > /dev/null 2>&1 && jobs %% > /dev/null 2>&1
}

# If we're waiting in the background for the initContainer logs, stop and print a warning.
function reap_background_wait () {
  if is_bg_running; then
    style_text "$YELLOW" "warning"
    echo ": missed poll for initContainer '$INIT_CONTAINER'"
    kill %%
    return 1
  elif [ "$rc" = 1 ]; then
    die "poll for initContainer exited with code $rc"
  fi

}

# Print the arguments and run them using sh.
# Exits if the command fails.
function noisy_sh () {
  style_text "$DIM" "\$ $*"
  echo
  set -e
  sh -ec "$*"
  set +e
}

# Exit the program with an error message
function die () {
  style_text "$RED" "error: "
  echo "$@"
  exit 1
}

# -----------------------------------------------------------------------------
#
#                                   CONSTANTS
#
# -----------------------------------------------------------------------------

CUBE_POD=minichris-cube-pod
INIT_CONTAINER=minichris-cube-pod-migratedb

HERE="${0%/*}"
SOCK="$(podman info --format '{{ .Host.RemoteSocket.Path }}')"

USAGE="
Run ChRIS on Podman.

$(style_text "$BOLD$UNDERLINE" "Usage:") $0 [up|down|chrisomatic]

$(style_text "$BOLD$UNDERLINE" "Commands:")

  $(style_text "$BOLD" "up")             start or update ChRIS
  $(style_text "$BOLD" "down")           stop ChRIS and delete data
  $(style_text "$BOLD" "chrisomatic")    sync plugins from $HERE/chrisomatic.yml file to CUBE
"


# -----------------------------------------------------------------------------
#
#                               PRE-FLIGHT CHECKS
#
# -----------------------------------------------------------------------------

# the helper function noisy_sh will misbehave if $HERE contains shell-sensitive syntax
if [[ "$HERE" = *" "* ]]; then
  die "Directory '$HERE' contains space characters, please rename it!"
fi

if [ "$(podman info --format '{{ .Host.RemoteSocket.Exists }}')" != 'true' ]; then
  echo "$(tput setaf 1)error$(tput sgr0): podman socket must be active for pman."
  echo "try running:"
  echo
  echo "    systemctl --user start podman.service"
  echo
  exit 1
fi

# -----------------------------------------------------------------------------
#
#                                 RUN COMMAND
#
# -----------------------------------------------------------------------------

# show help and exit
for arg in "$@"; do
  if [[ "$arg" =~ ^-*h|help$ ]]; then
    echo "$USAGE"
    exit 0
  fi
done

subcommand="${1:-up}"

case "$subcommand" in
  u|up )
    minichris_up
    ;;
  d|down )
    minichris_down
    ;;
  c|chrisomatic )
    minichris_chrisomatic
    ;;
  *)
    die "unrecognized command $(style_text "$BOLD" "$subcommand")"
    ;;
esac
