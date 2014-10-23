'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  //User = mongoose.model('User'),
  photoController = require('../../../photos/server/controllers/photos'),
  Photo = mongoose.model('Photo'),
  Article = mongoose.model('Article');

exports.dump = function(req, res) {
  var user = req.user;
  var result = {
    user: req.user,
    photos: [],
    articles: []
  };

  console.log('Beginning data dump');

  Photo.find({'user' : user}).sort('-created').exec(function(err, allPhotos) {
    if (err) res.json(500, {error: 'Cannot list photos'});
    console.log('Exporting ' + allPhotos.length + ' total photos');

    allPhotos.forEach(function (onePhoto) {
      result.photos.push(photoController.getPhotoMeta(onePhoto));
    });

    Article.find({'user': user}).sort('-created').exec(function(err, articles) {
      if (err) res.json(500, {error: 'Cannot list articles'});

      console.log('Exporting ' + articles.length + ' total photos');

      articles.forEach(function (oneArticle) {
        result.articles.push(oneArticle);
      });

      res.send(result);
    });
  });
};