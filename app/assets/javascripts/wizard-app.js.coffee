wizardApp = angular.module('wizardApp', ['ngResource', 'ui.bootstrap', 'templates'])

wizardApp.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]

wizardApp.factory('Wizard', ['$resource', ($resource) ->
  $resource('/wizards')
])

wizardApp.directive('categoriesPreview', ->
  {
  restrict: 'E'
  templateUrl: 'categories-preview.html',
  replace: true
  }
)

wizardApp.directive('argumentsPreview', ->
  {
  restrict: 'E'
  templateUrl: 'arguments-preview.html',
  replace: true
  }
)

wizardApp.controller('wizardCtrl', ['$scope', '$animate', 'Wizard', ($scope, $animate, Wizard) ->
  $scope.wizard = {
    email: gon.email,
    categories: [],
    arguments: [],
    invitations: []
  }

  $scope.maxCategories = 20

  $scope.steps = [
    { title: 'Product categories', template: 'step-one.html', class: 'ng-isolate-scope categories_step' },
    { title: 'Arguments', template: 'step-two.html', disabled: true, class: ' ng-isolate-scope arguments_step' },
    { title: 'Invitations', template: 'step-three.html', disabled: true, class: 'ng-isolate-scope invitations_step' },
    { title: 'Summary', template: 'step-four.html', disabled: true, class: 'ng-isolate-scope summary_step' },
  ]

  $scope.atCategoriesLimit = ->
    $scope.wizard.categories.length >= $scope.maxCategories

  $scope.firstStepValid = ->
    $scope.wizard.categories.length isnt 0

  $scope.secondStepValid = ->
    $scope.wizard.arguments.length isnt 0

  $scope.thirdStepValid = ->
    $scope.wizard.invitations.length isnt 0

  $scope.$watchCollection('wizard.categories', ->
    $scope.steps[1].disabled = not $scope.firstStepValid()
  )

  $scope.$watchCollection('wizard.arguments', ->
    $scope.steps[2].disabled = not $scope.secondStepValid()
    $scope.steps[3].disabled = not $scope.secondStepValid() or not $scope.thirdStepValid()
  )

  $scope.$watchCollection('wizard.invitations', ->
    $scope.steps[3].disabled = not $scope.thirdStepValid()
  )

  $scope.submitWizard = ->
    wizard = new Wizard({email: $scope.wizard.email, invitations: $scope.wizard.invitations})

    wizard.categories = _.map($scope.wizard.categories, (category) ->
      {name: category.name, arguments: _.map(category.arguments, (argument) ->
        {feature: argument.feature, benefit: argument.benefit}
      )}
    )

    wizard.$save().then((u, putResponseHeaders) ->
      document.location.href  = '/'
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

    category.active = true
    $scope.argument = {}
])

wizardApp.controller('invitationCtrl', ['$scope', ($scope) ->
  $scope.invitation = {}

  $scope.removeInvitation = (invitation) ->
    index = $scope.wizard.invitations.indexOf(invitation)
    $scope.wizard.invitations.splice(index, 1)

  $scope.addInvitation = (wizard) ->
    wizard.invitations.push({email: $scope.invitation.email, displayName: $scope.invitation.displayName})
    $scope.invitation = {}
])
