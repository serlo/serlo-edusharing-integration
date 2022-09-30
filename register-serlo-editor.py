#!/usr/bin/env python

import subprocess
import sys
import time

import requests

from requests.auth import HTTPBasicAuth

TIME_TO_WAIT_FOR_EDUSHARING=180

def main():
    wait_until_edusharing_is_running()

    for tool_id in get_current_lti_tool_ids():
        delete_lti_tool(tool_id)

    print(get_current_lti_tool_ids())

def delete_lti_tool(tool_id):
    call_edusharing_api("/rest/admin/v1/applications/" + tool_id, method="DELETE")

def get_current_lti_tool_ids():
    reponse = call_edusharing_api("/rest/ltiplatform/v13/tools").json()

    return [tool["appId"] for tool in reponse["tools"]]

def wait_until_edusharing_is_running():
    timestamp_before_loop = time.time()

    while True:
        if is_edusharing_running():
            break

        if not is_edusharing_up():
            error("Docker container for edusharing is not up")

        if time.time() - timestamp_before_loop > TIME_TO_WAIT_FOR_EDUSHARING:
            error("We waited too long")

        time.sleep(1)

def is_edusharing_up():
    return get_repository_service_id() != ""

def is_edusharing_running():
    try:
        return call_edusharing_api("/rest/_about").ok
    except:
        return False

def call_edusharing_api(path, method="GET"):
    url = "http://repository.127.0.0.1.nip.io:8100/edu-sharing" + path

    return requests.request(method, url, auth=HTTPBasicAuth("admin", "admin"))

def get_repository_service_id():
    return get_docker_container_id("repository-service")

def get_docker_container_id(name):
    return subprocess.check_output(f"docker ps -q -f 'name={name}'",
                                   shell=True).decode().strip()

def error(message):
    print(f"ERROR: {message}", file=sys.stderr)
    sys.exit(1)

if __name__ == "__main__":
    main()
