'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  User = mongoose.model('User'),
  async = require('async'),
  config = require('meanio').loadConfig(),
  crypto = require('crypto'),
  nodemailer = require('nodemailer'),
  templates = require('../template'),
  util = require('util');

/**
 * Auth callback
 */
exports.authCallback = function(req, res) {
  res.redirect('/');
};

/**
 * Show login form
 */
exports.signin = function(req, res) {
  if (req.isAuthenticated()) {
    return res.redirect('/');
  }
  res.redirect('#!/login');
};

/**
 * Logout
 */
exports.signout = function(req, res) {
  req.logout();
  res.redirect('/');
};

/**
 * Session
 */
exports.session = function(req, res) {
  res.redirect('/');
};

/**
 * Create user
 */
exports.create = function(req, res, next) {
  var user = new User(req.body);

  user.provider = 'local';

  // because we set our user.provider to local our models/user.js validation will always be true
  req.assert('name', 'You must enter a name').notEmpty();
  req.assert('email', 'You must enter a valid email address').isEmail();
  req.assert('password', 'Password must be between 8-20 characters long').len(8, 20);
  req.assert('username', 'Username cannot be more than 20 characters').len(1, 20);
  req.assert('confirmPassword', 'Passwords do not match').equals(req.body.password);

  var errors = req.validationErrors();
  if (errors) {
    return res.status(400).send(errors);
  }

  // Hard coded for now. Will address this with the user permissions system in v0.3.5
  user.roles = ['authenticated'];
  user.save(function(err) {
    if (err) {
      switch (err.code) {
        case 11000:
        case 11001:
          res.status(400).send([{
            msg: 'Username already taken',
            param: 'username'
          }]);
          break;
        default:
          var modelErrors = [];

          if (err.errors) {

            for (var x in err.errors) {
              modelErrors.push({
                param: x,
                msg: err.errors[x].message,
                value: err.errors[x].value
              });
            }

            res.status(400).send(modelErrors);
          }
      }

      return res.status(400);
    }
    req.logIn(user, function(err) {
      if (err) return next(err);
      return res.redirect('/');
    });
    res.status(200);
  });
};
/**
 * Send User
 */
exports.me = function(req, res) {
  res.json(req.user || null);
};

/**
 * Find user by id
 */
exports.user = function(req, res, next, id) {
  User
    .findOne({
      _id: id
    })
    .exec(function(err, user) {
      if (err) return next(err);
      if (!user) return next(new Error('Failed to load User ' + id));
      req.profile = user;

      //console.log('Logging user');
      //console.log(util.inspect(user));
        next();
      //if(!user.hasOwnProperty('following')) {
      //  user.following = [];
      //  user.followers = [];
      //  user.save(function(err) {
      //    if (err) return next(err);
      //    console.log('Just updated user');
      //    console.log(util.inspect(user));
      //    next();
      //  });
      //}
      //else {
      //  next();
      //}
    });
};

function getUser(id, cb) {

  User
    .findOne({
      _id: id
    })
    .exec(function(err, user) {
      if (err) return cb(err, null);

      //req.profile = user;
      //console.log('Logging user');
      //console.log(util.inspect(user));
      if(!user.hasOwnProperty('following')) {
        user.following = [];
        user.followers = [];
        user.save(function(err) {
          if (err) return cb(err, null);
          console.log('Just updated user');
          console.log(util.inspect(user));
          cb(null, user);
        });
      }
      else {
        cb(null, user);
      }
    });

}

exports.allUsers = function(req, res) {
  User
    .find()
    .exec(function(err, allUsers) {
      if (err) return res.json(500, {
        err: 'Cannot get the users'
      });

      if (!allUsers) return res.status(500).send('errors');

      res.json(allUsers);
    });
};

/**
 * Add Following
 */
exports.addUserToFollowing = function(req, res) {

  var userToFollowId = req.body.userId;
  var thisUser = req.user;
  var found = false;

  getUser(userToFollowId, function(err, userToFollow) {
    if (err) 
      return res.json(500, {
        err: 'Cannot get the user'
      });
    //console.log(util.inspect(typeof(req.user.following)));

    //console.log('looking in following list');
    thisUser.following.forEach(function(id){
      if (id === userToFollowId) {
        console.log('User' + thisUser._id + 'is already following ' + id);
        found = true;
      }
    });
    //console.log('finished looking in following list');
    if (!found) {
      thisUser.following.push(userToFollow._id);
      //console.log('User with new follower: \n\t' + util.inspect(thisUser));
      userToFollow.followers.push(thisUser._id);
      //console.log('Saving user 1');
      thisUser.save(function(err1) {
        //console.log('Saving user 2');
        userToFollow.save(function(err2) {
          if (err1 || err2) 
            res.json(500, {
              error: 'Cannot save the user'
            }).send();
          else
            res.status(200).send(thisUser);
        });
      });
    }
    else { res.status(200).send(); }
  });
};

