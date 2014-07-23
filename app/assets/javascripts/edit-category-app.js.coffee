editCategoryApp = angular.module('editCategoryApp', ['ngResource'])

editCategoryApp.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]

editCategoryApp.factory('Category', ['$resource', ($resource) ->
  $resource('/manager/categories/:id')
])


editCategoryApp.controller('editCategoryCtrl', ['$scope', 'Category', ($scope, Category) ->
  $scope.category = Category.get({id: gon.category_id})
])
