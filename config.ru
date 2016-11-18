require 'facebook/messenger'
require_relative 'bot'

class PrivacyApp
  def call(env)
    [200, {'Content-Type' => 'text/html'}, [File.read('./privacy.html')]]
  end
end

app = Rack::URLMap.new(
  "/privacy" => PrivacyApp.new,
  "/" => Facebook::Messenger::Server.new,
)

run app
