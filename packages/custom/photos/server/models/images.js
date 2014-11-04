'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

var ImageSchema = new Schema({
  created: {
    type: Date,
    default: Date.now
  },
  contentType: String,
  content: {
    type: Buffer,
    required: true
  }
});

/**
 * Statics
 */

  ImageSchema.statics.load = function(id, cb) {
   this.findOne({
     _id: id
   }).exec(cb);
 };

mongoose.model('PhotoImage', ImageSchema);
