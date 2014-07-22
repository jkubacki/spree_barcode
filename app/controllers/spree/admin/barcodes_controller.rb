class Spree::Admin::BarcodesController < Spree::Admin::BaseController

  def variant
    skus = barcodes_params[:barcode_form][:sku].split
    if skus.blank? then skus = barcodes_params[:barcode_form][:sku_text].split end
    barcode_generator = BarcodeGenerator.new
    errors = []
    files = []
    pdf_location = 'uploads/barcodes/pdf'
    skus.each do |sku|
      if Spree::Variant.exists?(sku: sku)
        variant = Spree::Variant.find_by(sku: sku)
        if variant.is_master?
          unless variant.product.has_variants?
            files <<  barcode_generator.barcode_variant(variant.clone, 1, 'small', pdf_location)
            next
          end
          variant.product.variants.each do |var|
            files << barcode_generator.barcode_variant(var.clone, 1, 'small', pdf_location)
          end
        else
          files << barcode_generator.barcode_variant(variant.clone, 1, 'small', pdf_location)
        end
      else
        errors << "Błędny symbol #{sku}"
      end
    end
    zipfile_name = barcode_generator.barcodes_zip(files, pdf_location)
    if errors.blank?
      redirect_to '/admin/barcodes', flash: {success: "Wygenerowano kod kreskowy dla symboli #{skus.join(' ')}"}
    else
      redirect_to '/admin/barcodes', flash: {error: errors.join(' ')}
    end
  end

  def barcodes_params
    params.permit(:id, :current_store_id, barcode_form: [:sku, :sku_text])
  end

  def download_zip
    if File.exists? 'uploads/barcodes/barcodes.zip'
      send_file 'uploads/barcodes/barcodes.zip'
    else
      redirect_to '/admin/barcodes', flash: {error: 'Brak wygenerowanego pliku zip.'}
    end
  end

  def index
    @barcode_form = BarcodeForm.new
    @skus = Spree::Variant.pluck(:sku).sort
  end

end