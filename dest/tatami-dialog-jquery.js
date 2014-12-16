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
var destroyDialog, systemDialog, systemDialogHandler;

systemDialog = function(type, message, okHandler, cancelHandler) {
  var dlg, result;
  result = false;
  if (__proj.isString(type)) {
    type = type.toLowerCase();
    dlg = _dialogs[type];
    if (!dlg) {
      dlg = $("<div data-role=\"dialog\" data-type=\"system\" />").appendTo($("body")).on({
        dialogcreate: initializer("systemDialog"),
        dialogopen: function(e, ui) {
          return $(".ui-dialog-buttonset .ui-button", $(this).closest(".ui-dialog")).each(function() {
            var btn;
            btn = $(this);
            switch (__proj.trim(btn.text())) {
              case _i18n("title"):
                type = "ok";
                break;
              case _i18n("button.cancel"):
                type = "cancel";
                break;
              case _i18n("button.yes"):
                type = "yes";
                break;
              case _i18n("button.no"):
                type = "no";
            }
            return btn.addClass("ui-button-" + type);
          });
        }
      }).dialog({
        title: _i18n("title"),
        width: 400,
        minHeight: 100,
        closeText: _i18n("button.close"),
        modal: true,
        autoOpen: false,
        resizable: false,
        closeOnEscape: false
      });
      _dialogs[type] = dlg;
      dlg.closest(".ui-dialog").find(".ui-dialog-titlebar-close").remove();
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
  var btnText, btns, dlg, dlgContent, handler;
  handler = function(cb, rv) {
    $(this).dialog("close");
    if (__proj.isFunction(cb)) {
      cb();
    }
    return rv;
  };
  btns = [];
  btnText = {
    ok: _i18n("button.ok"),
    cancel: _i18n("button.cancel"),
    yes: _i18n("button.yes"),
    no: _i18n("button.no")
  };
  dlg = _dialogs[type];
  dlgContent = $("[data-role='dialog-content']", dlg);
  if (dlgContent.size() === 0) {
    dlgContent = dlg;
  }
  if (type === "confirm") {
    btns.push({
      text: btnText.ok,
      click: function() {
        handler.apply(this, [okHandler, true]);
        return true;
      }
    });
    btns.push({
      text: btnText.cancel,
      click: function() {
        handler.apply(this, [cancelHandler, false]);
        return true;
      }
    });
  } else if (type === "confirmex") {
    btns.push({
      text: btnText.yes,
      click: function() {
        handler.apply(this, [okHandler, true]);
        return true;
      }
    });
    btns.push({
      text: btnText.no,
      click: function() {
        handler.apply(this, [cancelHandler, false]);
        return true;
      }
    });
    btns.push({
      text: btnText.cancel,
      click: function() {
        handler.apply(this, [null, false]);
        return true;
      }
    });
  } else {
    type = "alert";
    if (okHandler !== null) {
      btns.push({
        text: btnText.ok,
        click: function() {
          handler.apply(this, [okHandler, true]);
          return true;
        }
      });
    } else {
      btns = null;
    }
  }
  dlgContent.html(message || "");
  dlg.dialog("option", "buttons", btns).dialog("open");
  return dlg;
};

destroyDialog = function(dlg) {
  return dlg.dialog("destroy");
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
