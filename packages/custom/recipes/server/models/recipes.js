'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var RecipeSchema = new Schema({
    created: {
        type: Date,
        default: Date.now
    },
    yummly_id: String,
    recipeName: String,
    smallImageUrls: [String],
    images: [
        {
            imageUrlsBySize: {'90': String, '360': String},
            hostedSmallUrl: String,
            hostedMediumUrl: String,
            hostedLargeUrl: String
        }
    ],
    source: {
        sourceRecipeUrl: String,
        sourceSiteUrl: String,
        sourceDisplayName: String
    },
    attribution: {
        html: String,
        url: String,
        text: String,
        logo: String
    },
    'yield': String,
    totalTime: String,
    totalTimeInSeconds: Number,
    numberOfServings: Number,
    attributes: {
        course: [String]
    },
    ingredientLines: [String],
    flavors: {
        piquant: Number,
        meaty: Number,
        sour: Number,
        bitter: Number,
        salty: Number,
        sweet: Number
    },
    rating: Number
});

RecipeSchema.statics.load = function(id, cb) {
    this.findOne({
        _id: id
    }).exec(cb);
};

mongoose.model('Recipe', RecipeSchema);