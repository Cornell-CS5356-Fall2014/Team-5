'use strict';

angular.module('mean.photos').config(['$stateProvider',
  function($stateProvider) {
    $stateProvider.state('photos gallery page', {
      url: '/photos/gallery',
      templateUrl: 'photos/views/index.html'
    });
  }
]);
