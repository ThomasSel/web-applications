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
end