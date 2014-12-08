'use strict';

//angular.module('mean.recipes').factory('Recipes', [
//  function() {
//    return {
//      name: 'recipes'
//    };
//  }
//]);

angular.module('mean.recipes').factory('Recipes', ['$resource',
  function($resource) {
    return $resource('recipes/:recipeId');
  }
]);