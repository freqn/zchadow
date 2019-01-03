require 'slack-ruby-client'
require 'json'

class SlackClient
  attr_reader :client

  def initialize
    authenticate
    @client = Slack::Web::Client.new
    @realtime_client = Slack::RealTime::Client.new
  end
  
  def mine_users
    list = client.users_list.first(2)
    list = list.last.first(2).last
    list.each do |x|
      build_profile(x)
    end
  end

  private

  def authenticate
    Slack.configure do |config|
      config.token = ENV['SLACK_AUTH_TOKEN']
      config.logger = Logger.new(STDOUT)
      config.logger.level = Logger::INFO
      raise "Missing ENV['SLACK_AUTH_TOKEN']!" unless config.token
    end
  end

  User = Struct.new(:name, :username, :email)

  def build_profile(x)
    user = User.new(name:     x["real_name"],
                    username: x["name"],
                    email:    x["profile"]["email"])

  end
end

SlackClient.new.mine_users