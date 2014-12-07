'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  PhotoImage = mongoose.model('PhotoImage'),
  path = require('path'),
  fs = require('fs'),
  gm = require('gm'),
  im = gm.subClass({ imageMagick: true });

exports.image = function(req, res, next, id) {
  PhotoImage.load(id, function (err, image) {
    if (err) return next(err);
    if (!image) return next(new Error('Failed to load image ' + id));
    req.image = image;
    next();
  });
};

var size = {width: 100, height: 100};

exports.createThumbnail = function(filename, photo, buffer, callback) {
  console.log(arguments);
  var ext = '.' + filename.split('.').pop();
  var tmpPath = path.join(process.env.HOME);
  var tmp_orig = path.join(tmpPath, photo._id.toString() + ext);
  var tmp_thumb = path.join(tmpPath, photo._id.toString() + '_thumb' + ext);

  console.log('Attempting to write ' + tmp_orig);
  if (!Buffer.isBuffer(buffer)) {
    return callback(new Error('Invalid buffer'));
  }
  fs.writeFile(tmp_orig, buffer, function(err) {
    if (err) {
      console.log('writeFile error: ' + err);
      return callback(err);
    }
    console.log('Finished writing ' + tmp_orig);
    console.log('Attempting to resize ' + tmp_orig);
    im(tmp_orig).resize(size.width, size.height)
      .write(tmp_thumb, function (err) {
        if (err) { 
          console.log('im resize error: ' + err);
          return callback(err);
        }
        console.log('Finished resizing to ' + tmp_thumb);
        console.log('Attempting to read ' + tmp_thumb);
        fs.unlink(tmp_orig, function (err) {
          if (err) console.log('Error deleting ' + tmp_orig);
        });
        fs.readFile(tmp_thumb, function (err, data) {
          if (err) {
            console.log('readFile error: ' + err);
            return callback(err);
          }
          console.log('Finished reading' + tmp_thumb);
          fs.unlink(tmp_thumb, function (err) {
            if (err) console.log('Error deleting ' + tmp_thumb);
          });
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
  } else {
    res.json(404, {
      error: 'Image does not exist.'
    });
  }
};
