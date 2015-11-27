params = BrpmAuto.params
jira_rest_client = JiraRestClient.new

BrpmAuto.log "Getting issue #{params["issue_id"]}..."
issue = jira_rest_client.get_issue(params["issue_id"])

raise "This issue doesn't exist" unless issue

BrpmAuto.log "Setting the status of issue #{params["issue_id"]} to #{params["target_issue_status"]}..."
transition = jira_rest_client.set_issue_to_status(params["issue_id"], params["target_issue_status"])

raise "This status is not allowed" unless transition