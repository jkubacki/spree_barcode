class Spree::Admin::BarcodesController < Spree::Admin::BaseController

  def variant
    skus = barcodes_params[:barcode_form][:sku].split
    if skus.blank? then skus = barcodes_params[:barcode_form][:sku_text].split end
    barcode_generator = BarcodeGenerator.new
    errors = []
    skus.each do |sku|
      if Spree::Variant.exists?(sku: sku)
        variant = Spree::Variant.find_by(sku: sku)
        if variant.is_master?
          unless variant.product.has_variants?
            barcode_generator.barcode_variant(variant.clone, 1, 'small')
            next
          end
          variant.product.variants.each do |var|
            barcode_generator.barcode_variant(var.clone, 1, 'small')
          end
        else
          barcode_generator.barcode_variant(variant.clone, 1, 'small')
        end
      else
        errors << "Błędny symbol #{sku}"
      end
    end
    if errors.blank?
      redirect_to '/admin/barcodes', flash: {success: "Wygenerowano kod kreskowy dla symboli #{skus.join(' ')}"}
    else
      redirect_to '/admin/barcodes', flash: {error: errors.join(' ')}
    end
  end

  def barcodes_params
    params.permit(:id, :current_store_id, barcode_form: [:sku, :sku_text])
  end

  def index
    @barcode_form = BarcodeForm.new
    @skus = Spree::Variant.pluck(:sku).sort
  end

end