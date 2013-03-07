helpers do
  include ERB::Util
  
  # Grab a posts title or the default title
  def page_title
    case
      when @post
        "#{@post.title} - Nathan Hoad"
      when @tag
        "Tagged with ##{@tag} - Nathan Hoad"
      else
        "Nathan Hoad"
    end
  end
  
  
  # Get the page description
  def page_description
    if defined?(@post) && ! @post.nil?
      paragraphs = @post.body.split("\n\n")
      if paragraphs.first =~ /^\!/
        description = paragraphs[1]
      else
        description = paragraphs.first
      end
      description.gsub(/<\/?p>/, '').gsub(/\[(.*?)\]\(.*?\)/){ |match| $1 }
      
    elsif defined?(@tag) && ! @tag.nil?
      "Posts tagged with ##{@tag}"
      
    else
      "I'm Nathan Hoad and I'm a software geek that loves the beauty of simple things. I blog about Ruby, Rails, Sinatra, Git, and Graphic Design"
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
    haml("_#{template}".to_sym, options)
  end
  
  
  # Convert text to html
  def text_to_html (text, args = {})
    args = { :emotes => false, :map_headings => 2 }.merge args
    
    html = Moredown.text_to_html(text, args)
    html.gsub!('src="media/', 'src="/media/')
    html.gsub!(/<pre><code>#! (.*?)\n([^<]*?)<\/code><\/pre>/) { |match| "<pre><code class=\"#{$1.downcase.strip}\">#{$2.strip}</code></pre>" }
    
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
  
  
  # Link to a post
  def post_title (post)
    link_to_post(post)
  end
  
  
  # Link to a url
  def link_to (label, url)
    "<a href='#{url}'>#{label}</a>"
  end
  
  
  # Link to a post
  def link_to_post (post, label = nil)
    label ||= post.title
    "<a href='/#{post.slug}'>#{label}</a>"
  end
  
  
  # Render the tags for a post
  def tags (tags)
    tags = [tags] if tags.is_a? String
    
    tags = tags.map{ |tag| "<li><a href=\"/tags/#{tag}\">##{tag}</a></li>" }
    
    "<ul>#{tags.sort.join(' ')}</ul>"
  end
  
  
  # Render links to the next and previous things
  def where_to_now? (relative_to)
    newer_post = Post.previous_before(relative_to)
    older_post = Post.next_after(relative_to)
      
    newer_post = (newer_post)? "#{link_to_post(newer_post)} is next" : ""
    older_post = (older_post)? "Previously, #{link_to_post(older_post)}" : ""
    
    "<ul><li>#{newer_post}</li><li>#{older_post}</li></ul>"
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