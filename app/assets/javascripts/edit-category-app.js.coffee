editCategoryApp = angular.module('editCategoryApp', ['ngResource'])

editCategoryApp.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]

editCategoryApp.factory('Category', ['$resource', ($resource) ->
  $resource('/manager/categories/:id')
])

editCategoryApp.controller('editCategoryCtrl', ['$scope', 'Category', ($scope, Category) ->
  $scope.category = Category.get({id: gon.category_id}, (category, _) ->
    $scope.arguments = category.features
  )
  $scope.argument = {}

  $scope.removeArgument = (argument) ->
    argumentIndex = $scope.arguments.indexOf(argument)
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
])
