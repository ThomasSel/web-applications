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
        "Title: Doolittle",
        "Released: 1989",
        "Title: Super Trouper",
        "Released: 1980"
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
    it 'returns 200 OK' do
      post_response = post('/albums', title: "Voyage", release_year: "2022", artist_id: "2")

      expect(post_response.status).to eq(200)
      expect(post_response.body).to eq ""

      get_response = get("/albums")
      expect(get_response.body).to include(
        "Title: Voyage",
        "Released: 2022"
      )
    end
  end

  context "GET /artists" do
    it 'returns a list of all artists' do
      response = get('/artists')

      expect(response.status).to be(200)
      expect(response.body).to eq ("Pixies, ABBA, Taylor Swift, Nina Simone")
    end
  end

  context "POST /artists" do
    it 'adds artists to the database' do
      post_response = post('/artists', name: 'Wild nothing', genre: 'Indie')
      expect(post_response.status).to be (200)

      get_response = get('/artists')

      expect(get_response.status).to be(200)
      expect(get_response.body).to eq ("Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing")
    end
  end
end
