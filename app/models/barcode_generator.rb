class BarcodeGenerator

  def barcode_variant(variant, quantity, size)
    png_location, barcode = generate_barcode_png(variant, 25, 2)
    generate_barcode_pdf(variant, barcode, png_location, quantity)
  end

  private
  def generate_barcode_pdf(variant, barcode, png_location, quantity)
    require 'register_code_tool'
    code = RegisterCodeTool.sku_to_code(variant.sku.clone)
    require 'prawn'
    # pdf_location = 'public/barcode.pdf'
    pdf_location = "/home/kuba/Dropbox/barcodes/#{variant.sku}-#{Time.now}.pdf"
    Prawn::Document.generate(pdf_location, margin: 3, page_size: [145, 85]) do
      font_families.update('Open Sans' => {normal: './app/assets/fonts/open_sans.ttf'})
      font_families.update('Open Sans Bold' => {normal: './app/assets/fonts/open_sans_bold.ttf'})
      quantity.times do |i|

        move_down 2
        font_size 8
        font 'Open Sans Bold'
        text "#{variant.sku}", align: :center

        move_down 2
        font_size 5
        font 'Open Sans'
        bounding_box([0, cursor], width: 145, height: 13, overflow: :turncate) do
          text variant.name, align: :center
          # text variant.name, align: :center
        end

        move_up 2
        image png_location, position: :center

        move_down 3
        font_size 6
        font 'Open Sans Bold'

        text "#{code}          #{barcode.data}", align: :center

        move_down 3
        font_size 6
        font 'Open Sans Bold'
        text 'Dystrybucja: www.e-price.com.pl', align: :center
        move_down 1
        text 'e-price group ul. E. Gierczak 1a, 75-333 Koszalin', align: :center

        start_new_page unless i == (quantity - 1)
      end
    end
    pdf_location
  end

  def generate_barcode_png(variant, height, margin)
    require 'barby'
    require 'barby/outputter/png_outputter'
    require 'barby/barcode/code_128'
    barcode = Barby::Code128B.new(variant.id.to_s.rjust(8, '0'))
    location = "uploads/barcodes/#{variant.id}-small.png"
    File.open(location, 'w') { |f| f.write barcode.to_png({height: height, margin: margin}) }
    return location, barcode
  end

end