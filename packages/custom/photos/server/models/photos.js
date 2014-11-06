'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

var PhotoSchema = new Schema({
  created: {
    type: Date,
    default: Date.now
  },
  fileName: String,
  caption: String,
  user: {
    type: Schema.ObjectId,
    ref: 'User'
  },
  original: {
    type: Schema.ObjectId,
    ref: 'PhotoImage'
  },
  thumbnail: {
    type: Schema.ObjectId,
    ref: 'PhotoImage' 
  }
});

/**
 * Validations
 */

 PhotoSchema.statics.load = function(id, cb) {
   this.findOne({
     _id: id
   }).exec(cb);
 };

mongoose.model('Photo', PhotoSchema);
