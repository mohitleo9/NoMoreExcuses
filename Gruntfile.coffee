module.exports = (grunt) ->

  require('load-grunt-tasks')(grunt)
  # Initialize the configuration.
  grunt.initConfig({

    coffee:
      options:
        sourceMap: true
      compile:
        expand: true
        cwd: 'src',
        src: ['**/*.coffee'],
        dest: 'dest/',
        ext: '.js'

    clean:
      build: ['dest']

  })

  # Default task.
  grunt.registerTask "default", ['clean', "coffee"]
