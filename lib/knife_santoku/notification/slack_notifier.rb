require 'httparty'
require 'json'
require 'chef/knife'

module KnifeSantoku
  module Notification
    class SlackNotifier

      def initialize(config)
        @username = config['slack']['username']
        server = Chef::Config[:knife][:chef_server_url]
        hooks = config['slack']['hook'].to_hash
        knife = ::Chef::Knife.new
        @hook = hooks[knife.server_url]
      end

      def notify(msg)
        payload = {
          username: @username,
          icon_emoji: ':knife:',
          text: msg
        }
        HTTParty.post(@hook, body: payload.to_json, headers: { 'Content-Type' => 'application/json' })
      end

    end
  end
end