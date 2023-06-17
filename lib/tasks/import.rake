require 'csv'

namespace :import do
  desc "Import cards from CSV file"
  task cards: :environment do
    file_path = 'db/cards.csv'
    user = User.find_by(email: 'user1@gmail.com') # Update this to the user you want to add cards for

    if user.nil?
      puts "User not found. Please check the user email."
    else
      box1 = user.leitner_card_boxes.find_by(repeat_period: 1)

      if box1.nil?
        puts "Box not found. Please check the repeat period."
      else
        CSV.foreach(file_path, headers: true) do |row|
          Card.create(
            word: row['English'], 
            definition: row['Russian'], 
            user: user, 
            leitner_card_box: box1
          )
        end
        puts "Import completed successfully!"
      end
    end
  end
end
