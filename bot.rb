require 'facebook/messenger'

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

Facebook::Messenger::Thread.set(
  setting_type: 'greeting',
  greeting: {
    text: 'Wow, Such wow, much bot, so entertaining',
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

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  words = message.text.nil? ? DEFAULT_WORDS.sample(3) : message.text.split

  reply_doge(message, words)
end

Bot.on :postback do |postback|
  reply_doge(postback, DEFAULT_WORDS)
end
