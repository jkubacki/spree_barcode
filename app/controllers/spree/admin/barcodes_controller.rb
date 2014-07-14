class Spree::Admin::BarcodesController < Spree::Admin::BaseController

  def variant
    sku = barcodes_params[:barcode_form][:sku]
    if sku.blank? then sku = barcodes_params[:barcode_form][:sku_text] end
    unless Spree::Variant.exists?(sku: sku) then return redirect_to '/admin/barcodes', flash: {error: 'Błędny symbol'} end
    variant = Spree::Variant.find_by(sku: sku)
    barcode_generator = BarcodeGenerator.new
    barcode_generator.barcode_variant(variant.clone, 1, 'small')
    redirect_to '/admin/barcodes', flash: {success: "Wygenerowano kod kreskowy dla symbolu #{sku}"}
  end

  def barcodes_params
    params.permit(:id, :current_store_id, barcode_form: [:sku, :sku_text])
  end

  def index
    @barcode_form = BarcodeForm.new
    @skus = Spree::Variant.pluck(:sku).sort
  end

end