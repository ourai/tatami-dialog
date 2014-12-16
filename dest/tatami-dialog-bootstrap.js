(function( global, factory ) {

  if ( typeof module === "object" && typeof module.exports === "object" ) {
    module.exports = global.document ?
      factory(global, true) :
      function( w ) {
        if ( !w.document ) {
          throw new Error("Requires a window with a document");
        }
        return factory(w);
      };
  } else {
    factory(global);
  }

}(typeof window !== "undefined" ? window : this, function( window, noGlobal ) {

var __proj, _dialogs, _i18n;

__proj = Tatami;

_dialogs = {};

_i18n = function(key) {
  return __proj.i18n("_SystemDialog." + key);
};
 
/*
 * 生成自定义系统对话框
 * 
 * @private
 * @method  systemDialog
 * @param   type {String}
 * @param   message {String}
 * @param   okHandler {Function}
 * @param   cancelHandler {Function}
 * @return  {Boolean}
 */
var systemDialog, systemDialogHandler;

systemDialog = function(type, message, okHandler, cancelHandler) {
  var dlg, result;
  result = false;
  if (__proj.isString(type)) {
    type = type.toLowerCase();
    dlg = _dialogs[type];
    if (!dlg) {
      dlg = $("<div class=\"modal fade YY-systemDialog--" + type + "\" tabindex=\"-1\" data-keyboard=\"false\">\n  <div class=\"modal-dialog\">\n    <div class=\"modal-content\">\n      <div class=\"modal-header\">\n        <button type=\"button\" class=\"close\" data-dismiss=\"modal\"><span>&times;</span><span class=\"sr-only\">" + (_i18n("button.close")) + "</span></button>\n        <h4 class=\"modal-title\">" + (_i18n("title")) + "</h4>\n      </div>\n      <div class=\"modal-body\"></div>\n      <div class=\"modal-footer\"></div>\n    </div>\n  </div>\n</div>");
      if (type === "confirm") {
        $(".modal-footer", dlg).append("<button type=\"button\" class=\"btn btn-default YY-button--cancel\" data-dismiss=\"modal\">" + (_i18n("button.cancel")) + "</button>\n<button type=\"button\" class=\"btn btn-primary YY-button--ok\">" + (_i18n("button.ok")) + "</button>");
      } else if (type === "confirmex") {
        $(".modal-footer", dlg).append("<button type=\"button\" class=\"btn btn-default YY-button--cancel\" data-dismiss=\"modal\">" + (_i18n("button.cancel")) + "</button>\n<button type=\"button\" class=\"btn btn-primary YY-button--yes\">" + (_i18n("button.yes")) + "</button>\n<button type=\"button\" class=\"btn btn-danger YY-button--no\" data-dismiss=\"modal\">" + (_i18n("button.no")) + "</button>");
      } else {
        $(".modal-footer", dlg).append("<button type=\"button\" class=\"btn btn-primary YY-button--ok\">" + (_i18n("button.ok")) + "</button>");
      }
    }
    result = systemDialogHandler(type, message, okHandler, cancelHandler);
  }
  return result;
};


/*
 * 系统对话框的提示信息以及按钮处理
 * 
 * @private
 * @method  systemDialogHandler
 * @param   type {String}             对话框类型
 * @param   message {String}          提示信息内容
 * @param   okHandler {Function}      确定按钮
 * @param   cancelHandler {Function}  取消按钮
 * @return
 */

systemDialogHandler = function(type, message, okHandler, cancelHandler) {
  var dlg, dlgContent, handler;
  dlg = _dialogs[type];
  dlgContent = $(".modal-body", dlg);
  handler = function(cb, rv) {
    $(this).modal("hide");
    if ($.isFunction(cb)) {
      cb();
    }
    return rv;
  };
  if (dlgContent.size() === 0) {
    dlgContent = dlg;
  }
  dlgContent.html(message || "");
  if (type === "confirm") {
    $(".YY-button--ok").off("click.YY_SystemDialog").on("click.YY_SystemDialog", function() {
      handler.apply(dlg, [okHandler, true]);
      return true;
    });
    $(".YY-button--cancel").off("click.YY_SystemDialog").on("click.YY_SystemDialog", function() {
      handler.apply(dlg, [cancelHandler, false]);
      return true;
    });
  } else if (type === "confirmex") {
    $(".YY-button--yes").off("click.YY_SystemDialog").on("click.YY_SystemDialog", function() {
      handler.apply(dlg, [okHandler, true]);
      return true;
    });
    $(".YY-button--no").off("click.YY_SystemDialog").on("click.YY_SystemDialog", function() {
      handler.apply(dlg, [cancelHandler, false]);
      return true;
    });
    $(".YY-button--cancel").off("click.YY_SystemDialog").on("click.YY_SystemDialog", function() {
      handler.apply(dlg, [null, false]);
      return true;
    });
  } else {
    $(".YY-button--ok").off("click.YY_SystemDialog").on("click.YY_SystemDialog", function() {
      handler.apply(dlg, [okHandler != null ? okHandler : null, true]);
      return true;
    });
  }
  dlg.modal("show");
  return dlg;
};
 __proj.extend({
  handlers: [
    {

      /*
       * 自定义警告提示框
       *
       * @method  alert
       * @param   message {String}
       * @param   [callback] {Function}
       * @return  {Boolean}
       */
      name: "alert",
      handler: function(message, callback) {
        return systemDialog("alert", message, callback);
      }
    }, {

      /*
       * 自定义确认提示框（两个按钮）
       *
       * @method  confirm
       * @param   message {String}
       * @param   [ok] {Function}       Callback for 'OK' button
       * @param   [cancel] {Function}   Callback for 'CANCEL' button
       * @return  {Boolean}
       */
      name: "confirm",
      handler: function(message, ok, cancel) {
        return systemDialog("confirm", message, ok, cancel);
      }
    }, {

      /*
       * 自定义确认提示框（两个按钮）
       *
       * @method  confirm
       * @param   message {String}
       * @param   [ok] {Function}       Callback for 'OK' button
       * @param   [cancel] {Function}   Callback for 'CANCEL' button
       * @return  {Boolean}
       */
      name: "confirmEX",
      handler: function(message, ok, cancel) {
        return systemDialog("confirmEX", message, ok, cancel);
      }
    }, {

      /*
       * 销毁系统对话框
       *
       * @method   destroySystemDialogs
       * @return   {Boolean}
       */
      name: "destroySystemDialogs",
      handler: function() {
        var _dialogs;
        if (this.isPlainObject(_dialogs)) {
          this.each(_dialogs, function(dlg) {
            if (typeof destroyDialog === "function") {
              destroyDialog(dlg);
            }
            return dlg.remove();
          });
          _dialogs = {};
        }
        return this.isEmpty(_dialogs);
      }
    }
  ]
});

}));
