'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  Photo = mongoose.model('Photo'),
  multiparty = require('multiparty');
  //util = require('util');

//var getPhotoBody = function(photo) {
  //return photo.image.original;
//};

var getPhotoMeta = function(photo) {
  return {
    _id: photo._id,
    created: photo.created,
    contentType: photo.contentType,
    filename: photo.fileName,
    caption: photo.caption,
    user: photo.user
  };
};

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
  var photoData = [];

  form.on('part', function(part) {
      part.on('error', function(err) {
        return res.json(500, {
          error: 'Cannot upload photo ' + err
        });
      });

      if (part.name === 'photo') {

        //console.log('Part is the photo');
        photo.fileName = part.filename;
        photo.contentType = part.headers ? part.headers['content-type'] : null;
        //console.log('Set fileName to ' + fileName + ' and contentType to ' + contentType);
        
        photo.user = req.user;

        part.on('data', function(chunk){
          //console.log('Processing photo chunk');
          photoData.push(chunk);
        });

        part.on('end', function() {
          //console.log('Done processing photo stream. PhotoData[] is length ' + photoData.length);
          photo.image.original = Buffer.concat(photoData);
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

// Delete a photo
exports.destroy = function(req, res) {
  var photo = req.photo;

  photo.remove(function(err) {
    if (err) {
      return res.json(500, {
        error: 'Cannot delete the photo'
      });
    }
    res.send('TODO: Destroy response');
  });
};

exports.show = function(req, res) {
  if (req.photo) {
    //console.log('Got the photo');
    //console.log(util.inspect(req.photo));
    res.set('Content-Type', req.photo.contentType);
    res.status(200).send(req.photo.image.original);
  } else {
    return res.json(500, {
      error: 'Cannot show the photo'
    });
  }
};

// List the photos
exports.all = function(req, res) {
  var photoMeta = [];
  Photo.find().sort('-created').populate('user', 'name username').exec(function(err, photos) {
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
exports.currentUserPhotos = function(req, res) {
  var photoMeta = [];
  //only find photos where user matches req.user
  Photo.find({'user' : req.user}).sort('-created').populate('user', 'name username').exec(function(err, photos) {
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
