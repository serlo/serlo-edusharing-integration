With this repo you can deploy edu-sharing and the Serlo editor locally via
docker. It includes also scripts which configure the integration of the Serlo
editor into edu-sharing.

The serlo editor container is build by:
https://github.com/serlo/ece-as-a-service

## Setup

For executing the scripts the following tools need to be installed:

- `python` with the library `requests` (e.g. run
  `pip install -r requirements.txt`)
- `docker` and `docker-compose`
- `bash` with the normal POSIX command line tools and `curl`

Edu-sharings runs on the domain `repository.127.0.0.1.nip.io:8100`. Make sure
that this domains resolves to localhost (e.g.
`host http://repository.127.0.0.1.nip.io:8100` should show `127.0.0.1` as a
result). If it is not the case update `/etc/hosts` with the following lines:

```
127.0.0.1       repository.127.0.0.1.nip.io
127.0.0.1       rendering.services.127.0.0.1.nip.io
```

## Run

With [`./start.sh`](./start.sh) edu-sharing and the serlo editor are pulled,
deployed and configured.

```bash
./start.sh
```

You can open edu-sharing under
http://repository.127.0.0.1.nip.io:8100/edu-sharing/components/login. The
username and password is `admin`.

The serlo editor is pulled from: `https://github.com/serlo/ece-as-a-service/`
(main branch)

The edu-sharing container is pulled from `edu-sharing.com`.

### Stop containers

With [`./stop.sh`](./stop.sh) all containers can be stopped (it runs
`./docker-compose.sh down`).

### Start only serlo / edu-sharing

`./start.sh` can also be used to only start edu-sharing / serlo:

```bash
# Start only edu-sharing
./start.sh edusharing

# Start only serlo
./start.sh serlo
```

### Connect edu-sharing container to a running development instance of the editor

This is useful if you do not want to use the editor docker container pulled from
the repo but instead use a local running instance during development.

1. Run `yarn start:server` in your local editor repo. This wont terminate, open
   a new console window.
2. Run `./start.sh edusharing`in this repo to pull and deploy only the
   edu-sharing container. This can take some time, wait until it is finished.
3. Run `./configure-edusharing.py` in this repo to register the running editor
   instance with the running edu-sharing container. This also can take some
   time, wait until it is finished.
4. Search for `INFO: Serlo Editor registered. ID: FTHmXJS0fSqXp4a` in the
   console output of `./start.sh edusharing`. Copy the id into the editor repo
   .env file under `EDITOR_CLIENT_ID_FOR_LAUNCH` and save. This should restart
   the running instance of the editor.

Now, the editor and edu-sharing are connected. Changes to the editor code will
restart the editor instance without affecting the connection.

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
