var gulp = require('gulp');
var jade = require('gulp-jade');
var sass = require('gulp-sass');
var coffee = require('gulp-coffee');
var minifyCSS = require('gulp-minify-css');
var imagemin = require('gulp-imagemin');
var pngquant = require('imagemin-pngquant');
// Bower
var mainBowerFiles = require('main-bower-files');
var files = mainBowerFiles(/* options */);
// Debug
var prettify = require('gulp-prettify');
var browserSync = require('browser-sync');
var reload      = browserSync.reload;

// ==============================================

gulp.task('default', ['jade', 'sass', 'coffee', 'browser-sync'], function () {
    
    gulp.watch("./src/*.jade", ['jade'])
    gulp.watch("./src/scss/*.scss", ['sass'])
    gulp.watch("./src/coffee/*.coffee", ['coffee'])
    gulp.watch("./src/images/*", ['imagemin'])
});

gulp.task('jade', function () {
  return gulp.src('./src/*.jade')
    .pipe(jade())
    .pipe(prettify({indent_size: 2}))
    .pipe(gulp.dest('./dist'))
    .pipe(reload({stream:true}))
});

gulp.task('sass', function () {
    return gulp.src('./src/scss/*.scss')
        .pipe(sass({sourceComments: 'normal'}))
        .pipe(minifyCSS({keepBreaks: true}))
        .pipe(gulp.dest('./dist/css'))
        .pipe(reload({stream:true}))
});

gulp.task('coffee', function () {
    gulp.src(mainBowerFiles())
        .pipe(gulp.dest('./dist/js'))

    return gulp.src('./src/coffee/*.coffee')
        .pipe(coffee({bare: true}))
        .pipe(gulp.dest('./dist/js'))
        .pipe(reload({stream:true}))
});

gulp.task('browser-sync', function () {
    browserSync({
        server: {
            baseDir: "./dist"
        }
    });
});


gulp.task('imagemin', function () {
    return gulp.src('./src/images/*')
        .pipe(imagemin({
            progressive: true,
            svgoPlugins: [{removeViewBox: false}],
            use: [pngquant()]
        }))
        .pipe(gulp.dest('./dist/images'));
});


gulp.task('favicons', function () {
    favicons({
        // I/O
        source: './logo.png',
        dest: './dist/images/icons',

        // Icon Types
        android: true,
        apple: true,
        coast: false,
        favicons: true,
        firefox: false,
        opengraph: false,
        windows: false,

        // Miscellaneous
        html: './dist/index.html',
        background: false,
        tileBlackWhite: true,
        manifest: null,
        trueColor: false,
        url: null,
        logging: false,
        callback: null
    });
})

gulp.task('favicon', function () {
    gulp.src('./src/favicon.ico')
        .pipe(gulp.dest('./dist'))
})




