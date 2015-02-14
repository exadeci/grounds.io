class Gist

  VERSION = '1.0'

  USER_AGENT       = "grounds-gist/#{VERSION} (Net::HTTP, #{RUBY_DESCRIPTION})"

  # Upload a gist to https://gist.github.com
  #
  # @param [String] content  the code you'd like to gist
  # @param [Hash] options  more detailed options, see
  #   the documentation for {multi_gist}
  #
  # @see http://developer.github.com/v3/gists/
  def create(content, options = {})
    filename = options[:filename] || "grounds"
    multi_gist({filename => content}, options)
  end

  # Upload a gist to https://gist.github.com
  #
  # @param [Hash] files  the code you'd like to gist: filename => content
  # @param [Hash] options  more detailed options
  #
  # @option options [String] :description  the description
  # @option options [Boolean] :public  (false) is this gist public
  # @option options [Boolean] :premium  (false) is this gist anonymous
  # @option options [String] :access_token  The OAuth2 access token.
  # @option options [String] :update  the URL or id of a gist to update
  #
  # @return [String, Hash]  the return value as configured by options[:output]
  #
  # @see http://developer.github.com/v3/gists/
  def multi_gist(files, options={})
    json = {}

    json[:description] = options[:description] if options[:description]
    json[:public] = !!options[:public]
    json[:files] = {}

    files.each_pair do |(name, content)|
      return "Cannot gist empty files" if content.to_s.strip == ""
      json[:files]['nameoffile'] = {:content => content}
    end

    existing_gist = options[:update].to_s.split("/").last
    if options[:premium]
      access_token = options[:access_token]
    else
      access_token = nil
    end

    url = "https://api.github.com/gists"
    url << "/" << CGI.escape(existing_gist) if existing_gist.to_s != ''
    url << "?access_token=" << CGI.escape(access_token) if access_token.to_s != ''

    request = Net::HTTP::Post.new(url)
    request.body = JSON.dump(json)
    request.content_type = 'application/json'
    begin
      response = http(URI(url), request)
      if Net::HTTPSuccess === response
        Rails.logger.debug(response.body)
        return on_success(response.body)
      else
        return "Got #{response.class} from gist: #{response.body}"
      end
    end
  end

  # Return HTTP connection
  #
  # @param [URI::HTTP] The URI to which to connect
  # @return [Net::HTTP]
  def http_connection(uri)
    connection = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == "https"
      connection.use_ssl = true
      connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    connection.open_timeout = 10
    connection.read_timeout = 10
    connection
  end

  # Run an HTTP operation
  #
  # @param [URI::HTTP] The URI to which to connect
  # @param [Net::HTTPRequest] The request to make
  # @return [Net::HTTPResponse]
  def http(url, request)
    request['User-Agent'] = USER_AGENT

    http_connection(url).start do |http|
      http.request request
    end
  rescue Timeout::Error
    return "Could not connect to #{@api_url}"
  end

  # Called after an HTTP response to gist to perform post-processing.
  #
  # @param [String] body  the text body from the github api
  def on_success(body)
    json = JSON.parse(body)
    json['html_url']
  end
end
