'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

 var CommentSchema = new Schema({
  user: {
    type: Schema.ObjectId,
    ref: 'User'
  },
  createdDate: {
    type: Date,
    default: Date.now
  },
  text: String
});

/**
 * Validations
 */

 CommentSchema.statics.load = function(id, cb) {
   this.findOne({
     _id: id
   }).exec(cb);
 };

mongoose.model('Comment', CommentSchema );