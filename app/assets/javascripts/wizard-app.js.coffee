wizardApp = angular.module('wizardApp', ['ngResource'])

wizardApp.controller('wizardCtrl', ['$scope', ($scope) ->
  $scope.wizard = {}
  $scope.wizard.email = gon.email
  $scope.wizard.categories = []
])

wizardApp.controller('categoryCtrl', ['$scope', ($scope) ->
  $scope.category = {}

  $scope.removeCategory = (category) ->
    index = $scope.wizard.categories.indexOf(category)
    $scope.wizard.categories.splice(index, 1)

  $scope.addCategory = (wizard) ->
    wizard.categories.push($scope.category.name)
    $scope.category = {}
])
