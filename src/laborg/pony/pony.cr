module Pony
  # Pony API Client wrapper
  #
  # Alias for Pony::Client.new
  def self.client(endpoint : String) : Client
    Client.new(endpoint)
  end

  class Client
    # The endpoint of Pony
    property endpoint
  end

  def initialize(@endpoint : String)
  end

  {% for verb in %w(get head) %}
    # Return a Pony::Response by sending a {{verb.id.upcase}} method http request
    #
    # ```
    # client.{{ verb.id }}("/path", params: {
    #   first_name: "foo",
    #   last_name:  "bar"
    # })
    # ```
    def {{ verb.id }}(uri : String, headers : (Hash(String, _) | NamedTuple)? = nil, params : (Hash(String, _) | NamedTuple)? = nil) : Halite::Response
      headers = headers ? default_headers.merge(headers) : default_headers
      response = Halite.{{verb.id}}(build_url(uri), headers: headers, params: params)
      validate(response)
      response
    end
  {% end %}

  private def validate(response : Halite::Response)
  end

end

alias Laborg::Pony = Pony
