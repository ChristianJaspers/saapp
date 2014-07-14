wizardApp = angular.module('wizardApp', ['ngResource', 'ui.bootstrap', 'templates'])

wizardApp.controller('wizardCtrl', ['$scope', ($scope) ->
  $scope.wizard = {
    email: gon.email,
    categories: [],
    arguments: []
  }

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

  $scope.secondStepValid = ->
    $scope.wizard.arguments.length isnt 0

  $scope.$watchCollection('wizard.categories', ->
    $scope.steps[1].disabled = not $scope.firstStepValid()
  )

  $scope.$watchCollection('wizard.arguments', ->
    $scope.steps[2].disabled = not $scope.secondStepValid()
  )
])

wizardApp.controller('categoryCtrl', ['$scope', ($scope) ->
  $scope.category = {}

  $scope.removeCategory = (category) ->
    index = $scope.wizard.categories.indexOf(category)
    $scope.wizard.arguments = _.reject($scope.wizard.arguments, (argument) ->
      argument.category is category
    )
    $scope.wizard.categories.splice(index, 1)

  $scope.addCategory = (wizard) ->
    wizard.categories.push({name: $scope.category.name, arguments: []})
    $scope.category = {}
])

wizardApp.controller('argumentCtrl', ['$scope', ($scope) ->
  $scope.argument = {}

  $scope.removeArgument = (argument) ->
    argumentIndex = $scope.wizard.arguments.indexOf(argument)

    category = argument.category
    categoryArgumentIndex = category.arguments.indexOf(argument)

    category.arguments.splice(categoryArgumentIndex, 1)
    $scope.wizard.arguments.splice(argumentIndex, 1)

  $scope.addArgument = (wizard) ->
    category = _.find(wizard.categories, (category) ->
      category is $scope.argument.category
    )

    feature = {feature: $scope.argument.feature, benefit: $scope.argument.benefit, category: category}

    category.arguments.push(feature)
    wizard.arguments.push(feature)

    $scope.argument = {}
])
