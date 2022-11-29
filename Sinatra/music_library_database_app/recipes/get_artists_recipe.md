# {{ GET }} {{ /artists }} Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

Method: GET
Path: /artists
Query parameters: N/A

Method: POST
Path: /artists
Query Parameters: N/A
Body Parameters: name, title

## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._

```
GET /artists
Returns a list of artists names 
=> Pixies, ABBA, Taylor Swift, Nina Simone

POST /artists
Returns nothing
```

## 3. Write Examples

_Replace these with your own design._

```
# Request:

GET /artists

# Expected response (200 OK):
Pixies, ABBA, Taylor Swift, Nina Simone

POST /artists
Body:
name="Wild Nothing"
genre="Indie"

# Expected response (200 OK):
returns nothing
```


## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /artists" do
    it 'returns a list of all artists' do
      response = get('/artists')

      expect(response.status).to be(200)
      expect(response.body).to eq ("Pixies, ABBA, Taylor Swift, Nina Simone")
    end
  end

  context "POST /artists" do
    it 'adds artists to the database' do
      post_response = post('/artists', name: 'Wild Nothing', genre: 'Indie')
      expect(post_response.status).to be (200)

      get_response = get('/artists')

      expect(get_response.status).to be(200)
      expect(get_response.body).to eq ("Pixies, ABBA, Taylor Swift, Nina Simone, Wild Nothing")
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.
