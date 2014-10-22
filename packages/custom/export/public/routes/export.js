'use strict';

angular.module('mean.export').config(['$stateProvider',
  function($stateProvider) {
    $stateProvider.state('export example page', {
      url: '/export/example',
      templateUrl: 'export/views/index.html'
    });
  }
]);
