module.exports = function(grunt) {
  var port = grunt.option('port') || 8000;

  grunt.initConfig({});

  grunt.loadNpmTasks('grunt-shell');
  grunt.config('shell', {
    build: {
      options: {
        stdout: true
      },
      command: 'bikeshed.py spec Overview.src.html'
    },
    update: {
      options: {
        stdout: true
      },
      command: 'bikeshed.py update'
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.config('watch', {
    options: {
      livereload: true,
    },
    files: [ 'Overview.src.html', 'biblio.json' ],
    tasks: 'default'
  });

  grunt.loadNpmTasks('grunt-express');
  grunt.config('express', {
    all: {
      options: {
        bases: [ '.' ],
        port: port,
        hostname: 'localhost',
        livereload: true
      }
    }
  });

  grunt.loadNpmTasks('grunt-open');
  grunt.config('open', {
    open: {
      all: {
        path: 'http://localhost:' + port + '/Overview.html'
      }
    },
  });

  grunt.registerTask('default', ['shell:build']);
  grunt.registerTask('build', ['shell:build']);
  grunt.registerTask('live-edit', [ 'shell:build',
                                    'express',
                                    'open',
                                    'watch']);
};
