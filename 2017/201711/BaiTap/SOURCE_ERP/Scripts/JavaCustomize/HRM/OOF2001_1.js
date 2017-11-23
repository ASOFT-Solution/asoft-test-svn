//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     17/01/2016     Quang Chiến       Tạo mới
//####################################################################

var idFields = null;
var apk = null;
var urlParent = null;
var isStatus = null;

$(document).ready(function () {
    urlParent = parent.GetUrlContentMaster() + "HRM/OOF2050";
    $('#ID').prop("readonly", true);
    idFields = $("#ID").val()
    if ($('#isUpdate').val() == "True") {
        isStatus = "Update";
    } else if ($('#isInherit').val() == "True") {
        isStatus = "Inherit";
    } else {
        isStatus = "AddNew";
    }

    if ($("#CheckDetail").val() == 1) {
        $("#DepartmentID").data("kendoComboBox").readonly();
        $("#SectionID").data("kendoComboBox").readonly();
        $("#SubsectionID").data("kendoComboBox").readonly();
        $("#ProcessID").data("kendoComboBox").readonly();
    } else {

        var cboDepartment = $("#DepartmentID").data("kendoComboBox");
        cboDepartment.bind("change", function (e) {
            $("#SubsectionID").data("kendoComboBox").text('');
            $("#ProcessID").data("kendoComboBox").text('');
            cboDepartment.input.focus();
        });

        var cboSection = $("#SectionID").data("kendoComboBox");
        cboSection.bind("change", function (e) {
            $("#ProcessID").data("kendoComboBox").text('');
            cboSection.input.focus();
        });

        var cboSubsection = $("#SubsectionID").data("kendoComboBox");
        cboSubsection.bind("change", function (e) {
            cboSubsection.input.focus();
        });

        var cboProcess = $("#ProcessID").data("kendoComboBox");
        cboProcess.bind("change", function (e) {
            cboProcess.input.focus();
        });
    }

    if ($('#isInherit').val() == 'True') {
        $('#Save').unbind();
        $("#Save").kendoButton({
            "click": CustomBtnSave_Click,
        });

        $('#Close').unbind();
        $("#Close").kendoButton({
            "click": CustomBtnClose_Click,
        });
    }
    var level = $("#Level").val();
    for (var i = 1; i <= level; i++) {
        if (i < 10) {
            var ApprovePersonCombo = $("#ApprovePerson0" + i + "ID").data("kendoComboBox");
           
           
            if (ApprovePersonCombo) {
                ApprovePersonCombo.unbind("open");
                ApprovePersonCombo.bind("open", function (combo) {
                    OOF2001.OpenApprovePreson(combo,2);
                });
            }
        }
        else {
            var ApprovePersonCombo = $("#ApprovePerson" + i + "ID").data("kendoComboBox");
            if (ApprovePersonCombo) {
                ApprovePersonCombo.unbind("open");
                ApprovePersonCombo.bind("open", function () {
                    OOF2001.OpenApprovePreson(combo, 2);
                });
            }
        }

    }

    if ($('#isUpdate').val() == 'True' ||$('#isInherit').val() == 'True' ) {
        for (var i = 1; i <= level; i++) {
            var ApprovePersonCombo = null;
            if (i < 10) {
                ApprovePersonCombo = $("#ApprovePerson0" + i + "ID").data("kendoComboBox");
            }
            else {
                ApprovePersonCombo = $("#ApprovePerson" + i + "ID").data("kendoComboBox");

            }
            if (ApprovePersonCombo) {
                OOF2001.OpenApprovePreson(ApprovePersonCombo, 1);
            }
        }
    }
})

OOF2001 = new function () {
    this.OpenApprovePreson = function (combo,num) {
        var Url = "/HRM/OOF9000/LoadDataComboApprovePerson";
        var ApprovePersonCombo = null;
        var array = [];

        var level = $("#Level").val();
        for (var i = 1; i <= level; i++) {
            if (i < 10) {
                ApprovePersonCombo = $("#ApprovePerson0" + i + "ID").val();
            }
            else {
                ApprovePersonCombo = $("#ApprovePerson" + i + "ID").val();
            }

            if (ApprovePersonCombo) {
                array.push(ApprovePersonCombo);
            }
        }
        var NameComboBox = null;
        if (num == 1) {
            NameComboBox = $(combo.element).attr('id');
        } else {
            NameComboBox = combo.sender.element.attr("Name");
        }
        var list = new Array();
        list.push(this.AddList("Name", NameComboBox));
        list.push(this.AddList("DepartmentID", $('#DepartmentID').val()));
        list.push(this.AddList("SectionID", $('#SectionID').val()));
        list.push(this.AddList("SubsectionID", $('#SubsectionID').val()));
        list.push(this.AddList("ProcessID", $('#ProcessID').val()));
        list.push(this.AddList("Num", num));
        list.push(this.AddList("Type", "BPC"));
        ASOFT.helper.postTypeJsonComboBox(Url, list, combo, this.onComboSuccess);
    }
    this.AddList = function (key, value) {
        var item = new Object();
        item.key = key;
        item.value = value;
        return item;
    };
    //Script combobox
    this.onComboSuccess = function (result, combo) {
        if (result[result.length - 1].Num == 1) {
            result.pop();
            combo.dataSource.data(result)
        } else {
            result.pop();
            combo.sender.element.data("kendoComboBox").dataSource.data(result);
        }
    };
}

