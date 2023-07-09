require 'faraday'
require 'json'
require 'cgi'

class MediaService
  attr_reader :word, :format, :limit

  def initialize(word, format = 'gif', limit = 8)
    @word = word
    @format = format
    @limit = limit
  end

  def self.fetch_media(word, format = 'gif', limit = 8)
    key = '&key=LIVDSRZULELA'
    encoded_word = CGI.escape(word)
    url_query = "https://g.tenor.com/v1/search?q=#{encoded_word}&#{key}&limit=#{limit}"
    begin
      response = Faraday.get(url_query)
    rescue Faraday::ConnectionFailed => e
      return []
    end
    json = JSON.parse(response.body)
    json['results'].map { |result| result['media'].first[format]['url'] }
  end
end
