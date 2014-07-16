Spree::Core::Engine.routes.append do
  namespace :admin do
    # get 'variants/:id/barcodes/:quantity', to: 'barcodes#variant'
    get 'barcodes', to: 'barcodes#index'
    get '/variants/barcodes', to: 'barcodes#variant'
  end
end