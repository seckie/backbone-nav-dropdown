module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-rename'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jshint'

  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
    coffee:
      main:
        options:
          bare: true
        files:
          'dist/nav-dropdown.js': [
            # join
            'coffee/nav-dropdown.coffee'
          ]
    coffeelint:
      # DOC: https://github.com/vojtajina/grunt-coffeelint
      # DOC: http://www.coffeelint.org/
      main:
        files:
          src: [ 'coffee/*.coffee' ]
        options:
          'no_trailing_whitespace':
            'level': 'error'
    compass:
      options:
        httpPath: '/' # You have to reconfigure this option
        sassDir: 'scss'
        cssDir: 'app/css'
        imagesDir: 'app/img'
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
            dest: 'app/js/'
          }
          {
            expand: true
            cwd: 'bower_components/jquery-1.11.0/'
            src: [ 'index.js' ]
            dest: 'app/js/'
          }
          {
            expand: true
            cwd: 'bower_components/underscore/'
            src: [ 'underscore.js' ]
            dest: 'app/js/'
          }
          {
            expand: true
            cwd: 'bower_components/backbone/'
            src: [ 'backbone.js' ]
            dest: 'app/js/'
          }
        ]
    rename:
      main:
        files: [
          {
            src: [ 'app/js/index.js' ]
            dest: 'app/js/jquery-1.11.0.min.js'
          }
        ]
    jshint:
      main:
        options:
          jshintrc: true
        src: [ 'dist/*.js' ]
    watch:
      coffee:
        files: [ 'coffee/*.coffee' ]
        tasks: [ 'coffee' ]
      coffeelint:
        files: [ 'coffee/*.coffee' ]
        tasks: [ 'coffeelint' ]
      scss:
        files: [ 'scss/*.scss' ]
        tasks: [ 'compass:dev' ]
      html:
        options:
          livereload: true
        files: [ 'app/**/*.html' ]
      css:
        options:
          livereload: true
        files: [ 'app/css/*' ]
      js:
        options:
          livereload: true
        files: [ 'dist/*' ]
        tasks: [ 'jshint' ]
  )

  grunt.registerTask('default', [ 'coffee', 'compass', 'watch' ])
  grunt.registerTask 'deploy', [ 'copy', 'rename', 'coffee', 'compass' ]
