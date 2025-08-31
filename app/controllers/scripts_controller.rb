class ScriptsController < ApplicationController
  protect_from_forgery except: :inject

  # Se sirve el JS que se inyectará en la tienda
  def inject
    response.headers["Content-Type"] = "application/javascript"
    render layout: false
  end

  # Post-install: registrar el script en la tienda
  def register
    store = Store.find(params[:id])
    api   = TiendanubeApi.new(store)
    src   = "#{ENV.fetch('APP_HOST')}/inject.js"

    res = api.create_script!(src: src)
    if res.success?
      redirect_to root_path, notice: "Script registrado en la tienda #{store.name}"
    else
      Rails.logger.error(res.body)
      render plain: "Error registrando script", status: 500
    end
  end
end
