namespace :games do
  desc "TODO"
  task seed_games: :environment do
    for i in 421..600
      if Game.create_game(i)
        sleep(1)
      else
        puts "This one didn't go through" + i.to_s
      end
    end
  end
  
  desc "TODO"
  task rank_games: :environment do
    Game.all.each_with_index do |game, i|
      Game.all.each_with_index do |game2, j| 
        unless j < i
          output = Similarity.create_index(game, game2)
          puts output.sim_index
        end
      end
    end
  end
  
  desc "TODO"
  task clean_similarities: :environment do
    for thing in Similarity.all do
      if thing.game1_id == thing.game2_id
        thing.destroy
      end
    end
  end
end
