brpm_rest_client = BrpmRestClient.new
params = BrpmAuto.params

BrpmAuto.log  "Getting the tickets that are linked to the request..."
tickets = brpm_rest_client.get_tickets_by_request_id(params.rest_request_id)

if tickets.count == 0
  BrpmAuto.log "This request has no tickets, nothing further to do."
  exit
end

if params["target_issue_status"].nil? or params["target_issue_status"].empty?
  BrpmAuto.log  "Getting the stage of this request..."
  request_with_details = brpm_rest_client.get_request_by_id(params.rest_request_id)

  if request_with_details.has_key?("plan_member")
    stage_name = request_with_details["plan_member"]["stage"]["name"]

    params["target_issue_status"] = "Deployed to #{stage_name}"
  else
    BrpmAuto.log "The request is not part of a plan so not processing the tickets."
    exit
  end
end

tickets.each do |ticket|
  BrpmAuto.log "Setting the status of issue #{ticket["foreign_id"]} to #{params["target_issue_status"]}... (non-existing issues or invalid target statuses will be ignored)"
  JiraRestClient.new.set_issue_to_status(ticket["foreign_id"], params["target_issue_status"])
end
