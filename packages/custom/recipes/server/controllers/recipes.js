'use strict';

/**
 * Module dependencies.
 */
//var mongoose = require('mongoose'),
    //Recipe = mongoose.model('Recipe'),
    //util = require('util'),
var http = require('http');
    //util = require('util');

var yummlyRecipeSearchURI = 'http://api.yummly.com/v1/api/recipes';
var yummlyRecipeURI = 'http://api.yummly.com/v1/api/recipe/';
var yummlyAppId = process.env.YUMMLY_APP_ID;
var yummlyAppKey = process.env.YUMMLY_APP_KEY;

// Find photo by id
//exports.recipe = function(req, res, next, id) {
//    Recipe.load(id, function (err, recipe) {
//        if (err) return next(err);
//        if (!recipe) return next(new Error('Failed to load photo ' + id));
//        req.recipe = recipe;
//        next();
//    });
//};

var getYummlyRecipesQueryString = function (queryStr) {
    return (
        yummlyRecipeSearchURI + '?' + '_app_id=' + yummlyAppId +
        '&_app_key=' + yummlyAppKey + '&q=' + queryStr
    );
};

var getYummlyRecipeString = function(recipeId) {
    return (
        yummlyRecipeURI + recipeId + '?_app_id=' + yummlyAppId +
        '&_app_key=' + yummlyAppKey
    );
};

var handleYummlyAPIResponse = function(res, yummlyInMessage) {
    var responseData = [];
    console.log('Got response: ' + yummlyInMessage.statusCode);
    yummlyInMessage.on('data', function(chunk) {
        console.log('got %d bytes of data', chunk.length);
        responseData.push(chunk);
    });
    yummlyInMessage.on('end', function() {
        res.json(responseData.join());
    });
    yummlyInMessage.on('error', function(err) {
        console.log('Got error: ' + err.message);
        return res.json(500, {
            error: 'Cannot query Yummly ' + err
        });
    });
};

exports.queryYummly = function(req, res, next) {
    var queryURI = '';
    if (req.body.query) {
        queryURI = getYummlyRecipesQueryString(req.body.query);
        console.log('Querying ' + queryURI);
        http.get(queryURI, function(yummlyRes) {
            handleYummlyAPIResponse(res, yummlyRes);
        }).on('error', function(err) {
            console.log('Got error: ' + err.message);
            return res.json(500, {
                error: 'Cannot query Yummly ' + err
            });
        });
    } else {
        next();
    }
};

exports.getYummlyRecipe = function(req, res, next) {
    console.log('Getting Yummly recipe');
    var queryURI = '';
    if (req.params.recipeId) {
        queryURI = getYummlyRecipeString(req.params.recipeId);
        console.log('Querying ' + queryURI);
        http.get(queryURI, function(yummlyRes) {
            handleYummlyAPIResponse(res, yummlyRes);
        }).on('error', function(err) {
            console.log('Got error: ' + err.message);
            return res.json(500, {
                error: 'Cannot query Yummly ' + err
            });
         });
    } else {
        console.log('Nada');
        next();
    }
};