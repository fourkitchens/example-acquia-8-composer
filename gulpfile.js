(function () {
  'use strict';
  let gulp = require('gulp-help')(require('gulp'));
  let concat = require('gulp-concat');
  let config = require('./gulp-config');
  let glob = require('glob');
  let sass = require('gulp-sass');
  let sassGlob = require('gulp-sass-glob');
  let sassLint = require('gulp-sass-lint');
  let sourcemaps = require('gulp-sourcemaps');
  let eyeglass = require('eyeglass');
  let prefix = require('gulp-autoprefixer');
  let imagemin = require('gulp-imagemin');
  require('project-gulp')(gulp, ['phpcs', 'eslint']);

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

  /**
   * SASS Task
   */
  gulp.task('css', function () {
    return gulp.src([config.paths.sass + '/**/*.scss'])
      .pipe(sourcemaps.init())
      .pipe(sassGlob())
      .pipe(sassLint())
      .pipe(sassLint.format())
      .pipe(sassLint.failOnError())
      .pipe(sass(eyeglass(config.sassOptions)).on('error', sass.logError))
      .pipe(prefix(['last 1 version', '> 1%', 'ie 10']))
      .pipe(sourcemaps.write())
      .pipe(gulp.dest(config.paths.dist_css));
  });

  /**
   * Scripts Task
   */
  gulp.task('scripts', function () {
    return gulp.src(config.paths.js + '/**/*.js')
      .pipe(concat('scripts.js'))
      .pipe(gulp.dest(config.paths.dist_js));
  });

  gulp.task('styles', ['css']);

  /**
   * Theme task declaration
   */
  gulp.task('build', ['imagemin', 'styles', 'scripts']);
})();
