class BarcodesController < ApplicationController


  def variant
    variant = Spree::Variant.find(barcodes_params[:id])
    BarcodeGenerator.barcode_variant(variant, barcodes_params[:quantity])
  end

  def barcodes_params
    params.permit[:id, :quantity]
  end

end