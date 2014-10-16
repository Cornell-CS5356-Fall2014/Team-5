'use strict';

angular.module('mean.photos').controller('PhotosController', ['$scope', 'Global', 'Photos',
  function($scope, Global, Photos) {
    $scope.global = Global;
    $scope.package = {
      name: 'photos'
    };
  }
]);
