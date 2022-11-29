require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_tables
  sql_seed = File.read("spec/seeds/albums_seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test"})
  connection.exec(sql_seed)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do
    reset_tables
  end

  context "GET /albums" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/albums')

      expected_response = "Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring"

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "GET /albums/:id" do
    it 'with :id=3 returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/albums/3')

      expected_response = "id=3,title=Waterloo,release_year=1974,artist_id=2"

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end

    it 'with :id=13 returns 500 Internal Server Error' do
      response = get('/albums/13')

      expect(response.status).to eq(500)
      # expect(response.body).to eq(expected_response)
    end
  end
end
