'use strict';

var photos = require('../controllers/photos');

// Article authorization helpers
var hasAuthorization = function(req, res, next) {
  if (!req.user.isAdmin && req.photo.user.id !== req.user.id) {
    return res.send(401, 'User is not authorized');
  }
  next();
};

// The Package is past automatically as first parameter
module.exports = function(Photos, app, auth, database) {

  app.route('/photos')
    .get(auth.requiresLogin, photos.userPhotos)
    .post(auth.requiresLogin, photos.create);
  
  app.route('/photos/:photoId')
    .get(photos.show)
    .put(auth.requiresLogin, hasAuthorization, photos.update)
    .delete(auth.requiresLogin, hasAuthorization, photos.destroy);

  app.get('/upload/photo', auth.requiresLogin, function(req, res, next) {
    Photos.render('index', {
      package: 'photos'
    }, function(err, html) {
      //Rendering a view from the Package server/views
      res.send(html);
    });
  });

  // Finish with setting up the photoId param
  app.param('photoId', photos.photo);
};
