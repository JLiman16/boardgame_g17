namespace :games do
  desc "TODO"
  task seed_games: :environment do
    for i in 1..60
      if Game.create_game(i)
          sleep(1)
      else
        puts "This one didn't go through" + i.to_s
      end
      if i % 100 == 0
          puts i
      end
    end
  end

end
