'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  //User = mongoose.model('User'),
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
    result.photos = allPhotos;

    Article.find({'user': user}).sort('-created').exec(function(err, articles) {
      if (err) res.json(500, {error: 'Cannot list articles'});

      console.log('Exporting ' + articles.length + ' total articles');
      articles.forEach(function (oneArticle) {
        result.articles.push(oneArticle);
      });

      res.send(result);
    });
  });
};
