'use strict';

var photos = require('../controllers/photos');

// Article authorization helpers
var hasAuthorization = function(req, res, next) {
  if (!req.user.isAdmin && req.article.user.id !== req.user.id) {
    return res.send(401, 'User is not authorized');
  }
  next();
};

// The Package is past automatically as first parameter
module.exports = function(Photos, app, auth, database) {

  app.route('/photos')
    .get(auth.requiresLogin, photos.currentUserPhotos)
    .post(auth.requiresLogin, photos.create);
  app.route('/photos/:photoId')
    .get(photos.show)
    .delete(auth.requiresLogin, hasAuthorization, photos.destroy);


  //app.get('/photos/example/anyone', function(req, res, next) {
    //res.send('Anyone can access this');
  //});

  //app.get('/photos/example/auth', auth.requiresLogin, function(req, res, next) {
    //res.send('Only authenticated users can access this');
  //});

  //app.get('/photos/example/admin', auth.requiresAdmin, function(req, res, next) {
    //res.send('Only users with Admin role can access this');
  //});

  app.get('/photos/example/upload', auth.requiresLogin, function(req, res, next) {
    Photos.render('index', {
      package: 'photos'
    }, function(err, html) {
      //Rendering a view from the Package server/views
      res.send(html);
    });
  });

  // Finish with setting up the articleId param
  app.param('photoId', photos.photo);
};
