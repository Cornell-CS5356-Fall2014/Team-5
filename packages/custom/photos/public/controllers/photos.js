'use strict';

angular.module('mean.photos').controller('PhotosController', ['$scope', '$http', 'Global', 'Photos',
  function($scope, $http, Global, Photos) {
    $scope.global = Global;
    $scope.package = {
      name: 'photos'
    };

    // Get the photos for this user
    $http.get('/photos/').success(function(data) {
      $scope.photos = data;
    });

    $scope.orderProp = 'created';
  }
]);
