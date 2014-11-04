'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  Photo = mongoose.model('Photo'),
  Image = mongoose.model('Image'),
  fs = require('fs'),
  gm = require('gm'),
  im = gm.subClass({ imageMagick: true });

exports.image = function(req, res, next, id) {
  Image.load(id, function (err, image) {
    if (err) return next(err);
    if (!image) return next(new Error('Failed to load image ' + id));
    req.image = image;
    next();
  });
};

var size = {width: 100, height: 100};

exports.thumbnail = function(filename, photo, buffer, callback) {
  var ext = filename.split('.').pop();
  var tmp_orig = photo._id.toString() + ext;
  var tmp_thumb = photo._id.toString() + '_thumb' + ext;
  fs.writeFile(tmp_orig, buffer, function(err) {
    if (err) return callback(err);
    console.log('Wrote temp original photo to ' + tmp_orig);
    im(image).resize(size.width, size.height)
      .write(tmp_thumb, function (err) {
        if (err) return callback(err);
        console.log('Wrote temp thumbnail photo to ' + tmp_thumb);
        fs.readFile(tmp_thumb, function (err, data) {
          if (err) return callback(err);
          callback(null, data);
        });
      });
  });
};

exports.show = function(req, res) {
  var image = req.image;
  if (image) {
    res.set('Content-Type', image.contentType);
    res.status(200).send(image.content);
  }
};
