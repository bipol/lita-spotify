module Lita
  module Handlers
    class Spotify < Handler
    	_API_URL = "https://api.spotify.com/v1/"
      _TRACK_URL = _API_URL + "tracks/"
      _SEARCH_URL = _API_URL + "search/"

      route(/^(?:spotify)?\s+(.*)/i, :find_song, command: true, help: {
         "spotify artistName,songName" => "Retrieves a spotify link for an artist and songName"
      })

      def find_song(res)
        res = res.split(',')
        artistName = res[0]
        songName = res[1]
        track_res = http.get(
          "#{_SEARCH_URL}",
          q: songName,
          type: "tracks"
        )

        if track_res != 200
          return
	end

        track_url = MultiJson.load(track_res.body)["items"].select{|t| t['artists']['name'] == artistName && t['name'] == songName}.first['external_urls']['spotify']
        res.reply track_url
      end
    end

    Lita.register_handler(Spotify)
  end
end
