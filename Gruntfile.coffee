module.exports = (grunt) ->

  require('load-grunt-tasks')(grunt)
  # Initialize the configuration.
  grunt.initConfig({

    watch:
      coffee_files:
        files: ['src/**/*.coffee']
        tasks: ['build']
        options:
          livereload: true

    coffee:
      options:
        sourceMap: true
      compile:
        bare: true
        expand: true
        cwd: 'src',
        src: ['**/*.coffee'],
        dest: 'dest/',
        ext: '.js'

    clean:
      build: ['dest']

    webpack:
      content_scripts:
          entry: './dest/content_scripts/content.js'
          output:
            path: './dest/content_scripts/'
            filename: 'main.js'
      background_scripts:
        entry: './dest/background_scripts/background.js'
        output:
          path: './dest/background_scripts/'
          filename: 'main.js'
  })

  # Default task.
  grunt.registerTask "build", ['clean', 'coffee', 'webpack']
  grunt.registerTask "default", ['build', 'watch']
