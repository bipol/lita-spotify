module Lita
  module Handlers
    class Spotify < Handler
      API_URL = "https://api.spotify.com/v1/"
      SEARCH_URL = API_URL + "search/"

      route(/^(?:spotify)?\s+(.*)/i, :find_song, command: true, help: {
         "spotify artistName,songName" => "Retrieves a spotify link for an artist and songName"
      })

      def find_song(res)
        res_string = res.matches[0][0].split(',')
        artistName = res_string[0].downcase
        songName = res_string[1].downcase
        track_res = http.get(
          SEARCH_URL,
          q: songName,
          type: "track"
        )

        if track_res.status != 200
          return
	end

	
        #track_url = MultiJson.load(track_res.body)["tracks"].select{|t| t['artists']['name'] == artistName}.first['external_urls']['spotify']
        track_url = MultiJson.load(track_res.body)["tracks"]["items"].select{ |t| t["artists"][0]["name"].downcase == artistName.downcase } 
	if track_url != []
	   res.reply track_url.first['external_urls']['spotify']
	else 
	   res.reply "No song was found..."
	end
      end
    end

    Lita.register_handler(Spotify)
  end
end
