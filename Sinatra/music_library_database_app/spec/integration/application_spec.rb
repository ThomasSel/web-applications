require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

def reset_artists_table
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do 
    reset_albums_table
    reset_artists_table
  end
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /albums" do
    it 'returns an HTML list of all albums' do
      # Assuming the post with id 1 exists.
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include(
        "<h1>Albums</h1>",
        'Title: <a href="/albums/1">Doolittle</a>',
        "Released: 1989",
        'Title: <a href="/albums/4">Super Trouper</a>',
        "Released: 1980",
      )
    end
  end

  context "GET /albums/new" do
    it 'returns the correct HTML form' do
      response = get('/albums/new')

      expect(response.status).to eq 200
      expect(response.body).to include(
        '<h1>Add a new album</h1>',
        '<form action="/albums" method="POST">',
        '<input type="text" name="title" id="title" />',
        '<input type="text" name="release_year" id="release_year" />',
        '<select name="artist_id" id="artist_id">',
        '<option value="1">Pixies</option>',
        '<option value="2">ABBA</option>',
        '<input type="submit" name="Submit">'
      )
    end
  end

  context "GET /albums/:id" do
    it 'with :id=1 returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/albums/1')

      expect(response.status).to eq(200)
      expect(response.body).to include(
        "<h1>Doolittle</h1>",
        "Release year: 1989",
        "Artist: Pixies"
      )
    end
  end

  context "POST /albums" do
    it 'returns a success page with a link back to artists' do
      post_response = post('/albums',
        title: "Voyage",
        release_year: "2022",
        artist_id: "2"
      )

      expect(post_response.status).to eq 200
      expect(post_response.body).to include(
        '<p>Your album has been added</p>',
        '<a href="/albums">Return to albums list</a>'
      )
    end
    
    it 'Adds the album to the database' do
      post_response = post('/albums',
        title: "Voyage",
        release_year: "2022",
        artist_id: "2"
      )

      expect(post_response.status).to eq(200)

      get_response = get("/albums")
      expect(get_response.body).to include(
        'Title: <a href="/albums/13">Voyage</a>',
        "Released: 2022"
      )
    end

    it 'fails if the wrong parameters are given' do
      post_response = post('/albums',
        fake_arg_1: "sldkjf",
        fake_arg_2: "adslkf"
      )

      expect(post_response.status).to eq 400
    end

    it 'fails if no body parameters are passed' do
      post_response = post('/albums')
      expect(post_response.status).to eq 400
    end
  end

  context "GET /artists" do
    it 'returns a list of all artists' do
      response = get('/artists')

      expect(response.status).to be(200)
      expect(response.body).to include(
        "<h1>Artists</h1>",
        '<div><a href="/artists/1">Pixies</a></div>',
        '<div><a href="/artists/2">ABBA</a></div>',
        '<div><a href="/artists/3">Taylor Swift</a></div>'
      )
    end
  end

  context "GET /artists/new" do
    it 'returns a new artist form' do
      get_response = get("/artists/new")

      expect(get_response.status).to eq 200
      expect(get_response.body).to include(
        '<h1>Add a new artist</h1>',
        '<form action="/artists" method="POST">',
        '<input type="text" name="name" id="name" />',
        '<input type="text" name="genre" id="genre" />',
        '<input type="submit" name="Submit" />'
      )
    end
  end

  context "GET /artists/:id" do
    it 'returns an HTML response with artist information' do
      response = get('/artists/2')

      expect(response.status).to be 200
      expect(response.body).to include(
        "<h1>ABBA</h1>",
        "<p>Genre: Pop</p>"
      )
    end
  end

  context "POST /artists" do
    it 'adds artists to the database' do
      post_response = post('/artists', name: 'Wild Nothing', genre: 'Indie')
      expect(post_response.status).to be (200)

      get_response = get('/artists')

      expect(get_response.status).to be(200)
      expect(get_response.body).to include(
        '<div><a href="/artists/5">Wild Nothing</a></div>'
      )
    end

    it 'fails if the wrong params are given' do
      post_response = post('/artists',
        fake_param_1: "akdsh",
        fake_param_2: "aklsjdhfj"
      )
      
      expect(post_response.status).to eq 400
    end

    it 'fails if no params are given' do
      post_response = post('/artists')
      
      expect(post_response.status).to eq 400
    end
  end
end
