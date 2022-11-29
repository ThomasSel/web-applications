require "spec_helper"
require "rack/test"
require_relative '../../app'


describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /names" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/names')

      expect(response.status).to eq(200)
      expect(response.body).to eq("Julia, Mary, Karim")

    end

    it 'returns 404 Not Found' do
      response = get('/posts?id=276278')

      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end

  context "POST /sort-names" do
    it 'returns 200 OK' do
      response = post('/sort-names', names: "Joe,Alice,Zoe,Julia,Kieran")

      expect(response.status).to eq(200)
      expect(response.body).to eq("Alice,Joe,Julia,Kieran,Zoe")
    end

    it 'returns 200 OK with an empty string' do
      response = post('/sort-names', names: "")

      expect(response.status).to eq 200
      expect(response.body).to eq ""
    end

    it 'returns 404 Not Found' do
      response = get('/sort-names?id=276278')

      expect(response.status).to eq(404)
      expect(response.body).to eq("Sorry! We couldn't find this post.")
    end
  end

  context "GET /hello" do
    it "returns an HTML page with hello header" do
      response = get("/hello")
      expect(response.status).to eq 200
      expect(response.body).to include("<h1>Hello!</h1>")
    end
  end
end