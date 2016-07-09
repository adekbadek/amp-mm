require 'fastimage'

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload, apply_css_live: false, apply_js_live: false
end

# tell Middleman to create a folder for each .html file and place the built template file as the index of that folder
activate :directory_indexes

activate :autoprefixer

###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do

  # https://www.ampproject.org/docs/get_started/create/include_image.html
  def amp_image(path, options = {})
    imagePath = 'images/'+path
    size = FastImage.size('source/'+imagePath)
    altText = options[:alt] ? options[:alt] : path.gsub(/\.[\w]*/, '')
    '<amp-img '+(options[:layout] ? 'layout="'+options[:layout]+'"' : nil)+' src="'+imagePath+'" alt="'+altText+'" width="'+size[0].to_s+'" height="'+size[1].to_s+'"></amp-img>'
  end

end

# Build-specific configuration
configure :build do
  # Use relative URLs
  activate :relative_assets

  # Minify CSS on build
  activate :minify_css
end

after_build do

  index_path = 'build/index.html'
  @INDEX = File.read( index_path )
  @STYLESHEET = File.read( 'build/stylesheets/site.css' )

  # inline the stylesheet
  @INDEX = @INDEX.gsub(
    '<link href="stylesheets/site.css" rel="stylesheet" />',
    '<style amp-custom>'+@STYLESHEET+'</style>')
  # rm stylesheet
  FileUtils.rm_rf 'build/stylesheets'
  # save file
  File.write(index_path, @INDEX)

end
