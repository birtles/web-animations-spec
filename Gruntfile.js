module.exports = function(grunt) {
  var port = grunt.option('port') || 8000;

  grunt.initConfig({});

  grunt.loadNpmTasks('grunt-shell');
  grunt.config('shell', {
    build: {
      options: {
        stdout: true
      },
      command: 'bikeshed spec Overview.src.html'
    },
    update: {
      options: {
        stdout: true
      },
      command: 'bikeshed update'
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

  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.config('copy', {
    spec: {
      nonull: true, /* error if we haven't build the spec yet */
      src: [ 'Overview.html', '*.css', 'img/*', 'MathJax/*' ] ,
      dest: 'publish/',
    }
  });

  grunt.registerTask('default', ['shell:build']);
  grunt.registerTask('build', ['shell:build']);
  grunt.registerTask('publish', ['copy:spec']);
  grunt.registerTask('live-edit', [ 'shell:build',
                                    'express',
                                    'open',
                                    'watch']);
};
