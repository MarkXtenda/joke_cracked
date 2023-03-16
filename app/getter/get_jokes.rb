require 'net/http'
require 'open-uri'
require 'json'


class GetJokes
    attr_accessor :category
    attr_reader :all_jokes, :favorite_joke

    def initialize(category)
        @category = category
        @all_jokes = []
    end

    def get_jokes
        uri = URI.parse("https://v2.jokeapi.dev/joke/#{@category}?type=single&amount=5.json")
        response = Net::HTTP.get_response(uri)
        response.body
    end

    def joke_print
        joke_json = JSON.parse(self.get_jokes)
        joke_json["jokes"].each_with_index do |joke, index|
            @all_jokes << joke_json["jokes"][index]["joke"]
            puts "#{index+1}. #{joke_json["jokes"][index]["joke"]}".blue
        end
    end

    def load_more
        puts "Load more? (y/n)"
        answer = gets.chomp
        if (answer == "y")
            @all = []
            joke_print        
        end
    end

    def add_favorite
        puts "Want to add one to your favorite jokes? (y/n)"
        answer = gets.chomp
        if (answer == "y")
            puts "which one of them you wish to add? (pick a number)"
            number = gets.chomp.to_i
            if (number > 0 && number < 6)
                @favorite_joke = @all_jokes[number-1]
                puts "You saved the fact number: #{number}"
                puts "#{@favorite_joke}".blue
            else
                puts "Wrong number. No jokes has been added.".red
                "none"
            end
        end
    end
end

