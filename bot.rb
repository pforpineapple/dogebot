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

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  Bot.deliver(
    recipient: message.sender,
    attachment: {
      type: 'image',
      payload: {
        url: build_such_wow(message.text.split || DEFAULT_WORDS.sample(3))
      }
    }
  )
end
