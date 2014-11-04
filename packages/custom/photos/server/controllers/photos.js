'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  Photo = mongoose.model('Photo'),
  Image = mongoose.model('Image'),
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

// Create a photo
exports.create = function(req, res) {
  var form = new multiparty.Form();
  var photo = new Photo();
  var image = new Image();
  var thumb = new Image();
  var imageBuffer = [];
  var contentType = null;

  form.on('part', function(part) {
    part.on('error', function(err) {
      return res.json(500, {
        error: 'Cannot upload photo ' + err
      });
    });

    if (part.name === 'photo') {

      photo.fileName = part.filename;
      contentType = part.headers ? part.headers['content-type'] : null;
      //photo.contentType = part.headers ? part.headers['content-type'] : null;
      
      photo.user = req.user;

      part.on('data', function(chunk){
        imageBuffer.push(chunk);
      });

      part.on('end', function() {
        console.log('Done processing photo stream. imageBuffer[] is length ' + photoBuffer.length);
        image.content = Buffer.concat(imageBuffer);
        image.contentType = contentType;
        photo.original = image;
        image.save(function (err) {
          if (err) throw err;
          console.log('Finished saving image to database');
        }
        console.dir(photo);
        images.thumbnail(photo.fileName, photo, image.data, function (err, buffer) {
          if (err) throw err;
          thumb.content = buffer;
          thumb.contentType = contentType;
          photo.thumbnail = thumb;
          thumb.save(function (err) {
            if (err) throw err;
            console.log('Finished saving thumbnail to database');
          });
        });
      });

    } else if (part.name === 'caption') {

      var caption = '';
      //console.log('Part is the caption');
      part.setEncoding('utf8');

      part.on('data', function(chunk){
        caption = caption.concat(chunk);
      });
      part.on('end', function(){
        photo.caption = caption;
      });

    } else {
      throw new Error('Unexpected form name: ' + part.name);
    }

    //console.log(util.inspect(part) + '\n\n');
    part.resume();
  });

  form.on('error', function(err) {
      return res.json(500, {
        error: 'Cannot upload photo ' + err
      });
    });

  form.on('close', function() {
    photo.save(function(err) {
      if (err) {
        return res.json(500, {
          error: 'Cannot upload the photo ' + err
        });
      }
      //console.log('All Done');
      res.send(getPhotoMeta(photo));
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
  //console.log('Body of the update request: ' + util.inspect(req.body));
  photo.save( function(err) {
    
    if (err) {
      return res.json(500, {
        error: 'Cannot update the photo'
      });
    }
    res.json(getPhotoMeta(photo));
  });
};

// Delete a photo
exports.destroy = function(req, res) {
  var photo = req.photo;

  photo.remove(function(err) {
    if (err) {
      return res.json(500, {
        error: 'Cannot delete the photo'
      });
    }
    res.send(getPhotoMeta(photo));
  });
};

exports.show = function(req, res) {
  console.log('Params are: \n' + util.inspect(req.params));
  console.log('Query is: \n' + util.inspect(req.query));
  res.json(getPhotoMeta(req.photo));
};

exports.showImage = function(req, res) {
  var photo = req.photo;

  console.log(getPhotoMeta(photo));
  console.log(req.params);
  console.log(req.query);
  if (req.query && req.query.version) {
    switch (req.query.version) {
      case 'original':
        console.log('Sending Original');
        res.set('Content-Type', photo.contentType);
        res.status(200).send(getImageOriginal(photo));
        break;
      case 'thumbnail':
        if (photo && photo.image && photo.image.thumbnail) {
          res.set('Content-Type', photo.contentType);
          res.status(200).send(getImageThumbnail(photo));
        } else {
          res.json(404, {
            error: 'Image version does not exist.'
          });
        }
        break;
      default:
        res.json(404, {
          error: 'Image version does not exist.'
        });
        break;
    }
  }
  else if (photo && photo._id) {
    console.log('In redirect');
    //res.redirect(photo._id + '?version=original');
    res.set('Content-Type', photo.contentType);
    res.status(200).send(getImageOriginal(photo));
  } else {
    res.json(404, {
      error: 'Image version does not exist.'
    });
  }
};

/*exports.showOriginal = function(req, res) {
  if (req.photo) {
    res.set('Content-Type', req.photo.contentType);
    res.status(200).send(req.photo.image.original);
  } else {
    return res.json(500, {
      error: 'Cannot show the photo'
    });
  }
};*/

// List the photos
exports.all = function(req, res) {
  var photoMeta = [];
  Photo.find({}, {image: 0}).sort('-created').populate('user', 'name username').exec(function(err, photos) {
    if (err) {
      return res.json(500, {
        error: 'Cannot list the photos'
      });
    }
    photos.forEach(function(photo){
      photoMeta.push(getPhotoMeta(photo));
    });
    res.status(200).send(photoMeta);
  });
};

// List the photos
exports.userPhotos = function(req, res) {
  //var photoMeta = [];
  //only find photos where user matches req.user
  Photo.find({'user' : req.user}, {image: 0}).sort('-created').populate('user', 'name username').exec(function(err, photos) {
    if (err) {
      console.log('ERROR ' + err);
      return res.json(500, {
        error: 'Cannot list the photos'
      });
    }
    console.log('Photos to be exported: ' + util.inspect(photos));
    //photos.forEach(function(photo){
      //photoMeta.push(getPhotoMeta(photo));
    //});
    res.status(200).send(photos);
  });
};
