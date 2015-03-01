/**
 * @ngdoc overview
 * @name delayed-change
 * @description
 *
 * Serves a similar functionality as @ngChange, but groups calls
 * together if they are done quickly after one another.
 *
 * Useful for avoiding intensive function calls done often
 * (e.g. fast typing) into one call.
 */
angular.module('delayed-change', []);
