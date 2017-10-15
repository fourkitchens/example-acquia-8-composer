(function () {
  'use strict';
  let gulp = require('gulp-help')(require('gulp'));
  let imagemin = require('gulp-imagemin');
  let config = require('gulp-config');
  /**
   * Task for minifying images.
   */
  gulp.task('imagemin', function () {
    return gulp.src(config.paths.img + '/**/*')
      .pipe(imagemin({
        progressive: true,
        svgoPlugins: [
            {removeViewBox: false},
            {cleanupIDs: false}
        ]
      }))
      .pipe(gulp.dest(config.paths.dist_img));
  });
