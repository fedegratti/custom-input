Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'localhost', 'localhost:1234', '127.0.0.1:1234', '10.0.0.10:1234', '10.0.0.10', 'ohzi.io', 'www.ohzi.io', 'ohzi.dev', 'www.ohzi.dev', 'custom-input.ohzi.dev'
      resource '*', headers: :any, methods: [:get, :post, :patch, :put]
    end
  end
