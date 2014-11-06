'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  JournalEntry = mongoose.model('JournalEntry'),
  Comment = mongoose.model('Comment'),
  util = require('util');

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

exports.getJournalEntriesIncludingFriendsEntries = function(includeFriendsEntries) {
	
	var users = [req.user];
	var userQueryDictArray = [];
	if (includeFriendsEntries) {
		users = users.concat(req.user.friends);
	}

	var userQueryDictArray = users.map(function(user) {
		return {'user' : user};
	})

	return function(req, res) {

		JournalEntry.find(userQueryDictArray).sort('-created').exec(function(err, journalEntries) {
		    if (err) {
		      return res.json(500, {
		        error: 'Cannot list the journal entries'
		      });
		    }
		    console.log(util.inspect(journalEntries));
		    res.status(200).send(journalEntries);
	  	});
	}

}

exports.create = function(req, res) {
  var journalEntry = new JournalEntry(req.body);

  journalEntry.user = req.user;

  console.log('Creating journal entry');
  console.log(util.inspect(journalEntry));

  journalEntry.save(function(err) {
    if (err) {
      return res.json(500, {
        error: 'Cannot save the journal entry'
      });
    }
    res.json(journalEntry);

  });
};

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