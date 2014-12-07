'use strict';

//Setting up route
angular.module('mean.users').config(['$stateProvider',
    function($stateProvider) {
        $stateProvider.state('users gallery', {
            url: '/users',
            templateUrl: 'users/views/list.html'
        });
    }
]);