exports.removeUserFromFollowing = function(req, res) {
  var userToFollowId = req.body.userId;
  var thisUser = req.user;
  var found = true;

  getUser(userToFollowId, function(err, userToFollow) {
    if (err)
      return res.json(500, {
        err: 'Cannot get the user'
      });
    //console.log(util.inspect(typeof(req.user.following)));

    //console.log('looking in following list');
   // req.user.following.forEach(function(id){
    //   if (id == userToFollowId) found = true;
    // });

    console.log('finished looking in following list');
    if (found) {
      //req.user.following.push(userToFollow._id);
      //userToFollow.followers.push(req.user._id);

      var followingIndex = thisUser.following.indexOf(userToFollow._id);
      var followersIndex = userToFollow.followers.indexOf(thisUser._id);

      if(followingIndex !== -1) thisUser.following = thisUser.following.slice(0, followingIndex).concat(thisUser.following.slice(followingIndex+1));
      if(followersIndex !== -1) userToFollow.following = userToFollow.following.slice(0, followersIndex).concat(userToFollow.following.slice(followersIndex+1));
      
      console.log('Saving user 1');
      thisUser.save(function(err1) {
        console.log('Saving user 2');
        userToFollow.save(function(err2) {
          if (err1 || err2) 
            res.json(500, {
              error: 'Cannot save the user'
            }).send();
          else
            res.status(200).send();
        });
      });
    }
    else { res.status(200).send(); }
  });
};

exports.getFollowing = function(req, res) {
  res.json(req.user.following);
};

exports.getFollowers = function(req, res) {
  res.json(req.user.followers);
};

exports.oneUser = function(req, res, next) {
  if (req.params.otherUserId) {
    User.findOne(
        {'_id': req.params.otherUserId},
        {'_id': 1, 'email': 1, 'name': 1, 'username': 1, 'followers': 1, 'following': 1}
    ).exec(function(err, user) {
          if (err)
            return res.status(400).json({
              msg: err
            });
          return res.status(200).json(user);
        });
  } else {
    next();
  }
};

/**
 * Resets the password
 */

exports.resetpassword = function(req, res, next) {
  User.findOne({
    resetPasswordToken: req.params.token,
    resetPasswordExpires: {
      $gt: Date.now()
    }
  }, function(err, user) {
    if (err) {
      return res.status(400).json({
        msg: err
      });
    }
    if (!user) {
      return res.status(400).json({
        msg: 'Token invalid or expired'
      });
    }
    req.assert('password', 'Password must be between 8-20 characters long').len(8, 20);
    req.assert('confirmPassword', 'Passwords do not match').equals(req.body.password);
    var errors = req.validationErrors();
    if (errors) {
      return res.status(400).send(errors);
    }
    user.password = req.body.password;
    user.resetPasswordToken = undefined;
    user.resetPasswordExpires = undefined;
    user.save(function(err) {
      req.logIn(user, function(err) {
        if (err) return next(err);
        return res.send({
          user: user
        });
      });
    });
  });
};

/**
 * Send reset password email
 */
function sendMail(mailOptions) {
  var transport = nodemailer.createTransport(config.mailer);
  transport.sendMail(mailOptions, function(err, response) {
    if (err) return err;
    return response;
  });
}

/**
 * Callback for forgot password link
 */
exports.forgotpassword = function(req, res, next) {
  async.waterfall([

      function(done) {
        crypto.randomBytes(20, function(err, buf) {
          var token = buf.toString('hex');
          done(err, token);
        });
      },
      function(token, done) {
        User.findOne({
          $or: [{
            email: req.body.text
          }, {
            username: req.body.text
          }]
        }, function(err, user) {
          if (err || !user) return done(true);
          done(err, user, token);
        });
      },
      function(user, token, done) {
        user.resetPasswordToken = token;
        user.resetPasswordExpires = Date.now() + 3600000; // 1 hour
        user.save(function(err) {
          done(err, token, user);
        });
      },
      function(token, user, done) {
        var mailOptions = {
          to: user.email,
          from: config.emailFrom
        };
        mailOptions = templates.forgot_password_email(user, req, token, mailOptions);
        sendMail(mailOptions);
        done(null, true);
      }
    ],
    function(err, status) {
      var response = {
        message: 'Mail successfully sent',
        status: 'success'
      };
      if (err) {
        response.message = 'User does not exist';
        response.status = 'danger';
      }
      res.json(response);
    }
  );
};
