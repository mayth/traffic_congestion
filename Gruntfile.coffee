module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
  grunt.registerTask 'default', 'test', () ->
    grunt.log.write 'kogasa-chan kawaii'