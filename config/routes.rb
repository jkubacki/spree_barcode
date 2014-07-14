Spree::Core::Engine.routes.append do
  namespace :admin do
    # get 'variants/:id/barcodes/:quantity', to: 'barcodes#variant'
    get 'barcodes', to: 'barcodes#index'
  end
end