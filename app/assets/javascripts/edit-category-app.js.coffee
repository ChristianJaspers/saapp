editCategoryApp = angular.module('editCategoryApp', ['ngResource', 'ng-rails-csrf'])

editCategoryApp.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
]

editCategoryApp.factory('Categories', ['$resource', ($resource) ->
  $resource('/manager/categories/:id', null,
    {
      'update': { method: 'PUT' }
    }
  )
])

editCategoryApp.controller('editCategoryCtrl', ['$scope', 'Categories', ($scope, Categories) ->
  $scope.productGroup = Categories.get({id: gon.productGroup_id}, (productGroup, _) ->
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
      description: $scope.argument.description,
      benefit_description: $scope.argument.benefit_description,
      is_editable: true,
      is_removable: true
    }

    $scope.arguments.push(argument)
    $scope.argument = {}

  $scope.submitCategory = ->
    productGroup = {
      productGroup:  {
        name: $scope.productGroup.name,
        arguments: $scope.arguments,
        arguments_to_remove_ids: $scope.argumentsToRemoveIds
      }
    }

    Categories.update({id: $scope.productGroup.id}, productGroup, ->
      document.location.href = $scope.productGroup.index_path
    )
])
