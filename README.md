# nr-cloud-integrations-polling-config-example
Example script to loop through all integrations for one NR account and update polling interval and region.

To Use:
1. Update the inputs in the script to set User API key, account id, linked account id, and parameters to change (ie: polling interval, regions, tags, etc.)
2. Save and run, verify in NR changes (either querying again from API or in UI)
3. Rinse and repeat across linked accounts

Note - New Relic's graphql returns the wrong name and slug for AWS MQ, FYI

This was tested aginsst AWS integrations only, GCP/Azure likely work similar but script may need a little tweak.
