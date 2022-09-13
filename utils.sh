function error {
  echo "ERROR: $@" 1&>2
  exit 1
}
