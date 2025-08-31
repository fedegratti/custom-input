class TiendanubeApi
  API_BASE = "https://api.tiendanube.com/v1"

  def initialize(store)
    @store = store
    @conn = Faraday.new(url: "#{API_BASE}/#{store.store_id}") do |f|
      f.request :json
      f.response :json, content_type: /\bjson$/
      f.adapter Faraday.default_adapter
    end
  end

  def headers
    {
      "Authentication" => "bearer #{@store.access_token}",
      "User-Agent"     => "CustomInput (tiendanube@ohzi.io)"
    }
  end

  # Crea un Script para cargar nuestro JS en storefront
  def create_script!(src:, event: "onload", where: "storefront")
    @conn.post("scripts", { src: src, event: event, where: where }, headers)
  end
end
