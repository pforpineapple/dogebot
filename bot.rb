require 'facebook/messenger'

Facebook::Messenger.configure do |config|
  config.access_token = ENV['ACCESS_TOKEN']
  config.verify_token = ENV['VERIFY_TOKEN']
end

include Facebook::Messenger

BASE_URL = 'http://dogr.io/'

WORDS = [
  'wow',
  'doge',
  'tasty',
  'groovy'
]

ADJ = [
  'such',
  'so',
  'very',
  'much'
]

DEFAULT_WORDS = [
  'jam',
  'free-time',
  'amazing',
  'tasty',
  'groovy',
]


def build_such_wow(words)
  BASE_URL + WORDS.sample + '/' +
    words.map do |word|
    ADJ.sample + '%20' + word
  end.join('/') +
  '.png?split=false'
end

def reply_doge(message, words)
  Bot.deliver(
    recipient: message.sender,
    message: {
      attachment: {
        type: 'image',
        payload: {
          url: build_such_wow(words)
        }
      }
    }
  )
end

def sanitize_words(words)
  words.map { |word| word.gsub(/[^0-9A-Za-z]/, '') }
end

Facebook::Messenger::Thread.set(
  setting_type: 'greeting',
  greeting: {
    text: 'Such wow, much bot, so entertaining. wow! doge',
  }
)

Facebook::Messenger::Thread.set(
  setting_type: 'call_to_actions',
  thread_state: 'new_thread',
  call_to_actions: [
    {
      payload: 'WOW'
    }
  ]
)

Facebook::Messenger::Thread.set(
  setting_type: 'call_to_actions',
  thread_state: 'existing_thread',
  call_to_actions: [
    {
      type: 'postback',
      title: 'Wow',
      payload: 'WOW'
    },
    {
      type: 'postback',
      title: 'Much amazing',
      payload: 'WOW'
    },
  ]
)

Bot.on :message do |message|
  puts "Received message '#{message.inspect}' from #{message.sender}"

  words = message.text.nil? ? DEFAULT_WORDS.sample(3) : sanitize_words(message.text.split)

  reply_doge(message, words)
end

Bot.on :postback do |postback|
  puts "Received postback '#{postback.inspect}' from #{postback.sender}"

  reply_doge(postback, DEFAULT_WORDS)
end
