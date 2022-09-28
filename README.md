With this repo you can setup edusharing and the Serlo editor to test the integration via LTI.

## Setup

- With the script [`update-edusharing-scripts.sh`](./update-edusharing-scripts.sh) you can update the deploy scripts of edusharing in the directory [`edusharing`](./edusharing) to the latest version and apply changes needed for the LTI setup on Linux.
- With the script [`deploy-all.sh`](./deploy-all.sh) you can start edusharing as well as the serlo editor. You can also use [`deploy-edusharing.sh`](./deploy-edusharing.sh) and [`deploy-serlo.sh`](./deploy-serlo.sh) to start the container separately.
- With the script [`register-serlo-editor.sh`](./register-serlo-editor.sh) the Serlo editor can be registered to edu-sharing.
