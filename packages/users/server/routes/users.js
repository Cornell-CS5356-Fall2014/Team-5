'use strict';

// User routes use users controller
var users = require('../controllers/users'),
    config = require('meanio').loadConfig();

var logFB = function(req, res, next) {
  console.log(process.env.FB_CLIENT_ID);
  console.log(process.env.FB_CLIENT_SECRET);
  console.log(process.env.BASE_URL + '/auth/facebook/callback');
  next();
};

module.exports = function(MeanUser, app, auth, database, passport) {

  app.route('/logout')
    .get(users.signout);
  app.route('/users/me')
    .get(users.me);

  app.route('/testLog')
    .post(function(req, res) {
      console.log(req.body.logText);
      res.status(200).send({});
    });

  app.route('/following')
    .get(auth.requiresLogin, users.getFollowing)
    .post(auth.requiresLogin, users.addUserToFollowing)
    .delete(auth.requiresLogin, users.removeUserFromFollowing);

  app.route('/followers')
    .get(auth.requiresLogin, users.getFollowers);

  app.route('/users')
    .get(auth.requiresLogin, users.allUsers);

  app.route('/users/:otherUserId')
      .get(auth.requiresLogin, users.oneUser);

  app.param('otherUserId', function (req, res, next, otherUserId) {
    console.log('Setting otherUserId to ' + otherUserId);
    next();
  });

  // Setting up the users api
  app.route('/register')
    .post(users.create);

  app.route('/forgot-password')
    .post(users.forgotpassword);

  app.route('/reset/:token')
    .post(users.resetpassword);

  // Setting up the userId param
  app.param('userId', users.user);

  // AngularJS route to check for authentication
  app.route('/loggedin')
    .get(function(req, res) {
      res.send(req.isAuthenticated() ? req.user : '0');
    });


  // Setting the local strategy route
  app.route('/login')
    .post(passport.authenticate('local', {
      failureFlash: true
    }), function(req, res) {
      res.send({
        user: req.user,
        redirect: (req.user.roles.indexOf('admin') !== -1) ? req.get('referer') : false
      });
    });

  // AngularJS route to get config of social buttons
  app.route('/get-config')
    .get(function (req, res) {
      res.send(config);
    });

  // Setting the facebook oauth routes
  app.route('/auth/facebook')
    .get(logFB, passport.authenticate('facebook', {
      scope: ['email', 'user_about_me'],
      failureRedirect: '#!/login'
    }), users.signin);

  app.route('/auth/facebook/callback')
    .get(passport.authenticate('facebook', {
      failureRedirect: '#!/login'
    }), users.authCallback);


  app.post('/auth/facebook/token',
    passport.authenticate('facebook-token'),
    function (req, res) {
      // do something with req.user
      //res.send(req.user? 200 : 401);
      res.status(200).send({});
    }
  );

};
