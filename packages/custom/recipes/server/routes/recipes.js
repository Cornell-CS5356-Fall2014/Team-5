'use strict';

var recipes = require('../controllers/recipes');

// The Package is past automatically as first parameter
module.exports = function(Recipes, app, auth, database) {

  app.route('/recipes/search')
      .post(auth.requiresLogin, recipes.queryYummly);

  app.route('/recipes/:recipeId')
      .get(auth.requiresLogin, recipes.getYummlyRecipe);

  // Finish with setting up the recipeId param
  app.param('recipeId', function (req, res, next, recipeId) {
    console.log('Setting recipeId to ' + recipeId);
    next();
  });
};
