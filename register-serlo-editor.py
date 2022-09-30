#!/usr/bin/env python

import time

import requests

from utils import error, get_docker_container_id, call_edusharing_api, get_current_lti_tool_ids

TIME_TO_WAIT_FOR_EDUSHARING=180

def main():
    wait_until_edusharing_is_running()

    for tool_id in get_current_lti_tool_ids():
        delete_lti_tool(tool_id)

    register_new_serlo_editor()

    tool_ids = get_current_lti_tool_ids()

    assert len(tool_ids) == 1

    add_ltitool_customcontent_option(tool_ids[0])
    print("Serlo Editor registered. ID: %s" % tool_ids[0])

def add_ltitool_customcontent_option(tool_id):
    properties_path = f"/admin/v1/applications/app-{tool_id}.properties.xml"
    properties = call_edusharing_api(properties_path).json()

    properties["ltitool_customcontent_option"] = "true"

    call_edusharing_api(properties_path, json=properties, method="PUT")

def register_new_serlo_editor():
    if not is_serlo_running():
        error("Serlo editor is not running")

    call_edusharing_api("/ltiplatform/v13/manual-registration",
                        method="POST",
                        json={
                          "toolName": "Serlo Editor",
                          "toolUrl": "http://localhost:3000/lti",
                          "toolDescription": "Serlo Editor",
                          "keysetUrl": "http://host.docker.internal:3000/lti/keys",
                          "loginInitiationUrl": "http://localhost:3000/lti/login",
                          "redirectionUrls": [
                            "http://localhost:3000/lti"
                          ],
                          "customParameters": [],
                          "logoUrl": "https://de.serlo.org/_assets/apple-touch-icon.png",
                          "targetLinkUri": "http://localhost:3000/lti",
                          "targetLinkUriDeepLink": "http://localhost:3000/lti",
                          "clientName": "Serlo Editor"
                        })

def delete_lti_tool(tool_id):
    call_edusharing_api("/admin/v1/applications/" + tool_id, method="DELETE")

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

def is_serlo_running():
    try:
        return requests.get("http://localhost:3000/").ok
    except:
        return False

def is_edusharing_running():
    #try:
        return call_edusharing_api("/_about").ok
    #except:
    #    return False

def get_repository_service_id():
    return get_docker_container_id("repository-service")

if __name__ == "__main__":
    main()
