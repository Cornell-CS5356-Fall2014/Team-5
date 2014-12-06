'use strict';

angular.module('mean.recipes').controller('RecipesController', ['$scope', 'Global', 'Recipes',
  function($scope, Global, Recipes) {
    $scope.global = Global;
    $scope.package = {
      name: 'recipes'
    };
  }
]);
