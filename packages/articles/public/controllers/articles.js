'use strict';

angular.module('mean.articles')
    .controller('ArticlesController', ['$scope', '$stateParams', '$location', '$http', 'Global', 'Articles',
    function($scope, $stateParams, $location, $http, Global, Articles) {
      $scope.global = Global;

      $scope.journals = null;
      $scope.oneJournal = null;

      $scope.hasAuthorization = function(article) {
        if (!article || !article.user) return false;
        return $scope.global.isAdmin || article.user._id === $scope.global.user._id;
      };


      $scope.find = function() {
        console.log('Getting all journal entries');
        $http.get('/journalEntries')
            .success(function(journals){
              console.log('Got ' + journals.length + ' total journals');
              journals.forEach(function(journal) {
                $http.get('/users/' + journal.user)
                    .success(function(user) {
                      console.log('Finished fetching user ' + user.username);
                      journal.user = user;
                    });
                //if (journal.photoList) {
                //  journal.photos = [];
                //  journal.photoList.forEach(function(photoId) {
                //    $http.get('/photos/' + photoId)
                //        .success(function(photo) {
                //          journal.photos.push(photo);
                //        });
                //  })
                //}
                //if (journal.recipeId) {
                //  $http.get('/recipes/' + journal.recipeId)
                //      .success(function(recipe) {
                //        journal.recipe = recipe;
                //      });
                //}
              });
              $scope.journals = journals;
            });
      };

      $scope.findOne = function() {
        console.log('Getting one journal entry ' + $stateParams.journalId);
        $http.get('/journalEntries/' + $stateParams.journalId)
            .success(function(journal){
              console.log('Got one journal entry ' + journal.title);
              if (journal.photoList) {
                journal.photos = [];
                journal.photoList.forEach(function(photoId) {
                  $http.get('/photos/' + photoId)
                      .success(function(photo) {
                        console.log('Finished fetching ' + photo._id);
                        journal.photos.push(photo);
                      });
                });
              }
              if (journal.recipeId) {
                $http.get('/recipes/' + journal.recipeId)
                    .success(function(recipe) {
                      console.log('Finished fetching ' + recipe.id);
                      journal.recipe = recipe;
                    });
              }
              $scope.oneJournal = journal;
            });
      };
    }
  ])

    .controller('LoginCtrl', ['$scope', '$http', '$location', 'Global', 'Articles', 'JournalEntries',
        function($scope, $http, $location, Global, Articles, JournalEntries) {
          $scope.global = Global;

        }
    ]);
