wizardApp = angular.module('wizardApp', ['ngResource', 'ui.bootstrap'])

wizardApp.controller('wizardCtrl', ['$scope', ($scope) ->
  $scope.steps = [
    { title:'Step 1 : Categories', content:'Step 1'},
    { title:'Step 2 : Features and Benefits', content:'Step 2', disabled: true },
    { title:'Step 3 : Invitations', content:'Step 3', disabled: true },
    { title:'Step 4 : Summary', content:'Step 4', disabled: true },
  ]

  $scope.wizard = {}
  $scope.wizard.email = gon.email
  $scope.wizard.categories = []

  $scope.maxCategories = 20

  $scope.atCategoriesLimit = ->
    $scope.wizard.categories.length >= $scope.maxCategories
])

wizardApp.controller('categoryCtrl', ['$scope', ($scope) ->
  $scope.category = {}

  $scope.removeCategory = (category) ->
    index = $scope.wizard.categories.indexOf(category)
    $scope.wizard.categories.splice(index, 1)

  $scope.addCategory = (wizard) ->
    wizard.categories.push({name: $scope.category.name})
    $scope.category = {}
])
