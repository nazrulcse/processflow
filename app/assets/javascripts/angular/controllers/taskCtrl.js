var processFlow = angular.module('processFlow', []);
processFlow.controller('taskCtrl', ['$scope', function ($scope) {
    $scope.tasks = {task: { title: 'This is simple task'}};
}]);