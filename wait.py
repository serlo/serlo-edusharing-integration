#!/usr/bin/env python
#
# Helper scripts which waits until edu-sharing and serlo are running

import time

import requests

from utils import error, get_docker_container_id, call_edusharing_api, info

TIME_TO_WAIT=180

def wait_for_edusharing_and_serlo():
    info("Wait until edu-sharing and serlo are running")
    timestamp_before_loop = time.time()

    while True:
        if is_edusharing_running() and is_serlo_running():
            break

        if not is_edusharing_up():
            error("Docker container for edusharing is not up")

        if time.time() - timestamp_before_loop > TIME_TO_WAIT:
            tool = "edu-sharing" if not is_edusharing_running() else "serlo"
            error(f"We waited too long for {tool}")

        time.sleep(1)

def is_edusharing_up():
    return get_repository_service_id() != ""

def is_serlo_running():
    try:
        return requests.get("http://localhost:3000/").ok
    except:
        return False

def is_edusharing_running():
    try:
        return call_edusharing_api("/_about").ok
    except:
        return False

def get_repository_service_id():
    return get_docker_container_id("repository-service")

if __name__ == "__main__":
    wait_for_edusharing_and_serlo()
