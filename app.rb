require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require 'pry'
require 'pg'


def run_sql(sql)
	db = PG.connect(dbname: 'omdb')
	results = db.exec(sql)
	db.close 
	return results

end

def insert_movie(result)

	sql = "INSERT INTO movies (title,year,runtime,language,country,genre,director,plot,rating,poster)
			VALUES ($$#{result['Title']}$$,#{result['Year']},'#{result['Runtime']}',
				'#{result['Language']}', '#{result['Country']}', '#{result['Genre']}',
				'#{result['Director']}', $$#{result['Plot']}$$, '#{result['imdbRating']}',
				'#{result['Poster']}');"

	run_sql(sql)
end

def lookup_movies(movie_title)
	sql = "select * from movies where title = $'#{movie_title}'$;"
	results = run_sql(sql)
	binding.pry

	if results.count == 0
		return false
	else
		return results
	end
end


get '/' do

	if params[:movie_name] 

		url = "http://www.omdbapi.com/?"

		search_string = params[:movie_name].gsub(" ", "+")

		@result = HTTParty.get("#{url}s=#{search_string}")

		if @result['Search'].length == 1

			movie_title = "#{@result['Search'][0]['Title']}"
			@db_results = lookup_movies(movie_title)

			if !lookup_movies(movie_title) 
				result = HTTParty.get("#{url}t=#{search_string}")

				insert_movie(result)

				@db_results = lookup_movies(movie_title)

			end

			@title = @db_results[0]['title']
			@poster = @db_results[0]['poster']
			@year = @db_results[0]['year']
			@runtime = @db_results[0]['runtime']
			@language = @db_results[0]['language']
			@country = @db_results[0]['country']
			@genre = @db_results[0]['genre']
			@director = @db_results[0]['director']
			@rating = @db_results[0]['rating']
			@plot = @db_results[0]['plot']
		end
					
	end
	erb :index
end

get '/about/:movie_name' do

	url = "http://www.omdbapi.com/?"

	movie_title = "#{ params[:movie_name] }"

	@db_results = lookup_movies(movie_title)
	binding.pry
	if !@db_results
		search_string = params[:movie_name].gsub(" ", "+")
		result = HTTParty.get("#{url}t=#{search_string}")

		insert_movie(result)

		@db_results = lookup_movies(movie_title)
	end

	@title = @db_results[0]['title']
	@poster = @db_results[0]['poster']

	@year = @db_results[0]['year']
	@runtime = @db_results[0]['runtime']
	@language = @db_results[0]['language']
	@country = @db_results[0]['country']
	@genre = @db_results[0]['genre']
	@director = @db_results[0]['director']
	@rating = @db_results[0]['rating']
	@plot = @db_results[0]['plot']

	erb :about
end

