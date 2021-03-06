__proj.extend
  handlers: [
    {
      ###
      # 自定义警告提示框
      #
      # @method  alert
      # @param   message {String}
      # @param   [callback] {Function}
      # @return  {Boolean}
      ###
      name: "alert"

      handler: ( message, callback ) ->
        return systemDialog "alert", message, callback
    },
    {
      ###
      # 自定义确认提示框（两个按钮）
      #
      # @method  confirm
      # @param   message {String}
      # @param   [ok] {Function}       Callback for 'OK' button
      # @param   [cancel] {Function}   Callback for 'CANCEL' button
      # @return  {Boolean}
      ###
      name: "confirm"

      handler: ( message, ok, cancel ) ->
        return systemDialog "confirm", message, ok, cancel
    },
    {
      ###
      # 自定义确认提示框（两个按钮）
      #
      # @method  confirm
      # @param   message {String}
      # @param   [ok] {Function}       Callback for 'OK' button
      # @param   [cancel] {Function}   Callback for 'CANCEL' button
      # @return  {Boolean}
      ###
      name: "confirmEX"

      handler: ( message, ok, cancel ) ->
        return systemDialog "confirmEX", message, ok, cancel
    },
    {
      ###
      # 销毁系统对话框
      #
      # @method   destroySystemDialogs
      # @return   {Boolean}
      ###
      name: "destroySystemDialogs"

      handler: ->
        if @isPlainObject _dialogs
          @each _dialogs, ( dlg ) ->
            destroyDialog?(dlg)
            dlg.remove()

          _dialogs = {}

        return @isEmpty _dialogs
    }
  ]
