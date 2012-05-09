require 'rubygems'
require 'sinatra'
require 'chronic'
require 'maneki'
require 'moredown'
require 'erb'

ENV['TZ'] = 'Australia/Brisbane'

require 'models'
require 'helpers'


get '/' do
  if params[:page] == '1'
    redirect '/'
  end
  @page = (params[:page] || 1).to_i
  @posts = Post.page(@page) || raise(Sinatra::NotFound)
  erb :index
end


get '/tags/:tag/?' do
  @tag = params[:tag]
  @posts = Post.find_tagged_with(@tag)
  erb :tag
end


get '/archive/?' do
  @posts_by_month_and_year = Post.archive
  erb :archive
end


get '/rss' do
  @posts = Post.page(1, 10)
  content_type 'application/rss+xml'
  erb :rss, :layout => false
end


get '/sitemap.xml' do
  @posts = Post.all
  content_type 'text/xml'
  erb :sitemap, :layout => false
end


get '/media/:file.:ext' do
  filename = File.dirname(__FILE__) + '/posts/media/' + params[:file] + '.' + params[:ext]
  if File.file? filename
    send_file(filename)
  else
    raise(Sinatra::NotFound)
  end
end


get '/:slug.text' do
  filename = File.dirname(__FILE__) + '/posts/' + params[:slug] + '.text'
  if File.file? filename
    content_type 'text/plain'
    File.open filename
  end
end


get '/:slug/?' do
  @post = Post.find(params[:slug])
  
  if @post
    erb :post
  else
    @keyword = params[:slug].gsub('-', ' ')
    @posts = Post.search(@keyword)
    erb :search
  end
end


before do
  # Redirect to nathanhoad.net
  unless request.env['REMOTE_ADDR'] == '127.0.0.1'
    redirect 'http://nathanhoad.net' if request.env['HTTP_HOST'] != 'nathanhoad.net'
  end
end

not_found do
  erb :not_found
end