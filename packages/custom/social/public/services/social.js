'use strict';

//Social service used for service REST endpoint
angular.module('mean.social').factory('Social', ['$resource',
  function($resource) {
    return $resource('social/:otherUserId', {
      otherUserId: '@_id'
    });
  }
]);