#!/bin/bash

revision_info=$(curl -H "Authorization: Basic $base64encoded" "https://api.enterprise.apigee.com/v1/organizations/dayakarg-eval/apis/HelloWorld/deployments") 

previous_revision_number=$(jq -r .environment[0].revision[0].name <<< "${revision_info}" ) 

echo $previous_revision_number
