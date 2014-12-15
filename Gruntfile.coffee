module.exports = ( grunt ) ->
  pkg = grunt.file.readJSON "package.json"
  info =
    name: pkg.name.charAt(0).toUpperCase() + pkg.name.substring(1)
    version: pkg.version
  npmTasks = [
      "grunt-contrib-concat"
      "grunt-contrib-coffee"
      "grunt-contrib-uglify"
      "grunt-contrib-copy"
      "grunt-contrib-clean"
      "grunt-contrib-jasmine"
    ]

  grunt.initConfig
    repo: info
    pkg: pkg
    meta:
      src: "src"
      coffee: "<%= meta.src %>/coffee"
      proc: "<%= meta.coffee %>/preprocessor"
      util: "<%= meta.coffee %>/utils"
      proj: "<%= meta.coffee %>/project"
      classes: "<%= meta.coffee %>/classes"
      dest: "dest"
      dest_style: "<%= meta.dest %>/stylesheets"
      dest_script: "<%= meta.dest %>"
      dest_image: "<%= meta.dest %>/images"
      vendors: "vendors"
      ronin: "<%= meta.vendors %>/ronin/dest"
      matcha: "<%= meta.vendors %>/matcha/dest"
      jquery: "<%= meta.vendors %>/jquery"
      tests: "test"
    concat:
      coffee:
        src: [
            "<%= meta.coffee %>/intro.coffee"
            "<%= meta.coffee %>/miso.coffee"
            "<%= meta.coffee %>/ronin.coffee"
            "<%= meta.coffee %>/constructors.coffee"
            "<%= meta.coffee %>/tatami.coffee"
            "<%= meta.coffee %>/outro.coffee"
          ]
        dest: "<%= meta.dest_script %>/<%= pkg.name %>.coffee"
      js:
        options:
          process: ( src, filepath ) ->
            return src.replace /@(NAME|VERSION)/g, ( text, key ) ->
              return info[key.toLowerCase()]
        src: [
            # "<%= meta.ronin %>/ronin.js"
            # "<%= meta.matcha %>/javascripts/matcha.js"
            "<%= meta.src %>/intro.js"
            "<%= meta.src %>/<%= pkg.name %>.js"
            "<%= meta.src %>/outro.js"
          ],
        dest: "<%= meta.dest_script %>/<%= pkg.name %>.js"
      css:
        files:
          "<%= meta.dest_style %>/<%= pkg.name %>.css": "<%= meta.matcha %>/stylesheets/matcha.css"
          "<%= meta.dest_style %>/<%= pkg.name %>.min.css": "<%= meta.matcha %>/stylesheets/matcha.min.css"
      vendors:
        files:
          "<%= meta.tests %>/ronin.js": "<%= meta.ronin %>/ronin.js"
          "<%= meta.tests %>/jquery.js": "<%= meta.jquery %>/jquery.js"
    coffee:
      options:
        bare: true
        separator: "\x20"
      build:
        src: "<%= meta.dest_script %>/<%= pkg.name %>.coffee"
        dest: "<%= meta.src %>/<%= pkg.name %>.js"
    uglify:
      options:
        banner: "/*!\n" +
                " * <%= repo.name %> v<%= repo.version %>\n" +
                " * <%= pkg.homepage %>\n" +
                " *\n" +
                " * Copyright 2013, <%= grunt.template.today('yyyy') %> Ourairyu, http://ourai.ws/\n" +
                " *\n" +
                " * Date: <%= grunt.template.today('yyyy-mm-dd') %>\n" +
                " */\n"
        sourceMap: true
      build:
        src: "<%= meta.dest_script %>/<%= pkg.name %>.js"
        dest: "<%= meta.dest_script %>/<%= pkg.name %>.min.js"
    copy:
      build:
        expand: true
        cwd: "<%= meta.dest %>"
        src: ["**.js", "**.css", "**/*.scss"]
        dest: "dest"
      test:
        expand: true
        cwd: "<%= meta.dest_script %>"
        src: ["**.js"]
        dest: "<%= meta.tests %>"
      matcha:
        expand: true
        cwd: "<%= meta.matcha %>"
        src: ["**/*.scss", "**/*.gif", "**/*.jpg", "**/*.png"]
        dest: "<%= meta.dest %>"
    clean:
      compiled:
        src: ["<%= meta.dest_script %>/*.coffee"]
    jasmine:
      test:
        src: "<%= meta.tests %>/<%= pkg.name %>.js"
        options:
          specs: "<%= meta.tests %>/*Spec.js"
          vendor: [
              "<%= meta.tests %>/ronin.js"
              "<%= meta.tests %>/jquery.js"
            ]

  grunt.loadNpmTasks task for task in npmTasks

  grunt.registerTask "concat_coffee", ["concat:coffee_miso", "concat:coffee_ronin", "concat:coffee_tatami", "concat:coffee_constructors", "concat:coffee"]
  grunt.registerTask "script", ["concat_coffee", "coffee", "concat:js", "uglify"]
  grunt.registerTask "default", ["script", "clean", "copy:test"]
