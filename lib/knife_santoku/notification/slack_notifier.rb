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
        msg = msg.split(' ')
        skip_next = false
        redacted = []
        msg.each do |arg|
          if skip_next == true
            skip = true
            skip_next = false
          end
          if arg == '-P'
            skip = true
            skip_next = true
          end
          redacted << arg unless skip
        end
        msg = redacted.join(' ')

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