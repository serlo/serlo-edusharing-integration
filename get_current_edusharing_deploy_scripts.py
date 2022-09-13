#!/usr/bin/env python

import json
import requests

BASE_NODE = "org/edu_sharing/edu_sharing-projects-community-deploy-docker-compose/maven-feature-ltiplatform-8.1-SNAPSHOT"

def main():
    lti_artefacts = list_artefacts(BASE_NODE)

    current_artefact = [x for x in lti_artefacts
                        if x["type"] == "component"][-1]

    assets = list_artefacts(current_artefact["id"])
    zip_asset = next(x for x in assets if x["id"].endswith(".zip"))

    zip_url = ("https://artifacts.edu-sharing.com/repository/maven-remote/%s/%s" 
               % (BASE_NODE, zip_asset["text"]))

    print(zip_url)

def print_json(data):
    print(json.dumps(data, indent=2))

def list_artefacts(node):
    return requests.post("https://artifacts.edu-sharing.com/service/extdirect",
                         json={
                             "action":"coreui_Browse",
                             "method":"read",
                             "data": [
                                 {
                                     "repositoryName":"maven-remote",
                                     "node": node
                                 }
                             ],
                             "type":"rpc",
                             "tid":11
                         }).json()["result"]["data"]

if __name__ == "__main__":
    main()
