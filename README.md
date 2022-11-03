With this repo you can deploy edu-sharing and the Serlo editor locally via
docker. It includes also scripts which configure the integration of the Serlo
editor into edu-sharing.

## Setup

For executing the scripts the following tools need to be installed:

- `python` with the library `requests` (e.g. run
  `pip install -r requirements.txt`)
- `docker` and `docker-compose`
- `bash` with the normal POSIX command line tools and `curl`

## Deployment via `./start.sh`

### Start serlo and edu-sharing

With [`./start.sh`](./start.sh) edu-sharing and the serlo editor are deployed
and configured so that the integration can be tested:

```bash
./start.sh
```

### Start only serlo / edu-sharing

`./start.sh` can also be used to only start edu-sharing / serlo:

```bash
# Start only edu-sharing
./start.sh edusharing

# Start only serlo
./start.sh serlo
```

### Stop containers

With [`./stop.sh`](./stop.sh) all containers can be stopped (it runs
`./docker-compose.sh down`).

## Behind the scenes (`./docker-compose.sh`)

We use `docker-compose` to deploy edu-sharing / serlo. The script
[`./docker-compose.sh`](./docker-compose.sh) is a wrapper around
`docker-compose` adding the configuration files and other configurations. All
arguments passed to `./docker-compose.sh` are passed to `docker-compose` as
well:

```bash
# Starts all containers
./docker-compose.sh up -d
```

With the environment variable `SETUP_PROFILE` one can set which containers shall
be started:

```bash
# Starts only edu-sharing
SETUP_PROFILE=edusharing ./docker-compose.sh up -d

# Starts only serlo
SETUP_PROFILE=serlo ./docker-compose.sh up -d
```

### Useful commands

```bash
# Show logs of edu-sharing's repository-service
./docker-compose.sh logs repository-service

# Show logs of the serlo editor
./docker-compose.sh logs editor

# Show all deployed container
./docker-compose.sh ps
```

## Configurations

### Configuration of edu-sharing

With the tool [`./configure-edusharing.py`](./configure-edusharing.py) the
integration of the Serlo editor can be configured on a locally running
edu-sharing. The following steps are necessary:

1. Register the serlo editor via Swagger (endpoint
   `/ltiplatform/v13/manual-registration`) or in the LTI admin panel (maybe
   delete any old registration of a serlo editor).
2. For the newly added serlo editor the option `ltitool_customcontent_option`
   needs to be set to `true`.
3. Overwrite the cluster configuration with
   `angular.headers.X-Frame-Options: "allow-from http://localhost:3000"`
4. Add property `allowed_authentication_types` with value `true` in
   `homeApplication.properties.xml`.
5. Remove `app-editor2.properties.xml` in the edu-sharing container.
6. Register the serlo editor as a platform via swagger (endpoint
   `/lti/v13/registration/static`) or via the admin console.

### Configuration of serlo

With the tool [`./configure-serlo.sh`](./configure-serlo.sh) the serlo editor
can be configured. Note that this script needs to be run _after_ edu-sharing was
configured (especially after the serlo tool was added). The configuration steps
of this script are:

1. Update `PLATFORM_CLIENT_ID` to the value which was given by edu-sharing.

## Helper scripts

There are several helper scripts in the directory [`scripts`](./scripts),
namely:

- With the script
  [`update-edusharing-scripts.sh`](./scripts/update-edusharing-scripts.sh) you
  can update the deploy scripts of edusharing in the directory
  [`edusharing`](./edusharing) to the latest version and apply changes needed
  for the LTI setup on Linux.
- [`show-repository-service-manifest.sh`](./scripts/show-repository-service-manifest.sh):
  Shows the deployed `MANIFEST.MF` of the repository service which contains the
  commit message.
- [`edit-editor-server-file.sh`](./scripts/edit-editor-server-file.sh): Edits
  the `server.js` in the editor container which is useful in debugging.
