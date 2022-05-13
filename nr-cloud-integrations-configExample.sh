# New Relic
# test the gql api out
# for updating cloud integrations

## inputs
# user key
# account id -- for lookup
# cloud linked acct id -- for mutation

APIKEY='YOUR_NEW_RELIC_USER_API_KEY'
NR_ACCOUNT_ID='YOUR_NEW_RELIC_ACCOUNT_ID'
NR_LINKEDACCT_ID='YOUR_LINKED_ACCOUNT_ID'

## poling interval is in seconds
POLLING_INTERVAL='3600'
REGIONS='us-east-1'

###########
## Step 1 - Lookup integration names, store in array

integrations=`curl -s POST -H "Content-Type: application/json" \-H "API-Key:"${APIKEY} \
--data \ 
"{\"query\": \"{actor {account(id: $NR_ACCOUNT_ID) {cloud {linkedAccounts {id integrations {name id service{slug}}}}}}}\" }" https://api.newrelic.com/graphql | jq -r '.data.actor.account.cloud.linkedAccounts[0].integrations[].service '`
#echo $integrations 

# flattened version, w/ jq
#curl -s POST "https://api.newrelic.com/graphql" -H 'Content-Type: application/json' -H "API-Key:"${APIKEY} -d '{"query":  "{ actor { account(id: '${NR_ACCOUNT_ID}') { cloud { linkedAccounts { id integrations { name createdAt id nrAccountId updatedAt}}}}}}" } ' | jq -r . 

## Step 2 - For each in array, update the integration config

echo 
trimlist=`echo $integrations | jq -r '.[]'`
#echo $trimlist
for ci in `echo $trimlist`; do
  name=`echo $ci`
  if [$ci == 'aws_mq']; then
    name='mq'
  fi
  
  curl https://api.newrelic.com/graphql \
  -H "Content-Type: application/json" \
  -H "API-Key:"${APIKEY} \
  --data-binary '{"query":"mutation {\n  cloudConfigureIntegration(accountId: '$NR_ACCOUNT_ID', integrations: {aws: {'$name': {metricsPollingInterval: '$POLLING_INTERVAL', linkedAccountId: '$NR_LINKEDACCT_ID', awsRegions: \"'$REGIONS'\"}}}) {\n    errors {\n      message\n    }\n  }\n}\n", "variables":""}'
done
