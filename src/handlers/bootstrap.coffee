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
      dlg = $ """
              <div class="modal fade YY-systemDialog--#{type}" tabindex="-1" data-keyboard="false">
                <div class="modal-dialog">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal"><span>&times;</span><span class="sr-only">#{_i18n "button.close"}</span></button>
                      <h4 class="modal-title">#{_i18n "title"}</h4>
                    </div>
                    <div class="modal-body"></div>
                    <div class="modal-footer"></div>
                  </div>
                </div>
              </div>
              """

      if type is "confirm"
        $(".modal-footer", dlg).append  """
                                        <button type="button" class="btn btn-default YY-button--cancel" data-dismiss="modal">#{_i18n "button.cancel"}</button>
                                        <button type="button" class="btn btn-primary YY-button--ok">#{_i18n "button.ok"}</button>
                                        """
      else if type is "confirmex"
        $(".modal-footer", dlg).append  """
                                        <button type="button" class="btn btn-default YY-button--cancel" data-dismiss="modal">#{_i18n "button.cancel"}</button>
                                        <button type="button" class="btn btn-primary YY-button--yes">#{_i18n "button.yes"}</button>
                                        <button type="button" class="btn btn-danger YY-button--no" data-dismiss="modal">#{_i18n "button.no"}</button>
                                        """
      else
        $(".modal-footer", dlg).append  """
                                        <button type="button" class="btn btn-primary YY-button--ok">#{_i18n "button.ok"}</button>
                                        """

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
  dlg = _dialogs[type]
  dlgContent = $(".modal-body", dlg)

  handler = ( cb, rv ) ->
    $(this).modal "hide"

    cb() if $.isFunction cb

    return rv

  dlgContent = dlg if dlgContent.size() is 0

  # 提示信息内容
  dlgContent.html message || ""

  if type is "confirm"
    $(".YY-button--ok")
      .off "click.YY_SystemDialog"
      .on "click.YY_SystemDialog", ->
        handler.apply dlg, [okHandler, true]
        return true

    $(".YY-button--cancel")
      .off "click.YY_SystemDialog"
      .on "click.YY_SystemDialog", ->
        handler.apply dlg, [cancelHandler, false]
        return true
  else if type is "confirmex"
    $(".YY-button--yes")
      .off "click.YY_SystemDialog"
      .on "click.YY_SystemDialog", ->
        handler.apply dlg, [okHandler, true]
        return true

    $(".YY-button--no")
      .off "click.YY_SystemDialog"
      .on "click.YY_SystemDialog", ->
        handler.apply dlg, [cancelHandler, false]
        return true

    $(".YY-button--cancel")
      .off "click.YY_SystemDialog"
      .on "click.YY_SystemDialog", ->
        handler.apply dlg, [null, false]
        return true
  else
    $(".YY-button--ok")
      .off "click.YY_SystemDialog"
      .on "click.YY_SystemDialog", ->
        handler.apply dlg, [okHandler ? null, true]
        return true

  dlg.modal "show"

  return dlg
