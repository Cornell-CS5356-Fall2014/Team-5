'use strict';

angular.module('mean.social').controller('SocialController', ['$scope', '$stateParams', '$location', 'Global', 'Social', 'MeanUser', '$http',
  function($scope, $stateParams, $location, Global, Social, MeanUser, $http) {
    $scope.global = Global;
    $scope.package = {
      name: 'social'
    };

    $scope.currentUser = $scope.global.user;
    console.log('Current user is ' + $scope.currentUser._id);

    $scope.users = null;
    $scope.otherUser = null;
    $scope.followers = null;
    $scope.following = null;

    $scope.findAll = function() {
      console.log('Trying to get all users');
      $http.get('/users')
          .success(function(userData) {
            console.log('Got ' + userData.length + ' total users');
            $scope.users = userData;
          });
    };

    $scope.findOtherUser = function() {
      console.log('Trying to find MeanUser ' + $stateParams.otherUserId);
      $http.get('/users/' + $stateParams.otherUserId)
          .success(function(otherUser){
            console.log(otherUser);
            $scope.otherUser = otherUser;

            $scope.followers = [];
            $scope.following = [];

            otherUser.followers.forEach(function(oneFollows){
              $http.get('/users/' + oneFollows)
                  .success(function(fullFollows) {
                    console.log('Got follower ' + fullFollows.username);
                    $scope.followers.push(fullFollows);
                  });
            });

            otherUser.following.forEach(function(oneFollowing){
              $http.get('/users/' + oneFollowing)
                  .success(function(fullFollowing) {
                    console.log('Got follower ' + fullFollowing.username);
                    $scope.following.push(fullFollowing);
                  });
            });
          });
    };
  }
]);
