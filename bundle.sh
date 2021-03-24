#!/bin/bash
set -eo pipefail

echo -n "Bundling all of the charts..."

# Loop through every chart
for chart in charts/*; do
  # Combine the definitions.schema.yaml and charts/$chart/values.schema.yaml files
  # with the charts/$chart/values.schema.yaml file taking precedence
  # and output the merged YAML document as JSON.
  # See https://mikefarah.gitbook.io/yq/commands/merge
  # and https://mikefarah.gitbook.io/yq/usage/convert
  yq merge --overwrite --tojson definitions.schema.yaml "${chart}"/values.schema.yaml > "${chart}"/values.schema.json
  cat "${chart}"/values.schema.json
  #yq eval-all --tojson 'select(fileIndex == 0) * select(filename == "definitions.schema.yaml")' "${chart}"/values.yaml definitions.schema.yaml > "{chart}"/values.schema.new.json
  #sdiff -w 220  "{chart}"/values.schema.json "{chart}"/values.schema.new.json
done

echo "done"
