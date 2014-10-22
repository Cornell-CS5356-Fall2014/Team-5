'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

// Photo Schema
var PhotoSchema = new Schema({
  created: {
    type: Date,
    default: Date.now
  },
  contentType: String,
  fileName: String,
  caption: String,
  user: {
    type: Schema.ObjectId,
    ref: 'User'
  },
  image: {
    original: {
      type: Buffer,
      required: true
    },
    thumbnail: {
      type: Buffer
    }
  }
});

/**
 * Validations
 */

/**
 * Statics
 */

 PhotoSchema.statics.load = function(id, cb) {
   this.findOne({
     _id: id
   }).exec(cb);
 };

mongoose.model('Photo', PhotoSchema);