function CustomBtnSave_Click() {
    var url = "/GridCommon/InsertBussiness/" + module + "/" + id;
    action = 1;
    saveInherit(url)
}

function CustomBtnClose_Click() {
    var url = "/GridCommon/InsertBussiness/" + module + "/" + id;
    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                action = 1;
                saveInherit(url)
            },
            function () {
                parent.popupClose();
            });
    }
    else {
        parent.popupClose();
    }
    
}

function saveInherit(url) {
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
    var Confirm;

    if (typeof CustomerConfirm === "function") {
        Confirm = CustomerConfirm();
        if (Confirm.Status != 0) {
            ASOFT.dialog.confirmDialog(Confirm.Message,
                function () {
                    saveInherit1(url);
                },
                function () {
                    return false;
                });
        }
        else {
            saveInherit1(url);
        }
    }
    else {
        saveInherit1(url);
    }
}
function saveInherit1(url) {
    var data = ASOFT.helper.dataFormToJSON(id);
    var key1 = Array();
    var value1 = Array();

    var cb = $("input[type='checkbox']");
    $(cb).each(function () {
        var temp = $(this).attr("checked");
        var id = $(this).attr("id");
        if (temp == "checked") {
            data[id] = "1";
        }
        else {
            data[id] = "0";
        }
    })


    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox" && key != "Unique") {
            if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                key1.push(key);
                var vl = Array();
                if (value == "false")
                    value = "0";
                if (value == "true")
                    value = "1";
                vl.push(data[key + "_Content_DataType"], value);
                value1.push(vl);
            }
        }
    })

    if (checkunique == 1) {
        var un = 0;
        var unn = 0;
        $.each(unique, function (key, value) {
            if (unique[key] == data[key]) {
                unn++;
            }
            un++;
        })
        if (un == unn) {
            url = url + "?mode=1";
        }
        checkunique = 0;
    }

    ASOFT.helper.postTypeJson1(url, key1, value1, saveSuccess);
}

var id = $("#sysScreenID").val();
function saveSuccess(result) {
    if (result.Status == 0) {
        if (isUpdate == true) {
            parent.ReloadPage();
        }

        ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
        window.parent.BtnFilter_Click();
       
    }
    else {
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
    //Kiểm tra có function mở rộng
    if (typeof onAfterInsertSuccess !== 'undefined' && $.isFunction(onAfterInsertSuccess)) {
        onAfterInsertSuccess(result, action);
    }
}

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0) {
        var url = "/HRM/OOF9000/LoadLastKey";
        var data = {
            table: 'OOT2000',
            type: 'BPC',
            id: idFields
        };

        ASOFT.helper.post(url, data, function (data) {
            $('#ID').val(data.ID);
            $('#LastKey').val(data.LastKey);
            $('#LastKeyAPK').val(data.LastKeyAPK);
            $('#FormStatus').val(isStatus);
            apk = data.apk;
            idFields = data.ID;
        });

        if (action == 1 || action == 2) {
            sendMail();
        }

        var grid = window.parent.$('#GridOOT9000').data('kendoGrid');
        if (grid) {
            grid.dataSource.read();
        }
        if ($('#isInherit').val() == 'True') {
            parent.popupClose();
        }
    } else {
        if (result.Message == "OOFML000015") {
            var url = "/HRM/OOF9000/LoadLastKey";
            var data = {
                table: 'OOT2000',
                type: 'BPC',
                id: idFields
            };
            ASOFT.helper.post(url, data, function (data) {
                $('#ID').val(data.ID);
                $('#LastKey').val(data.LastKey);
                $('#LastKeyAPK').val(data.LastKeyAPK);
                $('#FormStatus').val(isStatus);
                apk = data.apk;
                idFields = data.ID;
            });
        }
    }
}


function sendMail() {
    var dataSendMail = [];
    dataSendMail.push(apk);
    dataSendMail.push(null);
    dataSendMail.push(urlParent);
    ASOFT.helper.postTypeJson("/HRM/OOF2050/SendMail", dataSendMail, sendMailSuccess);
}

function sendMailSuccess(result) {
    if (result.isCheck) {
        if (result.isSendMail) {
            if (result.empName) {
                if ($('#isInherit').val() == 'True') {
                    var content = ASOFT.form.createMessageBox([ASOFT.helper.getMessage('OOFML000034').f(result.empName)]);
                    $(window.parent.FormFilter).prepend(content);
                } else {
                    ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000034').f(result.empName)], null);
                }
            }
        }
        else {
            if ($('#isInherit').val() == 'True') {
                var content = ASOFT.form.createMessageBox([ASOFT.helper.getMessage('00ML000097')]);
                $(window.parent.FormFilter).prepend(content);
            } else {
                ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('00ML000097')], null);
            }
        }
    }
}