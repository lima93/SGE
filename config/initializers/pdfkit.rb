PDFKit.configure do |config|
  # config.wkhtmltopdf = "/usr/local/bin/wkhtmltopdf"
  config.default_options = {
      print_media_type: true,
      dpi: '60',
      encoding: 'UTF-8'
  }
  config.root_url = "http://localhost:3000/"
  config.verbose = false
end