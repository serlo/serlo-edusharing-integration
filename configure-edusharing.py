#!/usr/bin/env python

import requests

from utils import error, call_edusharing_api, get_current_lti_tool_ids, \
        get_current_editor_id, info
from wait import wait_for_edusharing_and_serlo

def main():
    wait_for_edusharing_and_serlo()

    info("Delete all LTI tools in edu-sharing")
    delete_all_current_lti_tools()

    info("Register serlo editor")
    register_new_serlo_editor()

    info("Set `ltitool_customcontent_option` to `true`")
    tool_ids = get_current_lti_tool_ids()
    assert len(tool_ids) == 1
    add_ltitool_customcontent_option(tool_ids[0])

    info("Serlo Editor registered. ID: %s" % get_current_editor_id())

    info("Update 'Cluster-Override'")
    update_cluster_override()

    info("Set `allowed_authentication_methods` to `true`")
    set_allowed_authentication_types()

def delete_all_current_lti_tools():
    for tool_id in get_current_lti_tool_ids():
        delete_lti_tool(tool_id)

def delete_lti_tool(tool_id):
    call_edusharing_api("/admin/v1/applications/" + tool_id, method="DELETE")

def register_new_serlo_editor():
    response = call_edusharing_api(
        "/ltiplatform/v13/manual-registration",
        method="POST",
        json={
            "toolName": "Serlo Editor",
            "toolUrl": "http://localhost:3000/lti",
            "toolDescription": "Serlo Editor",
            "keysetUrl": "http://host.docker.internal:3000/lti/keys",
            "loginInitiationUrl": "http://localhost:3000/lti/login",
            "redirectionUrls": [ "http://localhost:3000/lti" ],
            "customParameters": [],
            "logoUrl": "https://de.serlo.org/_assets/apple-touch-icon.png",
            "targetLinkUri": "http://localhost:3000/lti",
            "targetLinkUriDeepLink": "http://localhost:3000/lti",
            "clientName": "Serlo Editor"
        }
    )

    if not response.ok:
        error(response.text)

def add_ltitool_customcontent_option(tool_id):
    properties_path = f"/admin/v1/applications/app-{tool_id}.properties.xml"
    properties = call_edusharing_api(properties_path).json()

    properties["ltitool_customcontent_option"] = "true"

    call_edusharing_api(properties_path, json=properties, method="PUT")

def update_cluster_override():
    call_edusharing_api(
        "/admin/v1/configFile?filename=edu-sharing.override.conf&pathPrefix=CLUSTER",
        method="PULL",
        data='angular.headers.X-Frame-Options: "allow-from http://localhost:3000"'
    )

def set_allowed_authentication_types():
    properties_path = f"/admin/v1/applications/homeApplication.properties.xml"
    properties = call_edusharing_api(properties_path).json()

    properties["allowed_authentication_types"] = "lti"

    call_edusharing_api(properties_path, json=properties, method="PUT")

if __name__ == "__main__":
    main()
