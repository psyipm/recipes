module.exports = function (grunt) {
  grunt.initConfig({
    jshint: {
      all: {
        src: ['Gruntfile.js', 'karma.conf.js', 'test/**/*.js', 'src/**/*.js'],
        options: {
          jshintrc: true
        }
      }
    },
    concat: {
      debug: {
        src: [
          'src/scripts/*.js',
          'src/scripts/*/*.js'
        ],
        dest: 'dist/delayed-change.js'
      }
    },
    uglify: {
      main: {
        files: {
          'dist/delayed-change.min.js': ['dist/delayed-change.js']
        }
      }
    }
  });

  //Load plugins
  require('matchdep')
    .filterDev('grunt-*')
    .forEach(grunt.loadNpmTasks);

  grunt.registerTask('dist', [
    'concat',
    'uglify'
  ]);
};
