'use strict';

var images = require('../controllers/images');

module.exports = function(PhotoImages, app, auth, database) {
  app.route('/images/:imageId')
    .get(auth.requiresLogin, images.show);

  // Finish with setting up the photoId param
  app.param('imageId', images.image);
};
