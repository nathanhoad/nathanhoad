const fs = require('fs-extra');
const chalk = require('chalk');

const compile = require('./compiler');
const config = require('./config');

/**
 * Run a web serve to serve out the static files
 */
function serve() {
  const express = require('express');
  const helmet = require('helmet');
  const compression = require('compression');

  const app = express();
  app.use(helmet());
  app.use(compression());
  app.use(express.static(config.PUBLIC_PATH));

  // Redirect 404s
  app.get('*', (request, reply) => {
    reply.redirect('/');
  });

  // Start the server
  const port = process.env.PORT || 3000;
  let listener = app.listen(port, () => {
    console.log(chalk.bold.green(`Listening on port ${port}`));
  });

  // Enable auto restarting in development
  if (process.env.NODE_ENV !== 'production') {
    const enableDestroy = require('server-destroy');
    enableDestroy(listener);

    // Recompile on changes to anything
    [config.POSTS_PATH, config.TEMPLATES_PATH].forEach(path => {
      fs.watch(path, { recursive: true }, async (event, filename) => {
        // Recompile posts
        await compile();

        // Purge all connections and close the server
        listener.destroy();
        listener = app.listen(port);

        // Set up connection tracking so that we can destroy the server when a file changes
        enableDestroy(listener);
      });
    });
  }
}

compile().then(serve);
