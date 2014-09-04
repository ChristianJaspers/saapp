wizardApp = angular.module('wizardApp', ['ngResource', 'pascalprecht.translate', 'ngCookies', 'ui.bootstrap', 'templates', 'ng-rails-csrf'])

wizardApp.factory('Wizard', ['$resource', ($resource) ->
  $resource('/wizards')
])

wizardApp.directive('productGroupsPreview', ->
  {
  restrict: 'E'
  templateUrl: 'product-groups-preview.html',
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

wizardApp.directive('invitationsPreview', ->
  {
  restrict: 'E'
  templateUrl: 'invitations-preview.html',
  replace: true
  }
)

wizardApp.controller('wizardCtrl', ['$scope', '$animate', '$timeout', 'Wizard', ($scope, $animate, $timeout, Wizard) ->
  $scope.wizard = {
    email: gon.email,
    productGroups: [],
    arguments: [],
    invitations: [],
    invitationMessage: ''
  }

  $scope.maxProductGroups = 20

  $scope.invitationMessageVisible = false

  $scope.steps = [
    { title: 'wizard.steps.product_groups', template: 'step-one.html', class: 'ng-isolate-scope product_groups_step' },
    { title: 'wizard.steps.arguments', template: 'step-two.html', disabled: true, class: 'ng-isolate-scope arguments_step' },
    { title: 'wizard.steps.invitations', template: 'step-three.html', disabled: true, class: 'ng-isolate-scope invitations_step' },
    { title: 'wizard.steps.summary', template: 'step-four.html', disabled: true, class: 'ng-isolate-scope summary_step' },
  ]

  $scope.autoFocus = ->
    $timeout ->
      autofocus_visible_inputs()
    , 100
    return true

  $scope.initTab = (classes) ->
    tabCode = classes.split(' ')[1]

    switch tabCode
      when 'product_groups_step'
        $scope.autoFocus()
      when 'arguments_step'
        $scope.argument = {productGroup: $scope.wizard.productGroups[0]}
        $scope.autoFocus()
      when 'invitations_step'
        $scope.autoFocus()
    return true

  $scope.atProductGroupsLimit = ->
    $scope.wizard.productGroups.length >= $scope.maxProductGroups

  $scope.firstStepValid = ->
    $scope.wizard.productGroups.length isnt 0

  $scope.secondStepValid = ->
    $scope.wizard.arguments.length isnt 0

  $scope.thirdStepValid = ->
    $scope.wizard.invitations.length isnt 0

  $scope.$watchCollection('wizard.productGroups', ->
    $scope.steps[1].disabled = not $scope.firstStepValid()
  )

  $scope.$watchCollection('wizard.arguments', ->
    $scope.steps[2].disabled = not $scope.secondStepValid()
    $scope.steps[3].disabled = not $scope.secondStepValid() or not $scope.thirdStepValid()
    $scope.autoFocus()
  )

  $scope.$watchCollection('wizard.invitations', ->
    $scope.steps[3].disabled = not $scope.thirdStepValid()
  )

  $scope.submitWizard = ->
    Ladda.create( document.querySelector('.ladda-button') ).start()

    wizard = new Wizard({
      email: $scope.wizard.email,
      invitations: $scope.wizard.invitations,
      invitationMessage: $scope.wizard.invitationMessage
    })

    wizard.productGroups = _.map($scope.wizard.productGroups, (productGroup) ->
      {name: productGroup.name, arguments: _.map(productGroup.arguments, (argument) ->
        {feature: argument.feature, benefit: argument.benefit}
      )}
    )

    wizard.$save().then((u, putResponseHeaders) ->
      if u.success
        document.location.href = '/confirmation?confirmation_token=' + u.confirmation_token
      else
        $('.alert.alert-danger').remove()
        flashContainer = $('<div class="alert alert-danger" alert-dismissable></div>')
        closeButton = $('<button aria-hidden="true" class="close" data-dismiss="alert" type="button">×</button>')
        flashContainer.text(u.error)
        flashContainer.prepend(closeButton)
        $('body > .container').prepend(flashContainer)
        Ladda.stopAll()
    )
])

wizardApp.controller('productGroupCtrl', ['$scope', ($scope) ->
  $scope.removeProductGroup = (productGroup) ->
    index = $scope.wizard.productGroups.indexOf(productGroup)
    $scope.wizard.arguments = _.reject($scope.wizard.arguments, (argument) ->
      argument.productGroup is productGroup
    )
    $scope.wizard.productGroups.splice(index, 1)

  $scope.addProductGroup = (wizard) ->
    wizard.productGroups.push({name: $scope.productGroup.name, arguments: []})
    $scope.productGroup = {}
])

wizardApp.controller('argumentCtrl', ['$scope', ($scope) ->
  $scope.removeArgument = (argument) ->
    argumentIndex = $scope.wizard.arguments.indexOf(argument)

    productGroup = argument.productGroup
    productGroupArgumentIndex = productGroup.arguments.indexOf(argument)

    productGroup.arguments.splice(productGroupArgumentIndex, 1)
    $scope.wizard.arguments.splice(argumentIndex, 1)

  $scope.addArgument = (wizard) ->
    productGroup = _.find(wizard.productGroups, (productGroup) ->
      productGroup is $scope.argument.productGroup
    )

    feature = {feature: $scope.argument.feature, benefit: $scope.argument.benefit, productGroup: productGroup}

    productGroup.arguments.push(feature)
    wizard.arguments.push(feature)

    productGroup.active = true
    $scope.argument = {productGroup: $scope.wizard.productGroups[0]}
])

wizardApp.controller('invitationCtrl', ['$scope', ($scope) ->
  $scope.invitation = {}

  $scope.removeInvitation = (invitation) ->
    index = $scope.wizard.invitations.indexOf(invitation)
    $scope.wizard.invitations.splice(index, 1)

  $scope.addInvitation = (wizard) ->
    wizard.invitations.push({email: $scope.invitation.email, displayName: $scope.invitation.displayName})
    $scope.invitation = {}
    $scope.autoFocus();
])

window.wizardApp = wizardApp
