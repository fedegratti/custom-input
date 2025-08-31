class OauthController < ApplicationController
  def install
    state = SecureRandom.hex(16)
    session[:state] = state
    redirect_to "https://www.tiendanube.com/apps/#{ENV.fetch('TIENDANUBE_APP_ID')}/authorize" \
      + "?client_id=#{CGI.escape(ENV.fetch('TIENDANUBE_CLIENT_ID'))}" \
      + "&redirect_uri=#{CGI.escape(ENV.fetch('TIENDANUBE_REDIRECT_URI'))}" \
      + "&response_type=code&state=#{state}", allow_other_host: true
  end

  def callback
    # validar state
    if params[:state] != session.delete(:state)
      render plain: "Invalid state", status: :unauthorized and return
    end

    code = params[:code]
    token_res = Faraday.post("https://www.tiendanube.com/apps/token") do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = {
        client_id:     ENV.fetch("TIENDANUBE_CLIENT_ID"),
        client_secret: ENV.fetch("TIENDANUBE_CLIENT_SECRET"),
        grant_type:    "authorization_code",
        code:          code,
        redirect_uri:  ENV.fetch("TIENDANUBE_REDIRECT_URI")
      }.to_json
    end

    json = JSON.parse(token_res.body)
    access_token = json.fetch("access_token")
    store_id     = json.fetch("user_id") # id de la tienda
    store_name   = json["store_name"]

    store = Store.find_or_initialize_by(store_id: store_id)
    store.update!(access_token: access_token, name: store_name)

    # Registrar el script para inyectar el input en el storefront
    redirect_to register_script_path(store.id)
  rescue => e
    Rails.logger.error(e)
    render plain: "OAuth error", status: 500
  end
end
