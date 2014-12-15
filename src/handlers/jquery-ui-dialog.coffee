###
# 生成自定义系统对话框
# 
# @private
# @method  systemDialog
# @param   type {String}
# @param   message {String}
# @param   okHandler {Function}
# @param   cancelHandler {Function}
# @return  {Boolean}
###
systemDialog = ( type, message, okHandler, cancelHandler ) ->
  result = false

  if __proj.isString type
    type = type.toLowerCase()
    dlg = _dialogs[type]

    if not dlg
      dlg = $("<div data-role=\"dialog\" data-type=\"system\" />")
        .appendTo $("body")
        .on
          # 初始化后的额外处理
          dialogcreate: initializer "systemDialog"
          # 为按钮添加标记
          dialogopen: ( e, ui ) ->
            $(".ui-dialog-buttonset .ui-button", $(this).closest(".ui-dialog")).each ->
              btn = $(this)

              switch __proj.trim btn.text()
                when _i18n "title"
                  type = "ok"
                when _i18n "button.cancel"
                  type = "cancel"
                when _i18n "button.yes"
                  type = "yes"
                when _i18n "button.no"
                  type = "no"

              btn.addClass "ui-button-#{type}"
        .dialog
          title: _i18n "title"
          width: 400
          minHeight: 100
          closeText: _i18n "button.close"
          modal: true
          autoOpen: false
          resizable: false
          closeOnEscape: false

      _dialogs[type] = dlg

      # 移除关闭按钮
      dlg.closest(".ui-dialog").find(".ui-dialog-titlebar-close").remove()

    result = systemDialogHandler type, message, okHandler, cancelHandler

  return result

###
# 系统对话框的提示信息以及按钮处理
# 
# @private
# @method  systemDialogHandler
# @param   type {String}             对话框类型
# @param   message {String}          提示信息内容
# @param   okHandler {Function}      确定按钮
# @param   cancelHandler {Function}  取消按钮
# @return
###
systemDialogHandler = ( type, message, okHandler, cancelHandler ) ->
  handler = ( cb, rv ) ->
    $(this).dialog "close"

    cb() if __proj.isFunction cb

    return rv

  btns = []
  btnText =
    ok: _i18n "button.ok"
    cancel: _i18n "button.cancel".
    yes: _i18n "button.yes"
    no: _i18n "button.no"

  dlg = _dialogs[type]
  dlgContent = $("[data-role='dialog-content']", dlg)
  dlgContent = dlg if dlgContent.size() is 0

  # 设置按钮以及其处理函数
  if type is "confirm"
    btns.push
      text: btnText.ok
      click: -> 
        handler.apply this, [okHandler, true]
        return true
    btns.push
      text: btnText.cancel
      click: ->
        handler.apply this, [cancelHandler, false]
        return true
  else if type is "confirmex"
    btns.push
      text: btnText.yes
      click: ->
        handler.apply this, [okHandler, true]
        return true
    btns.push
      text: btnText.no
      click: ->
        handler.apply this, [cancelHandler, false]
        return true
    btns.push
      text: btnText.cancel
      click: ->
        handler.apply this, [null, false]
        return true
  else
    type = "alert"

    if okHandler isnt null
      btns.push
        text: btnText.ok,
        click: ->
          handler.apply this, [okHandler, true]
          return true
    else
      btns = null

  # 提示信息内容
  dlgContent.html message || ""

  # 添加按钮并打开对话框
  dlg
    .dialog "option", "buttons", btns
    .dialog "open"
