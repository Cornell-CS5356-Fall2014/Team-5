'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  Photo = mongoose.model('Photo'),
  PhotoImage = mongoose.model('PhotoImage'),
  images = require('./images'),
  multiparty = require('multiparty'),
  util = require('util');

// Find photo by id
exports.photo = function(req, res, next, id) {
  Photo.load(id, function (err, photo) {
    if (err) return next(err);
    if (!photo) return next(new Error('Failed to load photo ' + id));
    req.photo = photo;

    next();
  });
};

var saveThumbnail = function (photo, contentType, image, callback) {
  var thumb = new PhotoImage();
  console.log('In saveThumbnail')
  console.log(util.inspect(photo));
  images.createThumbnail(photo.fileName, photo, image.content, function (err, buffer) {
    console.log('In createThumbnail callback')
    if (err) return callback(err);
    thumb.content = buffer;
    thumb.contentType = contentType;
    photo.thumbnail = thumb;
    thumb.save(function (err) {
      if (err) return callback(err);
      console.log('Finished saving thumbnail to database');
      callback(null, thumb);
    });
  });
};

var saveImage = function (buffer, photo, contentType, image) {
  console.log('Done processing photo stream (length: ' + buffer.length + ')');
  image.content = Buffer.concat(buffer);
  image.contentType = contentType;
  photo.original = image;
  image.save(function (err) {
    if (err) throw err;
    console.log('Finished saving image to database');
  });
  console.log(util.inspect(photo));
};

var handlePhoto = function(user, part, photo, image, contentType) {
  var buffer = [];

  photo.user = user;
  photo.fileName = part.filename;
  photo.original = null;
  photo.thumbnail = null;
  part.on('data', function(chunk){
    buffer.push(chunk);
  });
  part.on('end', function() {
    saveImage(buffer, photo, contentType, image);
  });
};

var handleCaption = function (part, photo) {
  var caption = '';
  part.setEncoding('utf8');

  part.on('data', function(chunk){
    caption = caption.concat(chunk);
  });
  part.on('end', function(){
    photo.caption = caption;
  });
};

// Create a photo
exports.create = function(req, res) {
  var form = new multiparty.Form();
  var photo = new Photo();
  var image = new PhotoImage();
  var contentType = null;

  form.on('part', function(part) {
    part.on('error', function(err) {
      return res.status(500).json({ error: 'Cannot upload photo ' + err});
    });

    if (part.name === 'photo') {
      contentType = part.headers ? part.headers['content-type'] : null;
      handlePhoto(req.user, part, photo, image, contentType);

    } else if (part.name === 'caption') {
      handleCaption(part, photo);
    } else {
      throw new Error('Unexpected form name: ' + part.name);
    }
    //part.resume();
  });

  form.on('error', function(err) {
      return res.status(500).json({ error: 'Cannot upload photo ' + err});
    });

  form.on('close', function() {
    photo.save(function (err) {
      if (err) {
        return res.status(500).json({ error: 'Cannot upload photo ' + err});
      }
      saveThumbnail(photo, contentType, image, function (err, thumb) {
        if (err) console.log(err);
        photo.thumbnail = thumb;
        photo.save(function (err) {
          if (err) console.log(err);
          console.log('Added thumbnail to photo');
        });
      });
      res.send(photo);
    });
  });

  form.parse(req);
};

// Update photo metadata
exports.update = function(req, res) {
  var photo = req.photo;
  if (req.body && req.body.caption) {
    photo.caption = req.body.caption;
  }
  if (req.body && req.body.filename) {
    photo.fileName = req.body.filename;
  }

  photo.save(function (err) {  
    if (err) {
      return res.status(500).json({ error: 'Cannot update the photo '});
    }
    res.send(photo);
  });
};

// Delete a photo
exports.destroy = function(req, res) {
  var photo = req.photo;
  var images = [];
  if (photo.original) images.push(photo.original);
  if (photo.thumbnail) images.push(photo.thumbnail);

  photo.remove(function(err) {
    if (err) {
      return res.status(500).json({ error: 'Cannot delete the photo '});
    }
    images.forEach(function (image) {
      image.remove(function (err) {
        if (err) console.log(err);
      });
    });
    res.send(photo);
  });
};

exports.show = function(req, res) {
  console.log('Params are: \n' + util.inspect(req.params));
  console.log('Query is: \n' + util.inspect(req.query));
  res.json(req.photo);
};

exports.userPhotos = function(req, res) {
  Photo.find({'user' : req.user}).sort('-created').populate('user', 'name username').exec(function(err, photos) {
    if (err) {
      return res.json(500, {
        error: 'Cannot list the photos'
      });
    }
    console.log(util.inspect(photos));
    res.status(200).send(photos);
  });
};
