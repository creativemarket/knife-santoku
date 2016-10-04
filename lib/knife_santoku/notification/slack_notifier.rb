require 'httparty'
require 'json'

module KnifeSantoku
  module Notification
    class SlackNotifier

      def initialize(config)
        @username = config['slack']['username']
        @hook = config['slack']['hook']
      end

      def notify(msg)
        payload = {
          username: @username,
          icon_emoji: ':knife:'
          text: msg
        }
        HTTParty.post(url, body: payload.to_json, headers: { 'Content-Type' => 'application/json' })
      end

    end
  end
end