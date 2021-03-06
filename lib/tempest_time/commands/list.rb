# frozen_string_literal: true

require_relative '../command'
require_relative '../helpers/time_helper'
require_relative '../api/tempo_api/requests/list_worklogs'

module TempestTime
  module Commands
    class List < TempestTime::Command
      include TempestTime::Helpers::TimeHelper

      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        @date ||= date_prompt('Please select a date.')

        with_spinner("Retrieving logs for #{formatted_date(@date)}...") do |spin|
          @response = TempoAPI::Requests::ListWorklogs.new(
            @date,
            nil,
            @options[:user]
          ).send_request
          spin.stop(pastel.green('Done!'))
          prompt.say(render_table)
          prompt.say(
            'Total Time Logged: '\
            "#{pastel.green("#{@response.total_hours_spent} hours")}"
          )
        end
      end

      private

      def table_headings
        %w[Worklog Issue Time Description]
      end

      def render_table
        t = table.new(table_headings, @response.worklogs.map { |r| row(r) })
        t.render(
          :ascii,
          padding: [0, 1],
          column_widths: [7,10,15,30],
          multiline: true
        )
      end

      def row(worklog)
        [
          worklog.id,
          worklog.issue,
          formatted_time(worklog.seconds),
          worklog.description
        ]
      end
    end
  end
end
