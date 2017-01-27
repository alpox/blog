"use strict"

let gulp = require('gulp');
let gulp_shell = require('gulp-shell');
let path = require('path');

let paths = {
    build: "../priv/static/",
    source: "./src/",
    stylesheet: "./Stylesheets.elm",
    assets: "./assets/"
}

Object.assign(paths, {
    sourcefiles: paths.source + "/**/*.elm",
    main: paths.source + "Main.elm",
    styles: paths.source + "**/Style.elm",
    output: {
        app: paths.build + "js/app.js",
        css: paths.build + "css/"
    }
});

let cmds = {
    clean: `rm -r -f ${paths.build}*`,
    elmMake: `elm-make ${paths.main} --output ${paths.output.app}`,
    elmCss: `elm-css ${paths.stylesheet} -o ${paths.output.css}`,
    makeBuildDir: `mkdir -p ${paths.build}`,
    makeJsDir: `mkdir -p ${paths.build}/js`,
    makeCssDir: `mkdir -p ${paths.build}/css`
}

let shell = commands => gulp_shell.task(commands, { verbose: true, ignoreErrors: true });

gulp.task("clean", shell([cmds.clean]));

gulp.task("build-src", shell([cmds.elmMake]));

gulp.task("build-css", shell([cmds.elmCss]));

gulp.task("build-all", gulp.parallel("build-src", "build-css"));

gulp.task("watch-src", () => gulp.watch(paths.source + "**/*", gulp.series(["build-src"])));

gulp.task("watch-css", () => gulp.watch(paths.styles, gulp.series(["build-css"])));

gulp.task("watch-assets", () => gulp.watch(paths.assets + "**/*", gulp.series(["move-assets"])));

gulp.task("move-assets", () => gulp.src(paths.assets + "**/*").pipe(gulp.dest(paths.build)));

gulp.task("make-dirs", shell([cmds.makeBuildDir, cmds.makeJsDir, cmds.makeCssDir]));

gulp.task("dev", gulp.parallel("watch-src", "watch-css", "watch-assets"));

gulp.task("default", gulp.series(["clean", "make-dirs", "build-all", "move-assets", "dev"]));