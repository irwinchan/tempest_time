# frozen_string_literal: true

require 'thor'

module TempestTime
  module Commands
    class Config < Thor

      namespace :config

      desc 'setup', 'Set up Tempest with your credentials.'
      def setup(*)
        require_relative 'config/setup'
        TempestTime::Commands::Config::Setup.new(options).execute
      end

      desc 'edit', 'Modify your user credentials.'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def edit(*)
        if options[:help]
          invoke :help, ['auth']
        else
          require_relative 'config/edit'
          TempestTime::Commands::Config::Edit.new(options).execute
        end
      end
    end
  end
end
