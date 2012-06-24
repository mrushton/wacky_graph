require 'net/http'

module WackyGraph
  GRAPH_BASE_URI = 'http://graph.facebook.com'
  SECURE_GRAPH_BASE_URI = 'https://graph.facebook.com'

  class GraphRequest
    attr_accessor :oauth_token

    def initialize(oauth_token)
      @oauth_token = oauth_token
    end

    def get(path, options = {})
      uri = build_uri(path, options)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      data = JSON.parse(response.body)
      case response
      when Net::HTTPOK
        return data
      when Net::HTTPBadRequest
        exception = GraphError.new(data["error"]["message"], data["error"]["type"], data["error"]["code"], data["error"]["error_subcode"])
        raise exception
      else
        raise "Unhandled response from Facebook Graph API"
      end
    end

    def post(path, params) 

    end

    private

    def build_uri(path, options)
      options[:params] = {} if options[:params].nil?
      if options[:no_authorization] || @oauth_token.nil?
        base_uri = GRAPH_BASE_URI
      else
        base_uri = SECURE_GRAPH_BASE_URI
        options[:params][:access_token] = @oauth_token
      end
      uri = URI(base_uri + path)
      uri.query = URI.encode_www_form(options[:params])
      uri
    end
  end
end
