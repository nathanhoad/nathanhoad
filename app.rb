require 'rubygems'
require 'sinatra'
require 'chronic'
require 'maneki'
require 'moredown'
require 'erb'
require 'haml'
require 'sass'

require_relative 'models'
require_relative 'helpers'


set :scss, views: "public/stylesheets"
get '/stylesheets/application.css' do
  scss :application, style: :compressed
end


get '/' do
  filename = File.dirname(__FILE__) + '/public/cache/_index.html'
  if File.file? filename
    File.open(filename)
  else
    @posts = Post.index || raise(Sinatra::NotFound)
  
    html = haml :index
    File.write(filename, html)
  
    html
  end
end


get '/tags/:tag/?' do
  @tag = params[:tag]
  @posts = Post.find_tagged_with(@tag)
  haml :tag
end


get '/archive/?' do
  @posts_by_month_and_year = Post.archive
  haml :archive
end


get '/rss' do
  @posts = Post.index
  content_type 'application/rss+xml'
  erb :rss, layout: false
end


get '/sitemap.xml' do
  @posts = Post.all
  content_type 'text/xml'
  erb :sitemap, :layout => false
end


get '/media/:file.:ext' do
  filename = File.dirname(__FILE__) + '/posts/media/' + params[:file] + '.' + params[:ext]
  if File.file? filename
    cache_control :public, max_age: 1.week
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
  filename = File.dirname(__FILE__) + '/public/cache/' + params[:slug] + '.html'
  if File.file? filename
    File.open(filename)
  else
    @post = Post.find(params[:slug])
  
    if @post
      html = haml :post
      File.write(filename, html)
      html
    else
      @keyword = params[:slug].gsub('-', ' ')
      @posts = Post.search(@keyword)
      haml :search
    end
  end
end


before do
  unless settings.development?
    redirect "https://nathanhoad.net" if request.host != 'nathanhoad.net' || request.scheme != 'http'
  end
end


not_found do
  haml :not_found
end