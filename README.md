With this repo you can deploy edu-sharing and the Serlo editor locally via
docker. It includes also scripts which configure the integration of the Serlo
editor into edu-sharing.

## Setup

For executing the scripts the following tools need to be installed:

- `python` with the library `requests` (e.g. run
  `pip install -r requirements.txt`)
- `docker` and `docker-compose`
- `bash` with the normal POSIX command line tools and `curl`

## Deployment

### Start everything

With the script [`deploy-all.sh`](./deploy-all.sh) you can start edusharing as
well as the serlo editor. After both components are set up the Serlo editor is
also registered into edusharing.

### Other deployment scripts

- With the script
  [`update-edusharing-scripts.sh`](./update-edusharing-scripts.sh) you can
  update the deploy scripts of edusharing in the directory
  [`edusharing`](./edusharing) to the latest version and apply changes needed
  for the LTI setup on Linux.
- You can use [`deploy-edusharing.sh`](./deploy-edusharing.sh) and
  [`deploy-serlo.sh`](./deploy-serlo.sh) to start the container separately.
- With the script [`register-serlo-editor.py`](./register-serlo-editor.py) the
  Serlo editor can be registered to edu-sharing.

## Helper scripts

- [`show-repository-service-manifest.sh`](./show-repository-service-manifest.sh):
  Shows the deployed `MANIFEST.MF` of the repository service which contains the
  commit message.
