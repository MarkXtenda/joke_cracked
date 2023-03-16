class CreateJokeTable < ActiveRecord::Migration[5.2]
    def change
        create_table :jokes do |r|
            r.string :joke
        end
    end
end