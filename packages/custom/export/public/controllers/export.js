'use strict';

angular.module('mean.export').controller('ExportController', ['$scope', 'Global', 'Export',
  function($scope, Global, Export) {
    $scope.global = Global;
    $scope.package = {
      name: 'export'
    };
  }
]);
