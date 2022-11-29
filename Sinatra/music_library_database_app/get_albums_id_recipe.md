# GET /albums/:id Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

HTTP METHOD: GET
PATH: /albums/
QUERY PARAMS: id
BODY PARAMS: none

## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._

```
Response status: 200 OK
id=#{album.id},title=#{album.title},release_year=#{album.release_year},artist_id=#{album.artist_id}
```

## 3. Write Examples

_Replace these with your own design._

```
# Request:

GET /albums/3

# Expected response:
id=3,title=Waterloo,release_year=1974,artist_id=2

Response for 200 OK
```

```
# Request:

GET /albums/13

# Expected response:

Response for 404 NotFound
```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /albums/:id" do
    it 'with :id=3 returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/albums/3')

      expected_response = "id=3,title=Waterloo,release_year=1974,artist_id=2"

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end

    it 'with :id=13 returns 404 Not Found' do
      response = get('/albums/13')

      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.
