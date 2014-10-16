'use strict';

angular.module('mean.photos').config(['$stateProvider',
  function($stateProvider) {
    $stateProvider.state('photos example page', {
      url: '/photos/example',
      templateUrl: 'photos/views/index.html'
    });
  }
]);
