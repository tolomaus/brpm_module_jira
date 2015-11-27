require_relative "spec_helper"

describe 'transition issue' do
  before(:all) do
    setup_brpm_auto
  end

  before(:each) do
  end

  describe '' do
    it 'should transition an issue in JIRA' do
      params = get_default_params
      params = params.merge(get_integration_params_for_jira)

      params["issue_id"] = "EF-25"

      params["target_issue_status"] = "Done"
      BrpmScriptExecutor.execute_automation_script("brpm_module_jira", "transition_issue", params)

      params["target_issue_status"] = "To Do"
      BrpmScriptExecutor.execute_automation_script("brpm_module_jira", "transition_issue", params)

      params["target_issue_status"] = "In development"
      BrpmScriptExecutor.execute_automation_script("brpm_module_jira", "transition_issue", params)

      params["target_issue_status"] = "Deployed to Development"
      BrpmScriptExecutor.execute_automation_script("brpm_module_jira", "transition_issue", params)
    end

    it 'should raise an error when transitioning an unknown issue in JIRA' do
      params = get_default_params
      params = params.merge(get_integration_params_for_jira)

      params["issue_id"] = "XXX-999"

      params["target_issue_status"] = "Done"
      expect { BrpmScriptExecutor.execute_automation_script("brpm_module_jira", "transition_issue", params) }.to raise_exception
    end
  end
end

