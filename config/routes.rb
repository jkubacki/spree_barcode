Spree::Core::Engine.routes.append do
  namespace :admin do
    # get 'variants/:id/barcodes/:quantity', to: 'barcodes#variant'
    get 'barcodes', to: 'barcodes#index'
    get '/variants/barcodes', to: 'barcodes#variant'
    get '/variants/barcodes/zip', to: 'barcodes#download_zip'
    post '/variants/barcodes/zip', to: 'barcodes#download_zip'
  end
end