'use strict';

angular.module('mean.recipes').controller('RecipesController', ['$scope', 'Global', 'Recipes', '$http', '$sce', '$stateParams',
  function($scope, Global, Recipes, $http, $sce, $stateParams) {
    $scope.global = Global;
    $scope.package = {
      name: 'recipes'
    };
    $scope.recipes = null;
    $scope.yummlyHTML = null;
    $scope.selectedRecipe = null;
    $scope.selectedHTML = null;

    $scope.submit = function() {
      console.log('Submitted');
      if ($scope.query) {
        console.log('Query is ' + $scope.query);
        $http.post('/recipes/search', {query: $scope.query})
            .success(function(data, status, headers, config) {
              if (data.attribution && data.attribution.html) {
                console.log('Got attribution html ' + data.attribution.html);
                //$scope.yummlyHTML = data.attribution.html;
                $scope.yummlyHTML = $sce.trustAsHtml(data.attribution.html);
              }
              $scope.recipes = [];
              //var result = angular.fromJson(data);
              var result = data;
              console.log(result);
              if (result.matches) {
                result.matches.forEach(function(one) {
                  one.displayImage = getImage(one);
                  $scope.recipes.push(one);
                });
              }
            })
            .error(function(data, status, headers, config) {
              //
            });
      }
    };

    $scope.findOne = function() {
      console.log('Trying get Yummly recipeId ' + $stateParams.recipeId);
      $http.get('/recipes/' + $stateParams.recipeId)
          .success(function(oneRecipe) {
            console.log('Got recipe ' + oneRecipe.id);
            oneRecipe.displayImage = getImage(oneRecipe);
            if (oneRecipe.displayImage) console.log(oneRecipe.displayImage);
            $scope.selectedRecipe = oneRecipe;
            $scope.selectedHTML =  $sce.trustAsHtml(oneRecipe.attribution.html);
          });
    };

    var getImage = function(recipe) {
      var tmp;
      if (recipe.images) {
        tmp = recipe.images.pop();

        if (tmp.hostedLargeUrl) {
          return tmp.hostedLargeUrl;
        } else if (tmp.hostedMediumUrl) {
          return tmp.hostedMediumUrl;
        } else if (tmp.hostedSmallUrl) {
          return tmp.hostedSmallUrl;
        } else if (tmp.imageUrlsBySize && tmp.imageUrlsBySize[360]) {
          return tmp.imageUrlsBySize[360];
        } else if (tmp.imageUrlsBySize && tmp.imageUrlsBySize[90]) {
          return tmp.imageUrlsBySize[90];
        }

      } else if (recipe.imageUrlsBySize && recipe.imageUrlsBySize[90]) {
        return recipe.imageUrlsBySize[90];
      } else if (recipe.smallImageUrls) {
        return recipe.smallImageUrls.pop();
      }
      return null;
    };
  }
]);
