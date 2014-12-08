'use strict';

angular.module('mean.photos').controller('PhotosController', ['$scope', '$http', 'Global', 'Photos',
  function($scope, $http, Global, Photos) {
    $scope.global = Global;
    $scope.package = {
      name: 'photos'
    };

    // Get the photos for this user
    $http.get('/photos/').success(function(photoData) {
      $scope.photos = photoData;
      photoData.forEach(function(photo) {
        if (photo.thumbnail) {
          photo.preview = photo.thumbnail;
        } else {
          photo.preview = photo.original;
        }
      });
    });

    $scope.orderProp = 'created';
  }
]);
