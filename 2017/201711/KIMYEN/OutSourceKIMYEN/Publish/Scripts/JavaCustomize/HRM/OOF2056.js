
var urlParent = null;
var key1 = Array();
var value1 = Array();
var dataFail = null;

$(document).ready(function () {
    $(".line_left .asf-table-view").append($(".ApprovePersonNote"));

    $("#BtnSave").unbind();
    $("#Close").unbind();
    $("#Close").on("click", function () {
        //parent.popupClose();
        popupClose_Click(event);
    })
    $("#BtnSave").on("click", function () {
        parent.popupClose();
    })

    var status = getUrlParameter("StatusOOF2056");
    var cboApprovePersonStatus = $('#ApprovePersonStatus').data('kendoComboBox')
    cboApprovePersonStatus.bind('open', function () {
        var dataSource = cboApprovePersonStatus.dataSource._data.filter(function (item) { return item.ID != status });
        cboApprovePersonStatus.setDataSource(dataSource);
    });

})

var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

function SaveUpdate_Click() {
    isUpdate = true;
    action = 3;
    checkunique = 1;
    save("/HRM/OOF2050/UpdateAll");
}

function save(url) {
    //if (ASOFT.form.checkRequired(id)) {
    //    return;
    //}
    var data = ASOFT.helper.dataFormToJSON(id);
    var CheckInList = [];
    if (data["CheckInList"] != undefined) {
        if (jQuery.type(data["CheckInList"]) === "string") {
            CheckInList.push(data["CheckInList"]);
        }
        else {
            CheckInList = data["CheckInList"];
        }
    }
    if (ASOFT.form.checkRequiredAndInList(id, CheckInList)) {
        return;
    }
    if ($("#ApprovePersonStatus").val() == 0) {
        var msg = ASOFT.helper.getMessage("OOFML000024");
        ASOFT.form.displayError("#" + id, msg);
        return;
    }

    // Xu li check CustomizeApproved
    if (typeof window.parent.CustomizeApproved === "function") {
        window.parent.CustomizeApproved($("#ApprovePersonStatus").val());
        ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage('00ML000015'));
        window.parent.BtnFilter_Click();
        return;
    } else {

        var Confirm;

        if (typeof CustomerConfirm === "function") {
            Confirm = CustomerConfirm();
            if (Confirm.Status != 0) {
                ASOFT.dialog.confirmDialog(Confirm.Message,
                    function () {
                        save1(url);
                    },
                    function () {
                        return false;
                    });
            }
            else {
                save1(url);
            }
        }
        else {
            save1(url);
        }
    }
}

function save1(url1) {
    var data = ASOFT.helper.dataFormToJSON(id);
    var key1 = Array();
    var value1 = Array();

    var customdata = [];
    customdata = CustomSavePopupLayout();
    key1 = customdata[0];
    value1 = customdata[1];

    if (checkunique == 1) {
        if (unique == null) {
            url1 = url1 + "?mode=1";
        }
        else {
            var un = 0;
            var unn = 0;
            $.each(unique, function (key, value) {
                if (unique[key] == data[key]) {
                    unn++;
                }
                un++;
            })
            if (un == unn) {
                url1 = url1 + "?mode=1";
            }
            checkunique = 0;
        }
    }

    ASOFT.helper.postTypeJson1(url1, key1, value1, onInsertSuccess);

    //if (action == 3) {
    //    //window.parent.location.reload();
    //    IsCheckExecute = true;
    //    parent.BtnFilter_Click();
    //}
}

function onInsertSuccess(result) {

    if (result.Status == 0) {
        switch (action) {
            case 3://save copy
                updateSuccess = 1;
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                onAfterInsertSuccess();
                //refreshModel();
                break;
            case 0://save close, Lưu xong và đóng lại  
                window.parent.BtnFilter_Click();
                parent.popupClose();
        }
    }
    else {
        dataFail = result.Data;
        onAfterInsertSuccess();
        if (result.Message != 'Validation') {
            var msg = ASOFT.helper.getMessage(result.Message);
            if (result.Data) {
                msg = kendo.format(msg, result.Data);
            }
            ASOFT.form.displayWarning('#' + id, msg);
        }
        else {
            var msgData = new Array();
            $.each(result.Data, function (index, value) {
                var child = value.split(',');
                var msg = ASOFT.helper.getMessage(child[0]);
                msg = kendo.format(msg, child[1], child[2], child[3], child[4]);
                msgData.push(msg);
            });
            ASOFT.form.displayMultiMessageBox(id, 1, msgData);
        }
    }
}


function CustomSavePopupLayout() {
    urlParent = parent.GetUrlContentMaster() + "HRM/OOF2050";
    var GridKendo = parent.GetDataGridParent("OOT9000");
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0)
        return;
    var custom = [];
    var data = null;

    var dataFormFilter = sessionStorage.getItem('dataFormFilter');
    var dataFormFilters = JSON.parse(dataFormFilter);
    if (dataFormFilters) {
        data = dataFormFilters;
    } else {
        data = parent.GetDataFormFilter();
    }

    var datapopup = ASOFT.helper.dataFormToJSON("OOF2056");
    $.each(data, function (key, value) {
        if (key.indexOf("_input") == -1) {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                value1.push(value);
                key1.push(key.split('_')[0]);
            }
        }
    })
    var numcheck = parent.GetCheckAll();
    value1.push(numcheck);
    key1.push("IsCheckALL");


    var valuepk = [];
    if (numcheck == 0) {
        //var column = datapopup["ApprovePersonStatus"] == '1' ? "APK" : "APKCancel";
        for (var i = 0; i < records.length; i++) {
            valuepk.push(records[i]["APK"]);
        }
    }


    valuepk = valuepk.join(',');
    value1.push(valuepk);
    key1.push("APKList");

    value1.push(datapopup["ApprovePersonStatus"]);
    key1.push("ApprovePersonStatus");
    value1.push(datapopup["ApprovePersonNote"]);
    key1.push("ApprovePersonNote");
    value1.push(parent.GetIsSearch());
    key1.push("IsSearch");

    custom.push(key1, value1);
    return custom;
}


function onAfterInsertSuccess(result, action) {
    var data = [];
    key1.push("urlParent");
    key1.push("dataFail");
    value1.push(urlParent);
    value1.push(dataFail);
    ASOFT.helper.postTypeJson1("/HRM/OOF2050/SendMailALL", key1, value1, sendMailSuccess);
}

function sendMailSuccess(result) {
    var content = null;
    if (result.isCheck) {
        if (result.isSendMail) {
            if (result.empName) {
                content = ASOFT.form.createMessageBox([ASOFT.helper.getMessage('OOFML000034').f(result.empName)]);
                $(window.parent.FormFilter).prepend(content);
            } else {
                if (action == 3) {
                    //window.parent.location.reload();
                    IsCheckExecute = true;
                    parent.BtnFilter_Click();
                }
            }
        } else {
            content = ASOFT.form.createMessageBox([ASOFT.helper.getMessage('00ML000097')]);
            $(window.parent.FormFilter).prepend(content);
        }
    } else {
        if (action == 3) {
            //window.parent.location.reload();
            IsCheckExecute = true;
            parent.BtnFilter_Click();
        }
    }
}

