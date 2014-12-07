'use strict';

var journalEntries = require('../controllers/journalEntries');



// // Article authorization helpers
// var hasAuthorization = function(req, res, next) {
//   if (!req.user.isAdmin && req.photo.user.id !== req.user.id) {
//     return res.send(401, 'User is not authorized');
//   }
//   next();
// };

// The Package is past automatically as first parameter
module.exports = function(JournalEntries, app, auth, database) {


  

  app.route('/journalEntries')
    //note that 
    .get(auth.requiresLogin, journalEntries.getJournalEntriesIncludingFriends)
    .post(auth.requiresLogin, journalEntries.create);

  app.route('/user/journalEntries')
    //note that 
    .get(auth.requiresLogin, journalEntries.getJournalEntries);

  app.route('/journalEntries/:journalEntryId')
    .get(auth.requiresLogin, journalEntries.journalEntry);

  // Finish with setting up the photoId param
  app.param('journalEntryId', journalEntries.journalEntry);
  
  // app.route('/photos/:photoId')
  //   .get(photos.show)
  //   .put(auth.requiresLogin, hasAuthorization, photos.update)
  //   .delete(auth.requiresLogin, hasAuthorization, photos.destroy);

  // app.get('/upload/photo', auth.requiresLogin, function(req, res, next) {
  //   Photos.render('index', {
  //     package: 'photos'
  //   }, function(err, html) {
  //     //Rendering a view from the Package server/views
  //     res.send(html);
  //   });
  // });

  
};