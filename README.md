# Ruby + Markdown + Git powered Blog

[Maneki](http://github.com/nathanhoad/maneki/) grabs Markdown documents from disk, parses them into memory for meta-data, and serves them up. My reasoning is that Atom/Sublime/Whatever is great for writing articles and Git is great for keeping things organised. Throw Ruby and Sinatra into the mix and you have all the ingredients for an insanely simple blogging engine.

I'm currently using it to power my blog at [nathanhoad.net](http://nathanhoad.net).


## Making your own

1. Delete everything in `./posts`
2. Delete anything in `./public/images` 
3. Create your own `./public/stylesheets/application.css`
4. Modify `./views/layout.haml` as needed
5. Create some posts in `./posts` (in Markdown format with a `.text` file extension).

### Post format

Here is an example of the post format:

    # Post title

     - published: 2014-09-14 23:50
     - tags: readme, example

    This is the content of the post. Here is [a link to something](http://nathanhoad.net).

The `published` field is in MySQL datetime format is used to decide if a post is published yet or not.

The `tags` field is a comma separated list of tags.