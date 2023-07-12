# app/controllers/api_controller.rb

class ApiController < ApplicationController
  require 'faraday'

  def gpt
    url = "https://api.openai.com/v1/chat/completions"
    message = params[:message] || 'example'
    conn = Faraday.new(url: url) do |faraday|
      faraday.headers["Authorization"] = "Bearer #{ENV['OPENAI_API_KEY']}"
      faraday.headers["Content-Type"] = "application/json"
      faraday.adapter Faraday.default_adapter
    end

    response = conn.post do |req|
      req.body = {
        "max_tokens": 50,
        "model": "gpt-3.5-turbo",
        "temperature": 0.9,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0,
        "messages": [
          {
            role: 'user',
            content: "Generate meaningful sentences where the word '#{message}' used. Please do not include any additional information or commentary. Just the sentence."
          }
        ],
        "stop": ["\n", " Human:", " AI:"]
      }.to_json
    end


    if response.status == 200
      data = JSON.parse(response.body)
      @result = data["choices"][0]["message"]["content"]
    else
      puts "Request failed with status code #{response.status}"
      @result = [] # Set default value or handle the error case appropriately
    end
    render json: { result: @result}
  end
end
