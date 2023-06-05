json.extract! card, :id, :word, :definition, :leitner_card_box_id, :created_at, :updated_at
json.url card_url(card, format: :json)
