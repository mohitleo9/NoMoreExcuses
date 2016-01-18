module.exports = (grunt) ->

  require('load-grunt-tasks')(grunt)
  # Initialize the configuration.
  grunt.initConfig({

    watch:
      coffee_files:
        files: ['src/**/*.coffee']
        tasks: ['clean', 'coffee']

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
  grunt.registerTask "build", ['clean', "coffee"]
  grunt.registerTask "default", ['build', 'watch']
