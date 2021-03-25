#!/bin/bash
set -xeo pipefail

echo -n "Bundling all of the charts..."

# Loop through every chart
for chart in charts/*; do
  echo $chart
  ls  ${chart}/values.schema.yaml
  # Combine the definitions.schema.yaml and charts/$chart/values.schema.yaml files
  # with the charts/$chart/values.schema.yaml file taking precedence
  # and output the merged YAML document as JSON.
  # See https://mikefarah.gitbook.io/yq/commands/merge
  # and https://mikefarah.gitbook.io/yq/usage/convert
  JSON_SCHEMA="${chart}/values.schema.json"
  ls "$JSON_SCHEMA"
  if [ ! -f "$JSON_SCHEMA" ] 
  then
    echo "File $FILE does not exist"
    touch "$JSON_SCHEMA"
    ls "$JSON_SCHEMA"
  fi
  yq eval-all --tojson 'select(fileIndex == 0) * select(filename == \"$chart\"/values.schema.yaml)' definitions.schema.yaml "${chart}"/values.schema.yaml > "${chart}"/values.schema.json
done

echo "done"
