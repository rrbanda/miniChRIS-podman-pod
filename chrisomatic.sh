#!/bin/bash -e

HERE="$(dirname "$(readlink -f "$0")")"
SOCK="$(podman info --format '{{ .Host.RemoteSocket.Path }}')"

set -x

if ! [ -v CI ]; then
  tty_flags=-it
fi

exec podman run --rm $tty_flags --network=host \
  -v "$HERE/chrisomatic.yml:/chrisomatic.yml:ro" \
  -v "$SOCK:/var/run/docker.sock:rw" \
  ghcr.io/fnndsc/chrisomatic:0.4.1 chrisomatic "$@"
