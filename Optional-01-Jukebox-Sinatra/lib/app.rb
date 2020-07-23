require 'sinatra'
require 'sinatra/reloader' if development?
require 'sqlite3'

DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), 'db/jukebox.sqlite'))

get "/" do
  # TODO: Gather all artists to be displayed on home page
  @artists = DB.execute("SELECT * FROM artists")
  erb :home # Will render views/home.erb file (embedded in layout.erb)
end

get "/artists/:id" do
  @artist_albums = DB.execute("SELECT albums.title, albums.id FROM albums
     JOIN artists ON artists.id = albums.artist_id
     WHERE albums.artist_id = #{params[:id].to_i}")

  @artist = DB.execute("SELECT name FROM artists WHERE id = #{params[:id].to_i}")
  erb :artist
end

get "/albums/:id" do
  @albums_songs = DB.execute("SELECT tracks.name, tracks.id FROM tracks
     JOIN albums ON albums.id = tracks.album_id
     WHERE tracks.album_id = #{params[:id].to_i}")

  @album = DB.execute("SELECT title FROM albums WHERE id = #{params[:id].to_i}")

  erb :album
end

get "/tracks/:id" do
  @albums_songs = DB.execute("SELECT * FROM tracks
     WHERE tracks.id = #{params[:id].to_i}")

  @track = DB.execute("SELECT name FROM tracks WHERE id = #{params[:id].to_i}")

  erb :song
end

# Then:
# 1. Create an artist page with all the albums. Display genres as well
# 2. Create an album pages with all the tracks
# 3. Create a track page with all the track info
