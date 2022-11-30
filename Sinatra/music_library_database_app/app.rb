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
    @albums = album_repo.all
    return erb(:albums)
  end

  get "/albums/new" do
    @artists = ArtistRepository.new.all
    return erb(:new_album)
  end

  get "/albums/:id" do
    id = params[:id]

    album_repo = AlbumRepository.new
    @album = album_repo.find(id)

    artist_repo = ArtistRepository.new
    @artist = artist_repo.find(@album.artist_id)

    return erb(:album)
  end

  post "/albums" do
    if invalid_post_album_params?
      status 400
      return ''
    end

    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]

    album_repo = AlbumRepository.new
    album = album_repo.create(album)

    return erb(:album_created)
  end

  get "/artists" do
    artist_repository = ArtistRepository.new
    @artists = artist_repository.all
    
    return erb(:artists)
  end

  get "/artists/new" do
    return erb(:new_artist)
  end

  get "/artists/:id" do
    id = params[:id]
    artist_repo = ArtistRepository.new
    @artist = artist_repo.find(id)

    return erb(:artist)
  end

  post "/artists" do
    if invalid_post_artist_params?
      status 400
      return ''
    end

    artist_repository = ArtistRepository.new
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    artist_repository.create(artist)
  end

  private

  def invalid_post_album_params?
    return [params[:title], params[:release_year], params[:artist_id]].any?(&:nil?)
  end

  def invalid_post_artist_params?
    return [params[:name], params[:genre]].any?(&:nil?)
  end
end