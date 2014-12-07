'use strict';

var dumpster = require('../controllers/datadump');

// Article authorization helpers
//var hasAuthorization = function(req, res, next) {
  //if (!req.user.isAdmin && req.article.user.id !== req.user.id) {
    //return res.send(401, 'User is not authorized');
  //}
  //next();
//};

// The Package is past automatically as first parameter
module.exports = function(Datadump, app, auth, database) {

  app.route('/export')
    .get(auth.requiresLogin, dumpster.dump);
};
