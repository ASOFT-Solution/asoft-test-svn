//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#    30/06/2017      Quang Chiến         Tạo mới
//####################################################################
$(document).ready(function () {
    $("#popupInnerIframe").kendoWindow({
        activate: function () {
            var cboContractAnaTypeID = $("#ContractAnaTypeID").data("kendoComboBox");
            var cboSalesContractAnaTypeID = $("#SalesContractAnaTypeID").data("kendoComboBox");
            var cboDepartmentAnaTypeID = $("#DepartmentAnaTypeID").data("kendoComboBox");
            var cboTeamAnaTypeID = $("#TeamAnaTypeID").data("kendoComboBox");
            var cboProjectAnaTypeID = $("#ProjectAnaTypeID").data("kendoComboBox");
            var cboSalesAnaTypeID = $("#SalesAnaTypeID").data("kendoComboBox");
            var cboCostAnaTypeID = $("#CostAnaTypeID").data("kendoComboBox");

            var cboOPriceTypeID = $("#OPriceTypeID").data("kendoComboBox");
            if ($('#IsPriceControl').prop('checked')) {
                cboOPriceTypeID.readonly(false);
                $('.OPriceTypeID').css('opacity', '1');
            }
            else {
                cboOPriceTypeID.text('');
                cboOPriceTypeID.readonly(true);
                $('.OPriceTypeID').css('opacity', '0.5');
            }
        }
    });

    $('#IsPriceControl').click(function () {
        var cboOPriceTypeID = $("#OPriceTypeID").data("kendoComboBox");
        if (this.checked) {
            cboOPriceTypeID.readonly(false);
            $('.OPriceTypeID').css('opacity', '1');
        } else {
            cboOPriceTypeID.text('');
            cboOPriceTypeID.readonly(true);
            $('.OPriceTypeID').css('opacity', '0.5');
        }
    });
});
CIF0001 = new function () {
    //Event button config
    this.btnSave_Click = function () {
        ASOFT.form.clearMessageBox();
        if (ASOFT.form.checkRequired("CIF0001")) {
            return;
        }
        var data = ASOFT.helper.dataFormToJSON('CIF0001');
        data.IsPriceControl = $('#IsPriceControl').prop('checked');
        if (data.IsPriceControl && !data.OPriceTypeID) {
            ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OFML000020')], null);
            return;
        }

        data.IsQuantityControl = $('#IsQuantityControl').prop('checked');
        data.IsPermissionView = $('#IsPermissionView').prop('checked');
        data.IsSpecificate = $('#IsSpecificate').prop('checked');

        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, CIF0001.CIF0001SaveSuccess);
    };

    this.CIF0001SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'CIF0001', function () {
            ASOFT.asoftPopup.hideIframe(true);
        }, null, null, true);
    }

    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.btnClose_Click = function () {
        ASOFT.asoftPopup.hideIframe(true);
    };

    this.CboAnaChange_Change = function (e) {
        if (e) {
            var txtID = e.sender.input.context.id.slice(0, e.sender.input.context.id.lastIndexOf("ID")) + 'Name';
            var item = e.sender.dataItem();
            $('#' + txtID).val(item.UserName);
        }
    }
}