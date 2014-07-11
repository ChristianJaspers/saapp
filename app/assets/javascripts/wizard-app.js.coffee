wizardApp = angular.module('wizardApp', ['ngResource', 'ui.bootstrap', 'templates'])

wizardApp.controller('wizardCtrl', ['$scope', ($scope) ->
  $scope.wizard = {}
  $scope.wizard.email = gon.email
  $scope.wizard.categories = []
  $scope.maxCategories = 20

  $scope.steps = [
    { title: 'Step 1 : Categories', template: 'step-one.html' },
    { title: 'Step 2 : Features and Benefits', template: 'step-two.html', disabled: true },
    { title: 'Step 3 : Invitations', template: 'step-three.html', disabled: true },
    { title: 'Step 4 : Summary', template: 'step-four.html', disabled: true },
  ]

  $scope.atCategoriesLimit = ->
    $scope.wizard.categories.length >= $scope.maxCategories

  $scope.firstStepValid = ->
    $scope.wizard.categories.length isnt 0

  $scope.$watchCollection('wizard.categories', ->
    $scope.steps[1].disabled = not $scope.firstStepValid()
  )
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
