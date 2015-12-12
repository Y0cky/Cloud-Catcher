require 'soundcloud'
require 'youtube-dl.rb'

# ---Config---
Page_size = 200  
playlist_name = 'sync'


# Login
client = SoundCloud.new({
  :client_id     => "",
  :client_secret => "",
  :username      => '',
  :password      => ''
})

# ---End---

# Print Infos
puts "=====Cloud Catcher===="

# Print Username
puts "Connected with " + client.get('/me').username, "Playlist: " + playlist_name, ""

# Get Playlist data
playlists = client.get("/me/playlists", :limit => Page_size, :order => playlist_name)
syncplaylist = playlists.select {|i| i.permalink == (playlist_name) }.first.gsub!("/", "")

# Update Tracks
puts "Update local libary:"
pl_tracks = Array.new
exist_tracks = Dir.glob(playlist_name + "/*")

# Remove directory
for i in exist_tracks
	i.gsub!(playlist_name + "/", "")
end

for i in syncplaylist.tracks
	track_url = i.permalink_url
	title_mp3 = i.title + ".mp3"
	pl_tracks.push(title_mp3)
	# Download new Tracks if missing
	if File.exist?(playlist_name + "/" + title_mp3) == false
		puts "Downloading " + title_mp3
		YoutubeDL.download track_url, output: playlist_name + "/" + title_mp3
	end
end


#Delet Tracks 
for i in exist_tracks
	if pl_tracks.include?(i) == false 
		File.delete(playlist_name + "/" + i)
		puts i + " deleted"
	end
end

puts "Up to date :)"
