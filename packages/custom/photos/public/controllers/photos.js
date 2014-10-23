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
      data.forEach(function(photo) {
        if (photo.image && photo.image.thumbnail) {
          photo.url = photo.image.thumbnail.url;
        } else {
          photo.url = photo.image.original.url;
        }
        //console.log('Photo image URL is ' + photo.url);
      });
    });

    $scope.orderProp = 'created';
  }
]);
