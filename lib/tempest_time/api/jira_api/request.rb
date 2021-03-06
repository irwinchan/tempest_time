require 'httparty'
require 'json'

require_relative './authorization'
require_relative './response'
require_relative '../request'

module JiraAPI
  class Request < TempestTime::API::Request
    def send_request
      @raw_response = self.class.send(
        request_method,
        request_path,
        headers: headers,
        body: request_body,
        query: query_params,
        basic_auth: basic_auth
      )
      response
    end

    private

    def authorization_klass
      Authorization
    end

    def response_klass
      Response
    end

    def user
      credentials.fetch(:email, nil)
    end

    def username
      credentials.fetch(:user, nil)
    end
  end
end