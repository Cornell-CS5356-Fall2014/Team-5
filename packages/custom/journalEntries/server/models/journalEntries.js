'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

 var JournalEntrySchema = new Schema({
  user: {
    type: Schema.ObjectId,
    ref: 'User'
  },
  createdDate: {
    type: Date,
    default: Date.now
  },
  modifiedDate: {
    type: Date,
    default: Date.now
  },
  photoList: [{ type : Schema.Types.ObjectId, ref: 'Photo' }],
  title: String,
  detailText: String,
  likerList: [{ type : Schema.Types.ObjectId, ref: 'User' }],
  commentList: [{ type : Schema.Types.ObjectId, ref: 'Comment' }],

});

/**
 * Validations
 */

 JournalEntrySchema.statics.load = function(id, cb) {
   this.findOne({
     _id: id
   }).exec(cb);
 };

mongoose.model('JournalEntry', JournalEntrySchema);