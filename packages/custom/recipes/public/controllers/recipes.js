'use strict';

angular.module('mean.recipes').controller('RecipesController', ['$scope', 'Global', 'Recipes', '$http', ['ngSanitize'],
  function($scope, Global, Recipes, $http) {
    $scope.global = Global;
    $scope.package = {
      name: 'recipes'
    };
    $scope.recipes = null;
    $scope.yummlyHTML = null;

    $scope.submit = function() {
      console.log('Submitted');
      if ($scope.query) {
        console.log('Query is ' + $scope.query);
        $http.post('/recipes/search', {query: $scope.query})
            .success(function(data, status, headers, config) {
              if (data.attribution && data.attribution.html) {
                console.log('Got attribution html ' + data.attribution.html);
                $scope.yummlyHTML = data.attribution.html;
              }
              $scope.recipes = [];
              //var result = angular.fromJson(data);
              var result = data;
              console.log(result);
              if (result.matches) {
                result.matches.forEach(function(one) {
                  if (one.imageUrlsBySize && one.imageUrlsBySize[90]) {
                    console.log('Image ' + one.imageUrlsBySize[90]);
                  }
                  $scope.recipes.push(one);
                });
              }
            })
            .error(function(data, status, headers, config) {
              //
            });
      }
    };
  }
]);
