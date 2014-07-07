class BarcodesController < ApplicationController


  def variant
    variant = Spree::Variant.find(params[:id])
    BarcodeGenerator.barcode_variant(variant, params[:quantity])
  end

  def barcodes_params
    params.permit[:id, :quantity]
  end

end