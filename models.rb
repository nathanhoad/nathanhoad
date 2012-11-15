class Post < Maneki
  path 'posts'
  
  
  # Grab a handful of posts
  def self.page (n, per_page = 5)
    n = 1 unless n
    start = (n.to_i - 1) * per_page
    
    return [] if start >= all.size
    
    finish = start + per_page
    finish = all.size if finish > all.size
    
    all.sort[start...finish]
  end
  
  
  # Archive posts
  def self.archive
    years_months_posts = all.inject({}) do |archive, post|
      year_month = Time.local(post.published_at.year, post.published_at.month)
      archive[year_month] ||= []
      archive[year_month] << post
      archive
    end
    years_months_posts.sort.reverse
  end
  
  # Search for some posts
  def self.search (keywords)
    found = {}
    keywords.split(' ').each do |keyword|
      posts = find :match => :any, :title => keyword, :body => keyword, :headers => { :tags => keyword }      
      
      # First lot of results is our base
      if found.empty?
        found = posts
      end
      
      # Then remove anything that doesn't match all keywords
      found = found.select { |post| posts.include? post }
    end
    found.sort
  end
  
  
  # Find posts that are tagged with a given tag
  def self.find_tagged_with (tag)
    posts = Post.find :headers => { :tags => tag }
    posts.sort
  end
  
  
  # This post's tags
  def tags
    @headers[:tags]
  end
  
  
  # When a post was published
  def published_at
    Chronic.parse(@headers[:published]) if @headers[:published]
  end
  
  
  # Some posts are just links
  def link
    @headers[:link]
  end
  
  
  # Check if this post is valid
  def valid?
    return false if @headers.nil?
    return false if published_at.nil? or published_at > Time.now.getlocal
    return false if tags.nil? or tags.empty?
    true
  end
  
  
  # Sort by publish date in reverse order
  def <=> (rhs)
    rhs.published_at <=> published_at
  end
end