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

  title: {
    type: String,
    required: true,
    trim: true
  },
  detailText: {
    type: String,
    required: true,
    trim: true
  },

  likerList: [{ type : Schema.Types.ObjectId, ref: 'User' }],
  commentList: [{ type : Schema.Types.ObjectId, ref: 'Comment' }],
  recipeId: {
    type: String,
    required: false,
    trim: true
  }
});

/**
 * Validations
 */

JournalEntrySchema.path('title').validate(function(title) {
  return !!title;
}, 'title cannot be blank');

JournalEntrySchema.path('detailText').validate(function(detailText) {
  return !!detailText;
}, 'detailText cannot be blank');

 JournalEntrySchema.statics.load = function(id, cb) {
   this.findOne({
     _id: id
   }).exec(cb);
 };

mongoose.model('JournalEntry', JournalEntrySchema);