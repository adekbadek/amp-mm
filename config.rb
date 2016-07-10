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

# General configuration

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload, apply_css_live: false, apply_js_live: false
end

# create a folder for each .html file and place the built template file as the index of that folder
activate :directory_indexes

activate :autoprefixer

# get pages with 'amp: true' in the frontmatter, proxy them to amp versions, and add to an array so that styles are inlined in after_build
PAGES_TO_AMP = []
#
# https://middlemanapp.com/advanced/sitemap/#using-the-sitemap-in-config-rb
ready do
  sitemap.resources.group_by {|p| p.data["amp"] }.each do |make_amp_version, pages|
    if make_amp_version
      pages.each do |page|
        proxy "/amp/#{page.path}", page.path
        PAGES_TO_AMP.push(page.path.sub('.html', ''))
      end
    end
  end
end

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
    if current_page.path.match(/^amp/)
      '<amp-img '+(options[:layout] ? 'layout="'+options[:layout]+'"' : nil)+' src="../'+imagePath+'" alt="'+altText+'" width="'+size[0].to_s+'" height="'+size[1].to_s+'"></amp-img>'
    else
      '<img src="'+imagePath+'" alt="'+altText+'"></img>'
    end
  end

  # link the AMP version with non-AMP version
  # https://www.ampproject.org/docs/get_started/create/prepare_for_discovery.html
  def amp_link_pages(url, path, is_amp)
    unless path.match('index.html')
      path = path.sub('.html', '/index.html')
    end
    if is_amp
      "<link rel='canonical' href='#{url+path.sub(/amp\//,'')}'>"
    else
      "<link rel='amphtml' href='#{url+'amp/'+path}'>"
    end
  end

end

# Build-specific configuration
configure :build do
  # Use relative URLs
  activate :relative_assets

  # Minify CSS on build
  activate :minify_css
end


def inline_stylesheet(html_path, file)

  full_path = file == 'index' ? html_path + '.html' : html_path + '/index.html'
  @INDEX = File.read( full_path )

  path_to_index_dir = full_path.match(/([\w\-\/]*\/)[\w\-]*\.html$/)
  stylesheet_link_regex = /<link href="([..\/]*?stylesheets\/[\w\-]*\.css)" rel="stylesheet" \/>/

  @STYLESHEET = File.read( path_to_index_dir[1] + @INDEX.match(stylesheet_link_regex)[1] )
  # inline the stylesheet and save file
  File.write(full_path, @INDEX.gsub(
    stylesheet_link_regex,
    '<style amp-custom>'+@STYLESHEET+'</style>')
  )
end

after_build do

  PAGES_TO_AMP.each do |name|
    # inline in AMP version
    inline_stylesheet("build/amp/#{name}", name)
  end

end
