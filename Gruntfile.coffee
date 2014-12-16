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
    ]

  grunt.initConfig
    repo: info
    pkg: pkg
    meta:
      src: "src"
      dest: "dest"
      temp: ".<%= pkg.name %>-cache"
    concat:
      js:
        options:
          process: ( src, filepath ) ->
            return src.replace /@(NAME|VERSION)/g, ( text, key ) ->
              return info[key.toLowerCase()]
        files:
          "dest/<%= pkg.name %>-jquery.js": [
              "build/intro.js"
              "<%= meta.temp %>/<%= pkg.name %>-jquery.js"
              "build/outro.js"
            ]
          "dest/<%= pkg.name %>-bootstrap.js": [
              "build/intro.js"
              "<%= meta.temp %>/<%= pkg.name %>-bootstrap.js"
              "build/outro.js"
            ]
    coffee:
      options:
        bare: true
        separator: "\x20"
      jquery:
        files:
          "<%= meta.temp %>/<%= pkg.name %>-jquery.js": [
              "src/variables.coffee"
              "src/handlers/jquery-ui.coffee"
              "src/dialog.coffee"
            ]
          "<%= meta.temp %>/<%= pkg.name %>-bootstrap.js": [
              "src/variables.coffee"
              "src/handlers/bootstrap.coffee"
              "src/dialog.coffee"
            ]
      locales:
        expand: true
        cwd: "src/locales"
        src: ["*.coffee"]
        dest: "dest/locales"
        ext: ".js"
    uglify:
      options:
        banner: "/*!\n" +
                " * <%= repo.name %> v<%= repo.version %>\n" +
                " * <%= pkg.homepage %>\n" +
                " *\n" +
                " * Copyright 2014, <%= grunt.template.today('yyyy') %> Ourairyu, http://ourai.ws/\n" +
                " *\n" +
                " * Date: <%= grunt.template.today('yyyy-mm-dd') %>\n" +
                " */\n"
        sourceMap: true
      build:
        files:
          "dest/<%= pkg.name %>-jquery.min.js": "dest/<%= pkg.name %>-jquery.js"
          "dest/<%= pkg.name %>-bootstrap.min.js": "dest/<%= pkg.name %>-bootstrap.js"
    clean:
      compiled:
        src: ["<%= meta.temp %>/**"]

  grunt.loadNpmTasks task for task in npmTasks

  grunt.registerTask "default", ["coffee", "concat:js", "uglify", "clean"]
