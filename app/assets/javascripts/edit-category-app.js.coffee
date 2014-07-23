editCategoryApp = angular.module('editCategoryApp', ['ngResource'])

editCategoryApp.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
]

editCategoryApp.factory('Categories', ['$resource', ($resource) ->
  $resource('/manager/categories/:id', null,
    {
      'update': { method:'PUT' }
    }
  )
])

editCategoryApp.controller('editCategoryCtrl', ['$scope', 'Categories', ($scope, Categories) ->
  $scope.category = Categories.get({id: gon.category_id}, (category, _) ->
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

  $scope.submitCategory = ->
    category = {category: {name: $scope.category.name, arguments: $scope.arguments}}

    Categories.update({id: $scope.category.id}, category, ->
      document.location.href  = $scope.category.index_path
    )
])
