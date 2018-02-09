
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/05/2014      Chanh Thi       Tạo mới
//####################################################################
var load = true;

$(document).ready(function () {
    window.onbeforeunload = function confirmExit() {
        if (load) {
            ASOFT.helper.post("/Login/RemoveSession", {}, function (result) {
            })
        }
    }

    var FORM_ID = '#LoginDivision',
    FORM_NAME = 'LoginDivision',
    ComboboxIDs = ['LogonDivisionID'],
    cbDivisionID = $('#LogonDivisionID').data('kendoComboBox'),
    txLoginDivisionName = $('#LogonDivisionName'),
    btnLogin = $('#btnLogin'),

    btnClose_Click = function (e) {
        ASOFT.helper.post("/Login/RemoveSession", {}, function (result) {
            if (window.parent.view.popupClose
                                && typeof (window.parent.view.popupClose) === 'function') {
                window.parent.view.popupClose();
            }
        })
    },
    btnLogin_Click = function () {

        ASOFT.form.clearMessageBox();
        if (!ASOFT.form.checkRequiredAndInList(FORM_NAME, cbDivisionID)) {
            var data = ASOFT.helper.getFormData(FORM_NAME);
            data.push({ name: "LogonDivisionName", value: txLoginDivisionName.val() });
            data.push({ name: "PortID", value: window.document.location.port });
            
            ASOFT.helper.post("/Login/DoLoginDivision", data, login_Success);
        }
    },

    // Hiển Thị DivisionName theo DivisionID
    divisionID_Change = function () {
        var dataItem = cbDivisionID.dataItem();
        if (dataItem) {
            txLoginDivisionName.val(dataItem.LogonDivisionName);
        } else {
            txLoginDivisionName.val('');
        }
    },

    login_Success = function (result) {
        load = false;
        loginCount = result.Data.loginCount;
        if (result && result.Status == 0 && window.parent.view) {
            //goToDaskboard();
            window.parent.view.goToDaskboard(result.Data.urlRedirect);
        }
    },

    initEvents = function () {
        $('#btnClose').on('click', btnClose_Click);
        $('#btnLogin').on('click', btnLogin_Click);
        cbDivisionID.bind('change', divisionID_Change);
        cbDivisionID.bind('dataBound', divisionID_Change);
        $(document).focus();
        $(document).on('keyup', function (e) {
            if (e.keyCode === 13) {
                btnLogin.trigger('click');
            }
        });
    };

    initEvents();
});
