$(document).ready(function () {
    CSMF2055.Layout();
    CSMF2055.CustomEvent();
});

/**  
* Object CSMF2055
*
* [Kim Vu] Create New [30/01/2018]
**/
var CSMF2055 = new function () {

    /**  
    * Layout control
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.Layout = function () {
        $("#Status").data('kendoComboBox').select(0);
        $(".Status").addClass('asf-disabled-li');
    }

    /**  
    * Custom Event control
    *
    * [Kim Vu] Create New [01/02/2018]
    **/
    this.CustomEvent = function () {        
        $("#Save").unbind('click');
        $("#Save").bind('click', CSMF2055.Save);
        $("#Close").unbind('click');
        $("#Close").bind('click', CSMF2055.Close);
    }


    /**  
    * Check Input
    *
    * [Kim Vu] Create New [26/01/2018]
    **/
    this.TestInput = function () {
        ASOFT.form.clearMessageBox();

        if ($("#TimeReceive ").val() == "" ||
            $("#TimeReceive ").val() == "undefined" ||
            $("#TimeReceive ").val() == null
            ) {
            CSMF2055.inputError("TimeReceive ");
            var msg = ASOFT.helper.getMessage("00ML000039");
            ASOFT.form.displayError("#CSMF2055", kendo.format(msg, ASOFT.helper.getLanguageString("CSMF2055.TimeReceive", "CSMF2055", "CSM")));
            return false;
        }
        return true;
    }

    /**  
    * Add class error
    *
    * [Kim Vu] Create New [26/01/2018]
    **/
    this.inputError = function (pVariable) {
        var element = $('#' + pVariable);
        var fromWidget = element.closest(".k-widget");
        var widgetElement = element.closest("[data-" + kendo.ns + "role]");
        var widgetObject = kendo.widgetInstance(widgetElement);

        if (widgetObject != undefined && widgetObject.options.name != "TabStrip") {
            fromWidget.addClass('asf-focus-input-error');
            var input = fromWidget.find(">:first-child").find(">:first-child");
            if (input) {
                $(input).addClass('asf-focus-combobox-input-error');
            }
        } else {
            element.addClass('asf-focus-input-error');
        }
    }

    // #region  --- Event Handle ---

    /**  
   * Close form
   *
   * [Kim Vu] Create New [26/01/2018]
   **/
    this.Close = function (e) {
        if (isDataChanged()) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                CSMF2055.Save,
                function () {
                    parent.popupClose();
                });
        }
        else {
            parent.popupClose();
        }        
    }

    /**  
    * Save Data
    *
    * [Kim Vu] Create New [26/01/2018]
    **/
    this.Save = function (e) {
        // Kiem tra nhap lieu
        if (!CSMF2055.TestInput())
            return;
        var urlSave = "/CSM/CSMF2050/DoExecuteCheckGSX";
        var dataSave = {
            apk: window.parent.$("#PK").val(),
            timeReceive: $("#TimeReceive").data('kendoDateTimePicker').value(),
            status: $("#Status").data('kendoComboBox').value(),
            notes: $("#Notes").val()
        };
        ASOFT.helper.postTypeJson(urlSave, dataSave, function (result) {
            if (result) {
                ASOFT.dialog.showMessage('00ML000015');
                parent.popupClose();
            } else {
                ASOFT.dialog.showMessage('00ML000062');
            }
        });
    }

    // #endregion  --- Event Handle ---
}