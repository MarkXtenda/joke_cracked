class App 
    attr_reader :user, :username, :answer, :category, :exit, :stay
    def run
        welcome
        while (@stay == 'y' && @exit != 'y')
            login
            wanna_see_fav
            browse
            exit
        end
        puts "Got it! See ya!"
    end

    private

    def initialize 
        @stay = 'y'
        @answer = 'y'
    end

    def welcome
        puts "Welcome to the JokeCracked!\nDo you want to learn some jokes?".blue
        sleep(0.9)
        puts "Get it".blue
        sleep(0.6)
        puts "Lets get cracking".blue
        sleep(0.3)
    end

    def login
        puts "Whats your nickname?"
        @username = gets.chomp
        reinitiate_user
        if (@user)
            puts "Oh hi #{@username}! Long time no see!".green
        else
            puts "I see. You new here! Welcome #{@username}!".green
            @user = User.create(name: @username)
        end
    end

    def wanna_see_fav
        puts "This is your favorite jokes: \n"
        reinitiate_user
        if(@user.jokes.size != 0)
            @user.jokes.each_with_index do |joke, index|
                puts "#{index+1}. #{@user.jokes[index].joke}".blue
            end
        else
            puts " - No jokes, that you favor. For now ;)"
        end
    end

    def browse
        @answer = 'y'
        @category = nil
        while (@answer != 'n')
            puts "Browse for some jokes? (y/n)"
            @answer = gets.chomp
            while (@category == "wrong" || @category == nil && @answer == 'y')
                category_arr = ["Programming", "Misc", "Dark", "Pun"]
                puts "Which category of a jokes you want to access?"
                category_arr.each_with_index do |category, index|
                    puts "#{index+1}. #{category}"
                end
                @category = gets.chomp.to_i
                if (category_arr.include?(category_arr[@category-1]))
                    @category = category_arr[@category-1]
                    puts "You accessed the category: #{@category}".green
                else
                    puts "Wrong number. Try again.".red
                    @category = "wrong"
                end
            end

            (@answer == "y") ? load_joke : nil

            puts "Do you want to see your favorite jokes? (y/n)"
            @answer = gets.chomp

            (@answer == 'y') ? load_favorites : nil
        end
    end

    def load_joke
        jokes = GetJokes.new(@category)
            jokes.joke_print
            if (jokes.add_favorite != "none")
                favorite_joke = jokes.favorite_joke
                if (!favorite_joke.blank?)
                    new_joke = Joke.find_or_create_by(joke: favorite_joke)
                    @user.jokes << new_joke
                end
            else
                nil
            end
    end
    def load_favorites
        wanna_see_fav
        puts "Do you want to delete any of them? (y/n)".red
        @answer = gets.chomp
        while (@answer == 'y')
            if(@user.jokes.size == 0)
                puts "You have no jokes to delete"
                @answer = 'n'
            else
                puts "Which one of them you want to delete? (pick a number)"
                delete_num = gets.chomp.to_i
                reinitiate_user
                if (delete_num <= @user.jokes.size && delete_num > 0)
                    delete_joke = @user.jokes[delete_num - 1].joke
                    Joke.all.find_by(joke: delete_joke).destroy
                    wanna_see_fav
                else
                    puts "Sorry. Such joke is non-existent. Pick another one".red
                    @answer = 'n'
                end
                if (@user.jokes.size != 0)
                    puts "Do you still want to delete one of your favorite jokes? (y/n)".red
                    @answer = gets.chomp
                end
            end
        end
    end

    def reinitiate_user
        @user = User.all.find_by(name: @username)
    end

    def exit
        @exit = "none"
        puts "Do you want to exit? (y/n)".red
        @exit = gets.chomp
        while (@exit != 'y')
            browse
            puts "Do you want to exit? (y/n)".red
            @exit = gets.chomp
            if (@exit != 'n' && @exit != 'y' && @stay != 'y')
                puts "No such option exist."
                puts "(@exit != 'y' && @exit != 'n'): #{(@exit != 'y' && @exit != 'n')}"
                puts "@exit != 'n' && @exit != 'y' && @stay != 'y': #{@exit != 'n' && @exit != 'y' && @stay != 'y'}"
            end
        end
    end
end
