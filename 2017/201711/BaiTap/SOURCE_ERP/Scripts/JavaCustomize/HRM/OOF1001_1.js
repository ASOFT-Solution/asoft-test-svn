//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     26/01/2016     Quang Chiến       Tạo mới
//####################################################################

$(document).ready(function () {
    //if ($('#isUpdate').val() == "True") {
    //    $('#AbsentTypeID').prop("readonly", true);
    //}

    var ClassType = $(".Note");
    $(".Note").remove();
    $(".RestrictID").after(ClassType);

    var cboRestrictID = $('#RestrictID').data("kendoComboBox");

    $('#IsDTVS').click(function () {

        if (this.checked) {
            cboRestrictID.readonly(false);
            $('.RestrictID').css('opacity', '1');
        } else {
            cboRestrictID.text('');
            cboRestrictID.readonly(true);
            $('.RestrictID').css('opacity', '0.5');
        }
    });

    $("#popupInnerIframe").kendoWindow({
        activate: function () {
            if ($('#isUpdate').val() == "True" && $('#IsDTVS').is(':checked')) {
                $('.RestrictID').css('opacity', '1');
                cboRestrictID.readonly(false);
            } else {
                cboRestrictID.text('')
                cboRestrictID.readonly(true);
                $('.RestrictID').css('opacity', '0.5');
            }
        }
    });
})

function CustomerCheck() {
    ASOFT.form.clearMessageBox();
    $('#RestrictID .asf-focus-input-error').removeClass('asf-focus-input-error');
    $('#RestrictID .asf-focus-combobox-input-error').removeClass('asf-focus-combobox-input-error');
    
    if ($('#IsDTVS').is(':checked') && !$('#RestrictID').val()) {
        var element = $('#RestrictID');
        var fromWidget = element.closest(".k-widget");
        var widgetElement = element.closest("[data-" + kendo.ns + "role]");
        var widgetObject = kendo.widgetInstance(widgetElement);

        if (widgetObject != undefined && widgetObject.options.name != "TabStrip") {
            fromWidget.addClass('asf-focus-input-error');
            var input = fromWidget.find(">:first-child").find(">:first-child");
            $(input).addClass('asf-focus-combobox-input-error');
        } else {
            element.addClass('asf-focus-input-error');
        }
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000050')], null);
        return true;
    }
    return false;
}

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && action == 1 ) {
        $('#IsDTVS').prop('checked', false);

        var cboRestrictID = $('#RestrictID').data("kendoComboBox");
        cboRestrictID.readonly(true);
        $('.RestrictID').css('opacity', '0.5');
    }
}
