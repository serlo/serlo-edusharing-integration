import subprocess
import sys

import requests

from requests.auth import HTTPBasicAuth

def get_current_editor_id():
    tool_ids = get_current_lti_tool_ids()

    assert len(tool_ids) == 1

    # Remove deployment ID from the tool_id
    return tool_ids[0][:-1]

def get_current_lti_tool_ids():
    reponse = call_edusharing_api("/ltiplatform/v13/tools").json()

    return [tool["appId"] for tool in reponse["tools"]]

def call_edusharing_api(path, method="GET", json=None):
    url = "http://repository.127.0.0.1.nip.io:8100/edu-sharing/rest" + path
    additional_args = { "json": json } if json != None else {}

    return requests.request(method, url, auth=HTTPBasicAuth("admin", "admin"),
                            **additional_args)

def get_docker_container_id(name):
    return subprocess.check_output(f"docker ps -q -f 'name={name}'",
                                   shell=True).decode().strip()

def error(message):
    print(f"ERROR: {message}", file=sys.stderr)
    sys.exit(1)
