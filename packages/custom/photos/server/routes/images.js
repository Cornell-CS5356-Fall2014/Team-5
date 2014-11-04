var images = require('../controllers/images');

module.exports = function(Images, app, auth, database) {
  app.route('/images/:imageId')
    .get(auth.requiresLogin, photos.showImage);

  // Finish with setting up the photoId param
  app.param('imageId', images.image);
}
