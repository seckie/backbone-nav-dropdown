module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-browser-sync'

  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
    coffee:
      main:
        options:
          bare: true
        files:
          'dist/nav-dropdown.js': [
            # join
            'src/nav-dropdown.coffee'
          ]
    coffeelint:
      # DOC: https://github.com/vojtajina/grunt-coffeelint
      # DOC: http://www.coffeelint.org/
      main:
        files:
          src: [ 'src/*.coffee' ]
        options:
          'no_trailing_whitespace':
            'level': 'error'
    compass:
      options:
        httpPath: '/' # You have to reconfigure this option
        sassDir: 'src'
        cssDir: 'demo'
        imagesDir: 'demo/img'
        relativeAssets: true
      dev:
        options:
          environment: 'development'
          outputStyle: 'compact'
          noLineComments: true
          assetCacheBuster: false
    copy:
      main:
        files: [
          {
            expand: true
            cwd: 'bower_components/jquery/dist/'
            src: [ 'jquery.min.js' ]
            dest: 'demo'
          }
          {
            expand: true
            cwd: 'bower_components/underscore/'
            src: [ 'underscore.js' ]
            dest: 'demo'
          }
          {
            expand: true
            cwd: 'bower_components/backbone/'
            src: [ 'backbone.js' ]
            dest: 'demo'
          }
        ]
    jshint:
      main:
        options:
          jshintrc: true
        src: [ 'dist/*.js' ]
    browserSync:
      bsFile:
        src: 'demo/**/*'
      options:
        server:
          baseDir: './demo'
    watch:
      coffee:
        files: [ 'src/*.coffee' ]
        tasks: [ 'coffee' ]
      coffeelint:
        files: [ 'src/*.coffee' ]
        tasks: [ 'coffeelint' ]
      scss:
        files: [ 'src/*.scss' ]
        tasks: [ 'compass:dev' ]
      html:
        options:
          livereload: true
        files: [ 'demo/**/*.html' ]
      css:
        options:
          livereload: true
        files: [ 'demo/*.css' ]
      js:
        options:
          livereload: true
        files: [ 'dist/*' ]
        tasks: [ 'jshint' ]
  )

  grunt.registerTask('default', [ 'coffee', 'compass', 'watch' ])
  grunt.registerTask 'deploy', [ 'copy', 'coffee', 'compass' ]
