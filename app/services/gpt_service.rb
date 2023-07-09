require 'faraday'

class GptService
  URL = "https://api.openai.com/v1/chat/completions"
  CONN = Faraday.new(url: URL) do |faraday|
    faraday.headers["Authorization"] = "Bearer #{ENV['GPT_API_KEY']}"
    faraday.headers["Content-Type"] = "application/json"
    faraday.adapter Faraday.default_adapter
  end

  def self.generate_sample_sentence(message)
    response = CONN.post do |req|
      req.body = {
        "max_tokens": 5,
        "model": "gpt-3.5-turbo",
        "temperature": 0.9,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0,
        "messages": [{role: 'user', content: "Could you return me just sentence for this is word #{message}? Please, don't add any words becide this sentence to your responce. Thank you!"}],
        "stop": ["\n", " Human:", " AI:"]
      }.to_json
    end

    if response.status == 200
      data = JSON.parse(response.body)
      @completions = data["choices"][0]["message"]["content"].to_json
    else
      puts "Request failed with status code #{response.status}"
      @completions = [] # Set default value or handle the error case appropriately
    end
  end
end