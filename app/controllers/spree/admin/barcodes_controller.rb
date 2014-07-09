class Spree::Admin::BarcodesController < Spree::Admin::BaseController

  def variant
    require 'register_code_tool'
    variant = Spree::Variant.find(barcodes_params[:id])
    code = RegisterCodeTool.symbol_to_code(variant.sku.clone)

    quantity = barcodes_params[:quantity].to_i
    require 'barby'
    # require 'barby/outputter/html_outputter'
    require 'barby/outputter/png_outputter'
    require 'barby/barcode/code_128'
    barcode = Barby::Code128B.new(variant.id.to_s.rjust(8, '0'))
    location = "./app/assets/images/barcodes/#{variant.id}-small.png"
    File.open(location, 'w'){|f| f.write barcode.to_png({height: 35, margin: 2}) }

    barcodes = render_to_string layout: false

    require "prawn"
    Prawn::Document.generate("/home/kuba/Dropbox/hello#{Time.now.to_s}.pdf", :margin => 3, page_size: [145, 80]) do
      font_families.update("Open Sans"=>{:normal => "./app/assets/fonts/open_sans.ttf"})
      font_families.update("Open Sans Bold"=>{:normal => "./app/assets/fonts/open_sans_bold.ttf"})
      quantity.times do |i|
        font_size 5
        font "Open Sans"
        bounding_box([0, cursor], :width => 155, :height => 13, overflow: :turncate) do
          if i == (quantity - 1)
            text variant.name + ' DŁUGA NAZWA BARDZO TAKA ŻE SIĘ NIE MIEŚCI W JEDNEJ LINII', :align => :center
          else
            text variant.name, :align => :center
          end
        end

        move_up 2
        image location, :position  => :center

        move_down 1
        font_size 10
        font "Open Sans Bold"
        text "#{variant.sku}  #{code}  #{barcode.data}", :align => :center

        move_down 1
        font_size 5
        font "Open Sans"
        text "e-price Wojciech Kubacki\ne-price.com.pl", :align => :center

        start_new_page unless i == (quantity - 1)
      end
    end

    render layout: false
  end

  def barcodes_params
    params.permit(:id, :quantity, :current_store_id)
  end

end