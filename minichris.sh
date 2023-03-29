#!/bin/bash -e
# purpose: start up miniChRIS using podman-compose


HERE="$(dirname "$(readlink -f "$0")")"
VENV="$HERE/.venv"
VERBOSE=true
PLUGIN_INSTANCE_LABELS='org.chrisproject.miniChRIS=plugininstance'


# print command to run before running in verbose mode
function verb () {
  if [ "$VERBOSE" = 'true' ]; then
    set -x
  fi
  $@ # run the given command
  { set +x; } 2> /dev/null
}

# Wrapper for development version of podman-compose
function podman-compose () {
  { set +x; } 2> /dev/null
  if ! [ -d "$VENV" ]; then
    verb python3 -m venv "$VENV"
  fi
  source "$VENV/bin/activate"
  if ! [ -f "$VENV/bin/podman-compose" ]; then
    verb pip3 install https://github.com/containers/podman-compose/archive/devel.tar.gz
  fi

  export PODMAN_HOST="$(podman info --format '{{ .Host.RemoteSocket.Path }}')"
  # export PODMAN_USERNS=keep-id
  verb "$VENV/bin/podman-compose" "$@"
}

# Exit the program with an error message
function die () {
  printf "%s: " "$(tput setaf 1)error$(tput sgr0)"
  echo "$@"
  tput sgr0
  exit 1
}

if [ "$(podman info --format '{{ .Host.RemoteSocket.Exists }}')" != 'true' ]; then
  echo "$(tput setaf 1)error$(tput sgr0): podman socket must be active for pman."
  echo "try running:"
  echo
  echo "    systemctl --user start podman.service"
  echo
  exit 1
fi

subcommand="${1:-start}"

case "$subcommand" in
  start )
    podman-compose up -d
    "$HERE/chrisomatic.sh" ;;
  up)
    podman-compose up -d ;;
  dow*)
    podman-compose down ;;
  des*)
    pls=$(podman ps -q -f 'label=org.chrisproject.miniChRIS=plugininstance')
    [ -z "$pls" ] || verb podman rm -fiv $pls
    podman-compose down -v
    rm -rf "$VENV" ;;
  com* | podman-compose)
    shift
    podman-compose "$@" ;;
  *)
    die "unrecognized subcommand $(tput bold)$subcommand";;
esac
