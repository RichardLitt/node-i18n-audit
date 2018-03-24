#!/bin/sh

declare -a arr=(
  'nodejs-es'
  'nodejs-nl'
  'nodejs-id'
  'nodejs-pt'
  'nodejs-tr'
  'nodejs-de'
  'nodejs-ja'
  'nodejs-uk'
  'nodejs-zh-CN'
  'nodejs-zh-TW'
  'nodejs-fr'
  'nodejs-nl'
  'nodejs-he'
  'nodejs-it'
  'nodejs-hi'
  'nodejs-pl'
)

getStatistics () {
  GROUP=$1 # Rename it to be less confusing
  OUTPUT=$GROUP'-audit.md'
  INPUT=$GROUP'.json'
  RESULTS='node-audit.md'

  touch $OUTPUT
  > $OUTPUT
  echo '## nodejs/'$GROUP' audit' >> $OUTPUT
  echo '' >> $OUTPUT
  echo '_This list was automatically generated with the following command:_' >> $OUTPUT
  echo '' >> $OUTPUT
  echo '```sh' >> $OUTPUT
  echo '$ name-your-contributors -u nodejs -r '$GROUP' -a 2017-03-01' >> $OUTPUT
  echo '```' >> $OUTPUT
  echo '' >> $OUTPUT

  name-your-contributors -u nodejs -r $GROUP -a 2017-03-01 > $INPUT

  cat $INPUT | jq '.issueCommentators | map(select(.login != "obensource")) | map(select(.login != "hackygolucky")) | "There were \(. | length) issue commentators who made \(map(.count) | add) comments."' -r >> $OUTPUT
  cat $INPUT | jq '.reviewers | map(select(.login != "obensource")) | map(select(.login != "hackygolucky")) | "There were \(. | length) reviewers who made \(map(.count) | add) review comments."' -r >> $OUTPUT
  cat $INPUT | jq '.issueCreators | map(select(.login != "obensource")) | map(select(.login != "hackygolucky")) | "There were \(. | length) issue creators who made \(map(.count) | add) issues."' -r >> $OUTPUT
  cat $INPUT | jq '.prCommentators | map(select(.login != "obensource")) | map(select(.login != "hackygolucky")) | "There were \(. | length) PR commentators who made \(map(.count) | add) comments."' -r >> $OUTPUT
  cat $INPUT | jq '.prCreators | map(select(.login != "obensource")) | map(select(.login != "hackygolucky")) | "There were \(. | length) PR creators who made \(map(.count) | add) prs."' -r >> $OUTPUT

  echo '' >> $OUTPUT

  # Copy everything to a master file
  touch $RESULTS
  cat $OUTPUT >> $RESULTS
}

touch node-audit.md
echo '# Node i18n Groups Audit' > node-audit.md
echo '' >> node-audit.md

for i in "${arr[@]}"
do
  getStatistics "$i"
done







