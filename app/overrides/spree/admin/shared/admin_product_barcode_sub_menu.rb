Deface::Override.new(
    :virtual_path => 'spree/admin/shared/_product_sub_menu',
    :name => 'admin_product_barcode_sub_menu',
    :insert_bottom => "[data-hook='admin_product_sub_tabs']",
    :text => '<%= tab :barcodes %>'
)