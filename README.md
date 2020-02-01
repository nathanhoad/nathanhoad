<img src="templates/footer.gif" />

# Nathan Hoad

The code that powers [https://nathanhoad.net](https://nathanhoad.net)

## Writing posts

Create a folder in the `/posts` directory and name it what your slug/url is going to be (eg. `posts/just-start-now`).

Now create a `.text` file of the same name as the folder and put it in that folder (eg. `posts/just-start-now/just-start-now.text`).

The first lines of the post will be its title, followed by a list of its headers:

```
# Just start now

- published: 2018-03-06
- tags: games, painting
- share: some-image.jpg

There is a long road between a dream and reality. The path is not well worn and sometimes hard to see.

...
```

## Developing

To run the server just do `npm start`. Posts will be compiled statically and then a simple asset server will spin up.

In development mode (`NODE_ENV !== 'production'`) the server will watch for changes to posts and templates and recompile/restart when needed.
