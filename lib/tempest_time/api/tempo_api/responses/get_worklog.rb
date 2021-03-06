require_relative '../response'

module TempoAPI
  module Responses
    class GetWorklog < TempoAPI::Response
      private

      def worklog
        @worklog ||= TempoAPI::Models::Worklog.new(
          id: raw_response['tempoWorklogId'],
          issue: raw_response.dig('issue', 'key'),
          seconds: raw_response['timeSpentSeconds'],
          description: raw_response['description']
        )
      end

      def success_message
        worklog.to_s
      end
    end
  end
end