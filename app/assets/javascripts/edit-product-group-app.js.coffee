editProductGroupApp = angular.module('editProductGroupApp', ['ngResource', 'ng-rails-csrf'])

editProductGroupApp.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
]

editProductGroupApp.factory('ProductGroups', ['$resource', ($resource) ->
  $resource('/manager/product_groups/:id', null,
    {
      'update': { method: 'PUT' }
    }
  )
])

editProductGroupApp.controller('editProductGroupCtrl', ['$scope', 'ProductGroups', ($scope, ProductGroups) ->
  $scope.productGroup = ProductGroups.get({id: gon.product_group_id}, (productGroup, _) ->
    $scope.arguments = productGroup.arguments
  )
  $scope.argumentsToRemoveIds = []
  $scope.argument = {}

  $scope.removeArgument = (argument) ->
    argumentIndex = $scope.arguments.indexOf(argument)
    $scope.argumentsToRemoveIds.push($scope.arguments[argumentIndex].id)
    $scope.arguments.splice(argumentIndex, 1)

  $scope.addArgument = ->
    argument = {
      feature: $scope.argument.feature,
      benefit: $scope.argument.benefit,
      is_editable: true,
      is_removable: true
    }

    $scope.arguments.push(argument)
    $scope.argument = {}

  $scope.submitProductGroup = ->
    productGroup = {
      product_group:  {
        name: $scope.productGroup.name,
        arguments: $scope.arguments,
        arguments_to_remove_ids: $scope.argumentsToRemoveIds
      }
    }

    ProductGroups.update({id: $scope.productGroup.id}, productGroup, ->
      document.location.href = $scope.productGroup.index_path
    )
])
