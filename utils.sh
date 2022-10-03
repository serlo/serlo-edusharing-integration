function get_container_id {
  docker ps -f "name=$1" -q
}

function info {
  echo "INFO: $@" 1>&2
}

function error {
  echo "ERROR: $@" 1>&2
  exit 1
}
