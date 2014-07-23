class BarcodeGenerator

  def barcode_variant(variant, quantity, size, pdf_location)
    png_location, barcode = generate_barcode_png(variant, 25, 2)
    generate_barcode_pdf(variant, barcode, png_location, quantity, pdf_location)
  end

  def barcodes_zip(input_filenames, pdf_location)
    puts input_filenames.inspect
    require 'zip'
    zipfile_name = 'uploads/barcodes/barcodes.zip'
    FileUtils.rm zipfile_name if File.exists? zipfile_name
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        # Two arguments:
        # - The name of the file as it will appear in the archive
        # - The original file, including the path to find it
        zipfile.add(filename, pdf_location + '/' + filename)
      end
    end
    FileUtils.rm_rf(Dir.glob(pdf_location))
    FileUtils.mkdir pdf_location
    zipfile_name
  end

  private
  def generate_barcode_pdf(variant, barcode, png_location, quantity, pdf_location)
    require 'register_code_tool'
    code = RegisterCodeTool.sku_to_code(variant.sku.clone)
    require 'prawn'
    file_name = "#{variant.sku}-#{Time.now}.pdf"
    pdf_file= "#{pdf_location}/#{file_name}"
    # pdf_location = "/home/kuba/Dropbox/barcodes/#{variant.sku}-#{Time.now}.pdf"
    Prawn::Document.generate(pdf_file, margin: 3, page_size: [145, 85]) do
      font_families.update('Open Sans' => {normal: './app/assets/fonts/open_sans.ttf'})
      font_families.update('Open Sans Bold' => {normal: './app/assets/fonts/open_sans_bold.ttf'})
      quantity.times do |i|

        move_down 2
        font_size 8
        font 'Open Sans Bold'
        text "#{variant.sku}", align: :center

        move_down 2
        font_size 6
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
    file_name
  end

  def generate_barcode_png(variant, height, margin)
    require 'barby'
    require 'barby/outputter/png_outputter'
    require 'barby/barcode/code_128'
    barcode = Barby::Code128B.new(variant.id.to_s.rjust(8, '0'))
    dir = 'uploads/barcodes/'
    FileUtils.mkdir_p dir unless Dir.exists? dir
    location = "#{dir}/#{variant.id}-small.png"
    File.open(location, 'w') { |f| f.write barcode.to_png({height: height, margin: margin}) }
    return location, barcode
  end

end