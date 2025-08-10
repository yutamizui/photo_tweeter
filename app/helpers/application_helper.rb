module ApplicationHelper
  def oauth_authorize_url
    base = ENV.fetch("OAUTH_AUTHORIZE_URL")
    params = {
      client_id: ENV.fetch("OAUTH_CLIENT_ID"),
      response_type: "code",
      redirect_uri:  ENV.fetch("OAUTH_REDIRECT_URI"),
      scope: "write_tweet"
    }
    url = "#{base}?#{URI.encode_www_form(params)}"
    Rails.logger.info("[OAuth] authorize_url=#{url}")
    url
  end
end
