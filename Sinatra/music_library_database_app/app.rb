# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get "/albums" do
    album_repo = AlbumRepository.new
    albums = album_repo.all
    return albums.map(&:title).join(', ')
  end

  get "/albums/:id" do
    id = params[:id]

    album_repo = AlbumRepository.new
    album = album_repo.find(id)

    return "id=#{album.id},title=#{album.title},release_year=#{album.release_year},artist_id=#{album.artist_id}"
  end

  post "/albums" do
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]

    album_repo = AlbumRepository.new
    album = album_repo.create(album)

    return nil
  end

  get "/artists" do
    artist_repository = ArtistRepository.new
    artists = artist_repository.all
    artist_list = []
    artists.each do |artist|
      artist_list << artist.name
    end
    artist_list.join(", ")
  end

  post "/artists" do
    artist_repository = ArtistRepository.new
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    artist_repository.create(artist)
  end
end