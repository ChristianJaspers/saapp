wizardApp = angular.module('wizardApp', ['ngResource'])

wizardApp.controller('wizardCtrl', ['$scope', ($scope) ->
  $scope.wizard = {}
  $scope.wizard.email = gon.email

  $scope.categories = ['iPhone', 'iPad']
])
