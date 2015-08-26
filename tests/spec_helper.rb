require 'fileutils'
require "brpm_script_executor"

def setup_brpm_auto
  FileUtils.mkdir_p "/tmp/brpm_content"
  create_symlink_to_gemset

  BrpmAuto.setup( get_default_params.merge!(get_integration_params_for_jira) )

  BrpmAuto.require_module "brpm_module_jira"

  @jira_rest_client = JiraRestClient.new
end

def get_default_params
  params = {}
  params['also_log_to_console'] = 'true'

  params['brpm_url'] = 'http://brpm-content.pulsar-it.be:8088/brpm'
  params['brpm_api_token'] = ENV["BRPM_API_TOKEN"]

  params['output_dir'] = "/tmp/brpm_content"

  params
end

def get_integration_params_for_jira
  params = {}
  params["SS_integration_dns"] = 'http://brpm.pulsar-it.be:9090'
  params["SS_integration_username"] = 'brpm'
  params["SS_integration_password"] = ENV["JIRA_PASSWORD"]

  params["jira_release_field_id"] = '10000'

  params
end

def cleanup_release(release_name)
  @jira_rest_client.delete_option_for_dropdown_custom_field('10000', release_name)
end

def create_symlink_to_gemset
  module_name = File.basename(File.expand_path("#{File.dirname(__FILE__)}/.."))
  symlink = "#{ENV["GEM_HOME"]}/gems/#{module_name}-999.0.0"
  FileUtils.rm(symlink) if File.exists?(symlink)
  FileUtils.ln_s(File.expand_path("#{File.dirname(__FILE__)}/.."), symlink)
end