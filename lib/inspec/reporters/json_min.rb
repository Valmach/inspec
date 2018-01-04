require 'json'

module Inspec::Reporters
  class JsonMin < Base
    def render

      report = {
        controls: [],
        statistics: { duration: run_data[:statistics][:duration] },
        version: run_data[:version],
      }

      # collect all test results and add them to the report
      run_data[:profiles].each do |profile|
        profile_id = profile[:name]
        profile[:controls].each do |control|
          control_id = control[:id]
          control[:results].each do |result|
            result_for_report = {
              id: control_id,
              profile_id: profile_id,
              status: result[:status],
              code_desc: result[:code_desc],
            }

            result_for_report[:skip_message] = result[:skip_message] if result.key?(:skip_message)
            result_for_report[:resource] = result[:resource] if result.key?(:resource)
            result_for_report[:message] = result[:message] if result.key?(:message)

            report[:controls] << result_for_report
          end
        end
      end

      output report.to_json
    end
  end
end
