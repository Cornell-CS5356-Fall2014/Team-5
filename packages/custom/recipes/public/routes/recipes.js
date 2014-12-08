'use strict';

angular.module('mean.recipes').config(['$stateProvider',
  function($stateProvider) {
    $stateProvider.state('Recipes', {
      url: '/recipes',
      templateUrl: 'recipes/views/index.html'
    }).state('Recipe detail', {
      url: '/recipes/:recipeId',
      templateUrl: 'recipes/views/recipe.html'
    });
  }
]);
