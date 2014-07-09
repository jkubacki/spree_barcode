Spree::Core::Engine.routes.append do
  namespace :admin do
    get 'variants/:id/barcodes/:quantity', to: 'barcodes#variant'
    get 'pdf', to: 'barcodes#pdf'
  end
end