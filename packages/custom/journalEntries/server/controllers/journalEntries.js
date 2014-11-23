'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  JournalEntry = mongoose.model('JournalEntry'),
  Comment = mongoose.model('Comment'),
  User = mongoose.model('User'),
  util = require('util'),
  Promise = require('promise');

// Find photo by id
exports.journalEntry = function(req, res, next, id) {
  JournalEntry.load(id, function (err, journalEntry) {
    if (err) return next(err);
    if (!journalEntry) return next(new Error('Failed to load journal entry ' + id));
    req.journalEntry = journalEntry;
    next();
  });
};

// journalEntries.getJournalEntry

exports.getJournalEntriesIncludingFriends = function(req, res) {
	
	var users = [req.user];
	var userQueryDictArray = [];
	users = users.concat(req.user.friends);

	var userQueryDictArray = users.map(function(user) {
		return {'user' : user};
	})

	return getEntries(req, res, userQueryDictArray)
}

exports.getJournalEntries = function(req, res) {
  return getEntries(req, res, {'user' : req.user})
}

function getEntries(req, res, userDicts) {
  JournalEntry.find(userDicts).sort('-created').exec(function(err, journalEntries) {
    if (err) {
      return res.json(500, {
        error: 'Cannot list the journal entries'
      });
    }

    res.status(200).send(journalEntries);
    
    // //journalEntriesTransforms = []
    // var promises = journalEntries.map(function(journalEntry) {
    //   return new Promise(function(resolve, reject) {
    //     journalEntryForPublicJSON(journalEntry, function(err, journalEntryJSON) {
    //       if (err) reject(err);
    //       //journalEntriesTransforms.push(journalEntryJSON);
    //       console.log('Promise was successful!!');
    //       console.log(util.inspect(journalEntries));
    //       resolve(journalEntryJSON);
    //     });
    //   });
    // });

    // Promise.all(promises).then(function(journalEntriesTransforms) {
    //   console.log('All Promise was successful!!');
    //   console.log(util.inspect(journalEntries));
    //   res.status(200).send(journalEntries);
    // });

    
  });
}

exports.create = function(req, res) {
 
  console.log('request body');
  console.log(util.inspect(arguments));

  var params = {
                user : req.user,
                photoList : req.body.photoList.parse(),
                title : req.body.title,
                detailText : req.body.detailText,
                likerList : [],
                commentList : []
              }

  var journalEntry = new JournalEntry(params);

  console.log('Creating journal entry');
  console.log(util.inspect(journalEntry));

  journalEntry.save(function(err) {
    if (err) {
      return res.json(500, {
        error: 'Cannot save the journal entry'
      });
    }

    console.log('Saved journal entry');
    console.log(util.inspect(journalEntry));

    JournalEntry.load(journalEntry._id, function (err, j) {
      if (err) return next(err);
      if (!journalEntry) return next(new Error('Failed to load journal entry ' + id));
      console.log('reloaded journal entry');
      console.log(util.inspect(j));
      res.json(journalEntry);

      journalEntryForPublicJSON(journalEntry, function(err, journalEntryJSON) {
        if (err) return next(err);
        res.json(journalEntryJSON);
      });
    });
  });
};


function journalEntryForPublicJSON(journalEntry, cb) {

  var commentQueryDictArray = journalEntry.comments.map(function(commentId) {
    return {_id : commentId};
  });

  var photoQueryDictArray = journalEntry.photos.map(function(photoId) {
    return {_id : photoId};
  });

  Comment
    .find(commentQueryDictArray)
    .exec(function(err, comments) {
      if (err) {
        cb(err, null);
        return;
      }

      var commentUsers = comments.map(function(comment) {
        return comment.user;
      });

      var users = new Set([journalEntry.user].concat(journalEntry.likerList).concat(commentUsers));
      var userQueryDictArray = [];

      users.forEach(function(userId) {
        userQueryDictArray.push({_id : userId});
      });

      User
        .find(userQueryDictArray)
        .exec(function(err, users) {
          if (err) {
            cb(err, null);
            return;
          }

          var userDictionary = {};
          users.forEach(function(user) {
            var id = user._id
            userDictionary = { id : {id: user._id, name: user.name, username: user.username}}
          });

          Photo
            .find(photoQueryDictArray)
            .exec(function(err, photos) {

              if (err) {
                cb(err, null);
                return;
              }

              commentsArray = comments.map(function(comment) {
                return {user: userDictionary[comment.user], createdDate: comment.createdDate, text: comment.text};
              });

              photosArray = photos.map(function(photo) {
                return {user: userDictionary[photo.user], created: photo.created, fileName: photo.fileName, 
                  caption: photo.caption, original: photo.original, thumbnail: photo.thumbnail};
              });

              likerArray = journalEntry.likerList.map(function(liker) {
                return userDictionary[liker];
              });

              var journalEntryDictionary =  {
                user: userDictionary[journalEntry.user],
                photoList: photosArray,
                title: journalEntry.title,
                detailText: journalEntry.detailText,
                likerList: likerArray,
                commentList: commentsArray
              }

              cb(null, journalEntryDictionary);
            });

        });

    });
  
}

// exports.journalEntriesForUsers = function(req, res) {
//   JournalEntry.find({'user' : req.user}).sort('-created').populate('user', 'name username').exec(function(err, photos) {
//     if (err) {
//       return res.json(500, {
//         error: 'Cannot list the photos'
//       });
//     }
//     console.log(util.inspect(photos));
//     res.status(200).send(photos);
//   });
// };


// journalEntries.create