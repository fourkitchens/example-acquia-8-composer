(function () {
  'use strict';
  let gulp = require('gulp-help')(require('gulp'));
  require('project-gulp')(gulp, ['phpcs', 'eslint']);
})();
