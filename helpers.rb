helpers do
  include ERB::Util
  
  # Grab a posts title or the default title
  def page_title
    case
      when @post
        @post.title + " - Nathan Hoad"
      else
        "Nathan Hoad"
    end
  end
  
  # Grab the full url of the current site
  def url
    request.scheme + '://' + request.host
  end
  
  # Render a partial template
  # 
  # eg.
  #   partial :posts => @posts
  #   partial :post => post
  def partial (template, options = {})
    options = { :layout => false }.merge options
    if template.is_a? Hash
      options[:locals] = template[:locals] || {}
      template.delete(:locals) if template[:locals]      
      options[:locals].merge! template
      template = template.reject{ |key, value| [:locals].include? key }.keys.first.to_s
    end    
    erb("_#{template}".to_sym, options)
  end
  
  
  # Convert text to html
  def text_to_html (text, args = {})
    args = { :emotes => true, :map_headings => 2 }.merge args
    
    html = Moredown.text_to_html(text, args)
    html.gsub!('src="media/', 'src="/media/')
    html.gsub!(/<pre><code>#! (.*?)\n([^<]*?)<\/code><\/pre>/) { |match| "<pre><code class=\"#{$1.downcase.strip}\">#{$2.strip}</code></pre>" }
    
    if args[:teaser]
      paragraphs = html.scan(/<p.*?p>/)
      # ignore the first paragraph if it contains only an image
      if paragraphs.first =~ /<p><img.+?\/><\/p>/ or paragraphs.first =~ /<p><object.+?<\/object><\/p>/
        teaser = paragraphs[1]
      else
        teaser = paragraphs.first
      end
      
      if teaser != nil and teaser != html.strip and args[:slug]
        teaser += "<p><a href=\"/#{args[:slug]}\">Read more...</a></p>"
        html = teaser
      end
    end
    
    html
  end
  
  
  # Pluralise a string
  def pluralise (count, one, many = nil)
    many = "#{one}s" unless many
    if count == 1
      "1 #{one}"
    else
      "#{count} #{many}"
    end
  end
  
  
  # Distance of time in words
  def time_ago_in_words (time)
    t = (Time.now - time).to_i    
    case
      when t < 1.minute
        "less than a minute ago"
      when t < 50.minutes
        "#{pluralise((t / 1.minute).round, "minute")} ago"
      when t < 90.minutes
        "about an hour ago"
      when t < 18.hours
        "#{pluralise((t / 1.hour).round, "hour")} ago"
      when t < 2.day
        "about a day ago"
      when t < 20.days
        "#{pluralise((t / 1.day).round, "day")} ago"
      when t < 1.month
        "about a month ago"
      when t < 6.months
        "#{pluralise((t / 1.month).round, "month")} ago"
      else
        time.strftime("%B %d, %Y")
    end
  end
  
  
  # Link to a post unless the post is a link itself
  def post_title (post)
    if post.link
      "<a href=\"#{post.link}\" title=\"#{post.link}\">&#9733; #{post.title}</a>"
    else
      link_to_post(post)
    end
  end
  
  # Link to a post
  def link_to_post (post, label = nil)
    label ||= post.title
    "<a href=\"/#{post.slug}\">#{label}</a>"
  end
  
  
  # Render the tags for a post
  def tags (tags)
    tags = [tags] if tags.is_a? String
    
    tags = tags.collect do |tag| 
      if tags.size > 1
        if tag == tags.last
          prefix = 'and '
        else
          suffix = ','
        end
      end
      "<li>#{prefix}<a href=\"/tags/#{tag}\">#{tag}</a>#{suffix}</li>"
    end
    "<ul>#{tags.sort.join(' ')}</ul>"
  end
  
  
  # Render links to the next and previous things
  def where_to_now? (relative_to)
    if relative_to.class == Post
      newer_post = Post.previous_before(relative_to)
      older_post = Post.next_after(relative_to)

      newer_post = (newer_post)? "#{link_to_post(newer_post)} is next" : "<span>Nothing is next</span>"
      older_post = (older_post)? "Previously, #{link_to_post(older_post)}" : "<span>Previously, nothing</span>"
      options = "<ul data-context=\"posts\"><li>#{newer_post}</li><li>#{older_post}</li></ul>"
    else # page number
      older_posts = (Post.page(relative_to + 1).empty?)? "<span>No older posts</span>" : "<a href=\"/?page=#{relative_to + 1}\">Older posts</a>"
      newer_posts = (relative_to > 1)? "<a href=\"/?page=#{relative_to - 1}\">Newer posts</a>" : "<span>No newer posts</span>"
      options = "<ul data-context=\"pages\"><li>#{older_posts}</li><li>#{newer_posts}</li></ul>"
    end
    
    "<h4>Where to now?</h4>\n#{options}"
  end
end


# Extend Fixnum to add some time stuff (like Active Support)
class Fixnum
  def minute
    self * 60
  end
  alias :minutes :minute
  
  def hour
    self.minutes * 60
  end
  alias :hours :hour
  
  def day
    self.hours * 24
  end
  alias :days :day
  
  def month
    self.days * 30
  end
  alias :months :month
end