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
      jsx:
        files: ['src/**/*.jsx']
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

    babel:
      options:
        sourceMap: true
        presets: ['react']
      popup:
        files: [{
          expand: true,
          cwd: './src/background_scripts/'
          src: ['**/*.jsx']
          dest: './dest/background_scripts/'
          ext: '.js'
        }]

    webpack:
      options:
        resolve:
          root: ['./dest']
          alias:
            common: "common"
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
      popup:
        entry: './dest/background_scripts/popupDom.js'
        output:
          path: './dest/background_scripts/'
          filename: 'popup_main.js'
  })

  # Default task.
  grunt.registerTask "build", ['clean', 'coffee', 'babel', 'webpack']
  grunt.registerTask "default", ['build', 'watch']
