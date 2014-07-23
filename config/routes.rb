Spree::Core::Engine.routes.append do
  namespace :admin do
    # get 'variants/:id/barcodes/:quantity', to: 'barcodes#variant'
    get 'barcodes', to: 'barcodes#index'
    post 'barcodes', to: 'barcodes#variant'
    get 'barcodes/zip', to: 'barcodes#download_zip'
    post 'barcodes/zip', to: 'barcodes#download_zip'
  end
end