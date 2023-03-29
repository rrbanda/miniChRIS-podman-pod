# ![ChRIS logo](https://raw.githubusercontent.com/FNNDSC/ChRIS_ultron_backEnd/master/docs/assets/logo_chris.png) miniChRIS-podman

[![CI badge](https://github.com/FNNDSC/miniChRIS-podman/workflows/CI/badge.svg)](https://github.com/FNNDSC/miniChRIS-podman/actions?query=workflow%3ACI)
[![MIT license](https://img.shields.io/github/license/FNNDSC/miniChRIS-podman)](LICENSE)

Run [_ChRIS_](https://chrisproject.org/) using [Podman](https://podman.io).

## Abstract

_miniChRIS-podman_ is a fork of [_miniChRIS-docker_](https://github.com/FNNDSC/miniChRIS-docker)
which uses Podman instead of Docker.
See
[miniChRIS-docker/README.md](https://github.com/FNNDSC/miniChRIS-docker#readme) for more info.

Image tags are pinned to stable versions, so _miniChRIS_ might be
out-of-date with development versions of _ChRIS_ components.

_miniChRIS-podman_ is not suitable as a development environment
for the _ChRIS_ services themselves, please see their respective
respositories for information on how to run them in development mode.

### _miniChRIS-podman_ Project Goals

- Support for rootless Podman :white_check_mark:
- Support Podman with minimal dependencies, i.e. without container networking (WIP, HELP WANTED)
- Legible, minimal bash scripts to be run on system. Put whatever we can into containers!
- Feature parity with _miniChRIS-docker_

### System Requirements

- Python 3.8 or above
- Rootless Podman version 3 or version 4
- podman-dnsname (name resolution for containers)

On Arch Linux, please consult the wiki: https://wiki.archlinux.org/title/Podman

Here's what worked for me on 2023-03-17 (possibly helpful, definitely outdated info)

```shell
sudo pacman -Syu --needed python podman podman-dnsname
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER
```

## Quick Start

```bash
git clone https://github.com/FNNDSC/miniChRIS-podman.git
cd miniChRIS-podman
./minichris.sh
```

### Tear Down

```bash
./minichris.sh destroy
```

### Not Working?

idk, ask Jennings... https://matrix.to/#/@jennydaman:fedora.im

## Usage

A default superuser `chris:chris1234` is created.

website        | URL
---------------|-----
ChRIS_ui       | http://localhost:8020/
ChRIS admin    | http://localhost:8000/chris-admin/
ChRIS_store_ui | http://localhost:8021/
Orthanc        | http://localhost:8042/

### Default Logins

website      | username | password
-------------|----------|----------
ChRIS        | chris    | chris1234
ChRIS Store  | chris    | chris1234
Orthanc      | orthanc  | orthanc

### Network Configuration

To run _miniChRIS_ remotely it is necessary to replace occurrences of `localhost`
with your machine's hostname or IP address in `podman-compose.yml`.

```shell
sed -i -e 's/localhost/my_machines_hostname/' podman-compose.yml
./minichris.sh up
```

### Add Plugins to CUBE

Plugins are added to _ChRIS_ via the Django admin dashboard.

https://github.com/FNNDSC/ChRIS_ultron_backEnd/wiki/%5BHOW-TO%5D-Register-a-plugin-via-Django-dashboard

Alternatively, plugins can be added declaratively.
A common use case would be to run locally built Python
[`chris_plugin`](https://github.com/FNNDSC/chris_plugin)-based
_ChRIS_ plugins. These can be added using `chrisomatic` by
listing their (docker) image tags. For example, if your local image
was built with the tag `localhost/myself/pl-workinprogress` by running

```shell
docker build -t localhost/myself/pl-workinprogress .
```

The bottom of your `chrisomatic.yml` file should look like

```yaml
  plugins:
    - name: pl-dircopy
      version: 2.1.1
    - name: pl-tsdircopy
      version: 1.2.1
    - name: pl-topologicalcopy
      version: 0.2
    - name: pl-simpledsapp
      version: 2.1.0
    - localhost/myself/pl-workinprogress
```

After modifying `chrisomatic.yml`, apply the changes by running `./chrisomatic.sh`

For details, see https://github.com/FNNDSC/chrisomatic#plugins-and-pipelines

### Performance

`./minichris.sh` takes ~60 seconds on a decent laptop (quad-core, 16 GB, SSD)
and takes ~3 minutes in [Github Actions' Ubuntu VMs](https://github.com/FNNDSC/miniChRIS-podman/actions).
It is strongly recommended that you use an SSD!

### podman-compose Issues to Watch

 - https://github.com/containers/podman-compose/issues/88
 - https://github.com/containers/podman-compose/issues/430
