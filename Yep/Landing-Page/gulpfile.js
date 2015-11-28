var gulp = require('gulp');
var plumber = require('gulp-plumber');
var rename = require('gulp-rename');
var autoprefixer = require('gulp-autoprefixer');
var jade = require('gulp-jade');
var coffee = require('gulp-coffee');
var sourcemaps = require('gulp-sourcemaps');
var coffeelint = require('gulp-coffeelint');
var jshint = require('gulp-jshint');
var uglify = require('gulp-uglify');
var sass = require('gulp-sass');
var browserSync = require('browser-sync');

gulp.task('browser-sync', function() {
  browserSync({
    open: false,
    browser: "google chrome",
    ghostMode: false,
    server: {
      baseDir: "./",
      routes: {
        "/kevinzhow": "profile"
      }
    }
  });
});

gulp.task('bs-reload', function() {
  browserSync.reload();
});

gulp.task('jade', function() {
  gulp.src(['src/jade/**/*.jade'])
    .pipe(plumber({
      errorHandler: function(error) {
        console.log(error.message);
        this.emit('end');
      }
    }))
    .pipe(jade())
    .pipe(gulp.dest('./'))
    .pipe(browserSync.reload({
      stream: true
    }))
  gulp.src(['Profile/src/jade/**/*.jade'])
    .pipe(plumber({
      errorHandler: function(error) {
        console.log(error.message);
        this.emit('end');
      }
    }))
    .pipe(jade())
    .pipe(gulp.dest('Profile/'))
    .pipe(browserSync.reload({
      stream: true
    }))
  gulp.src(['groups/share/src/jade/**/*.jade'])
    .pipe(plumber({
      errorHandler: function(error) {
        console.log(error.message);
        this.emit('end');
      }
    }))
    .pipe(jade())
    .pipe(gulp.dest('groups/share/'))
    .pipe(browserSync.reload({
      stream: true
    }))
});
gulp.task('sass', function() {
  gulp.src(['src/sass/**/*.sass'])
    .pipe(plumber({
      errorHandler: function(error) {
        console.log(error.message);
        this.emit('end');
      }
    }))
    .pipe(sass({
      sourceComments: 'normal',
      outputStyle: 'compressed'
    }))
    .pipe(autoprefixer('last 5 versions'))
    .pipe(gulp.dest('css/'))
    .pipe(browserSync.reload({
      stream: true
    }))
});

gulp.task('coffee', function() {
  console.log("\n================================================================================\n")
  return gulp.src('src/coffee/**/*.coffee')
    .pipe(plumber({
      errorHandler: function(error) {
        console.log(error.message);
        this.emit('end');
      }
    }))
    .pipe(coffeelint({opt: {max_line_length: {value: 1024, level: 'ignore'}}}))
    .pipe(coffeelint.reporter())
    .pipe(sourcemaps.init())
    .pipe(coffee({bare: true }))
    .pipe(uglify())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('js/'))
    .pipe(browserSync.reload({
      stream: true
    }))
});

gulp.task('default', ['browser-sync','jade','sass','coffee'], function() {
  gulp.watch("**/*.jade", ['jade']);
  gulp.watch("src/sass/**/*.sass", ['sass']);
  gulp.watch("src/coffee/**/*.coffee", ['coffee']);
  gulp.watch("*.html", ['bs-reload']);
});
