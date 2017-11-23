//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     23/12/2015      Quang Hoàng         Tạo mới
//####################################################################

var isClose = 0; //Toàn Thiện cập nhật, kiểm soát tình trạng close
var id = $("#sysScreenID").val();
var module = $("#module").val();
var url = null;
var urlupdate = null;
var unique = null;
var action = 0;
var checkunique = 0;
var defaultViewModel = {};
var tbPopup = $("#table").val();
var isUpdate = false;
var updateSuccess = 0;
var fileUploaded = {};
var noClear = null;

$(document).ready(function () {
    var urlPopup = window.location.href;
    var para = urlPopup.split('?')[1];
    var vlPara = para != null ? para.split('&') : "";
    for (var h = 0; h < vlPara.length; h++) {
        if (vlPara[h].toUpperCase().indexOf('NOUPDATE') != -1) {
            var noUpdate = vlPara[h].split('=')[1];
            if (noUpdate == "1") {
                $("#Save").data("kendoButton").enable(false);
                $("#Close").unbind();
                $("#Close").kendoButton({
                    "click": ASOFT.asoftPopup.hideIframe
                });
            }
        }
    }

    var iprequaird = $(":input[type='text'][requaird='0']");
    $(iprequaird).each(function () {
        $(this).attr("data-val-required", "The field is required.");
    })

    var requairdSelect = $("select[requaird='0']");
    $(requairdSelect).each(function () {
        $(this).attr("data-val-required", "The field is required.");
    })

    var ip = $(":input[type='text']");
    $(ip).each(function () {
        $(this).attr("name", this.id);

        regular = $(this).attr("regular");
        message = $(this).attr("message");

        $(this).attr("data-val-regex-pattern", regular);
        $(this).attr("data-val-regex", message);
    })

    var multiSelect = $("select[data-role='multiselect']");
    $(multiSelect).each(function () {
        $(this).attr("name", this.id);

        regular = $(this).attr("regular");
        message = $(this).attr("message");

        $(this).attr("data-val-regex-pattern", regular);
        $(this).attr("data-val-regex", message);
    })

    var rdo = $(":input[type='radio']");
    $(rdo).each(function () {
        $(this).attr("name", this.id);
    })

    var tArea = $(".asf-textarea");
    $(tArea).each(function () {
        $(this).attr("name", this.id);

        regular = $(this).attr("regular");
        message = $(this).attr("message");

        $(this).attr("data-val-regex-pattern", regular);
        $(this).attr("data-val-regex", message);
    })

    var data = ASOFT.helper.dataFormToJSON(id);
    var listCombobox = [];
    if (data["CheckInList"] != undefined) {
        if (jQuery.type(data["CheckInList"]) === "string") {
            listCombobox.push(data["CheckInList"]);
        }
        else {
            listCombobox = data["CheckInList"];
        }
    }
    for (var i = 0; i < listCombobox.length; i++) {
        var isR = $("#" + listCombobox[i]).data("kendoComboBox").element.attr("readOL");
        if (isR == "True") {
            $("#" + listCombobox[i]).data("kendoComboBox").readonly(true);
        }
    }

    url = $("#urladd").val();
    urlupdate = $("#urlupdate").val();

    var dt = ASOFT.helper.dataFormToJSON(id);

    if (dt.Unique !== undefined) {
        unique = {};
        if (jQuery.type(dt.Unique) === "string") {
            unique[dt.Unique] = dt[dt.Unique];
        }
        else {
            $.each(dt.Unique, function (index, value) {
                unique[value] = dt[value];
            });
        }
    }
    refreshModel();

    $(".btnOpenSearch").bind("focusin", btnOpenSearchFocus);
})


function refreshModel() {
    defaultViewModel = ASOFT.helper.dataFormToJSON(id);

    var cb = $("input[type='checkbox']");
    $(cb).each(function () {
        var temp = $(this).is(':checked');
        var id = $(this).attr("id");
        if (temp) {
            defaultViewModel[id] = "1";
        }
        else {
            defaultViewModel[id] = "0";
        }
    })
}

//Mở chức năng mở rộng
function ShowMoreFrame(e) {
    $('.sub-MenuMore').toggleClass('asf-disabled-visibility');
    ASOFT.form.clearMessageBox();
    var url = $(e).children().attr('id');
    url = '/plugin/' + url.replace('Controller', '') + '/index';

    var datamaster = ASOFT.helper.dataFormToJSON(id);
    var list = new Array();
    $.each(datamaster, function (key, value) {
        if (key.indexOf("_input") == -1) {
            var item = new Object();
            list.push(AddList(key, value));
        }
    });

    ASOFT.asoftPopup.showIframeHttpPost(url, list);
};
function popupPluginClose() {
    ASOFT.asoftPopup.hideIframe();
};
$("#MoreMenu").click(function () {
    $('.sub-MenuMore').toggleClass('asf-disabled-visibility');
})
//Kết thúc chức năng mở rộng

//function popupClose_Click(event) {
//    parent.popupClose();
//}

function SaveCopy_Click() {
    isUpdate = false;
    action = 2;
    save(url);
}

function SaveNew_Click() {
    isUpdate = false;
    action = 1;
    save(url);
}

function SaveUpdate_Click() {
    isUpdate = true;
    action = 3;
    checkunique = 1;
    save(urlupdate);
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

    if (typeof CustomerCheck === "function") {
        Check = CustomerCheck();
        if (Check) {
            return false;
        }
    }

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

function save1(url1) {
    var data = ASOFT.helper.dataFormToJSON(id);
    var key1 = Array();
    var value1 = Array();

    if (typeof CustomSavePopupLayout === "function") {
        var customdata = [];
        customdata = CustomSavePopupLayout();
        key1 = customdata[0];
        value1 = customdata[1];
    }
    else {
        var cb = $("input[type='checkbox']");
        $(cb).each(function () {
            var temp = $(this).is(':checked');
            var id = $(this).attr("id");
            if (temp) {
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
    }

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

    //TRuyền biến để lưu lịch sử
    var history = [];

    if (typeof parent.GetTableParent === "function") {
        var ParentList = parent.GetTableParent();

        if (ParentList.TBParent != tbPopup) {
            if ($("#isUpdate").val() == "False") {
                url1 = url1 + "?TBParent=" + ParentList.TBParent + "&ValueParent=" + ParentList.VLParent;
            }
            if ($("#isUpdate").val() == "True") {
                url1 = url1 + "&TBParent=" + ParentList.TBParent + "&ValueParent=" + ParentList.VLParent;
                history = getHistoryChange(defaultViewModel, data);
            }
        }
        else {
            if ($("#isUpdate").val() == "True") {
                history = getHistoryChange(defaultViewModel, data);
            }
        }
    }

    ASOFT.helper.postTypeJson3(url1, { cl: key1, dt: value1, historyChange: history }, onInsertSuccess);

    if (action == 3 && updateSuccess == 1) {
        if (typeof onAfterSave === "function") {
            onAfterSave();
        } else {
            window.parent.location.reload();
        }
    }
}

function getHistoryChange(defaultDt, data) {
    var returnDataChange = [];
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox" && key != "Unique") {
            if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                var change = null;
                defaultDt[key] = defaultDt[key] != undefined ? defaultDt[key] : "";
                if (value.toString() !== defaultDt[key].toString()) {
                    change = "- '" + id + "." + key + "." + module + "': " + defaultDt[key] + " -> " + value;
                    returnDataChange.push(change);
                }
            }
        }
    })
    return returnDataChange;
}

function AddList(key, value) {
    var item = new Object();
    item.key = key;
    item.value = value;
    return item;
};

function onInsertSuccess(result) {

    if (result.Status == 0) {
        refreshModel();
        if (typeof parent.AddValueCombobox === "function") {
            if (typeof AddValueComboboxCustom === "function") {
                AddValueComboboxCustom(); // set value custom cho thêm nhanh combobox
            }
            else if (localStorage.getItem("IDCommbox") != null) { // nếu k có thì set value mặc định
                localStorage.setItem("ValueCombobox", $("#" + localStorage.getItem("IDCommbox")).val());
            }
            parent.AddValueCombobox();
        }

        switch (action) {
            case 1://save new
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid(tbPopup);
                }
                if (typeof clearfieldsCustomer === "function") {
                    clearfieldsCustomer();
                }
                else
                    clearfields();
                break;
            case 2://save new
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid(tbPopup);
                }
                break;
            case 3://save copy
                updateSuccess = 1;
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                //refreshModel();
                break;
            case 4:
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid(tbPopup);
                }
                parent.popupClose();
            case 0://save close, Lưu xong và đóng lại  
                window.parent.BtnFilter_Click();
                parent.popupClose();
        }
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
    if (isClose != 0 && result.Status == 0) {
        parent.popupClose();
    }
    //Kiểm tra có function mở rộng
    if (typeof onAfterInsertSuccess !== 'undefined' && $.isFunction(onAfterInsertSuccess)) {
        onAfterInsertSuccess(result, action);
    }
}

function clearfields() {
    var data = ASOFT.helper.dataFormToJSON(id);
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit" && key.indexOf(noClear) == -1) {
                if ($("#" + key).data("kendoComboBox") != null) {
                    $("#" + key).data("kendoComboBox").value("");
                }
                if ($("#" + key).data("kendoDropDownList") != null) {
                    $("#" + key).data("kendoDropDownList").value("");
                    $("#" + key).data("kendoDropDownList").text("");
                }
                if ($("#" + key).data('kendoNumericTextBox') != null) {
                    $("#" + key).data('kendoNumericTextBox').value('');
                }
                $("#" + key).val('');
            }
        }
    })
}


//Script combobox
$(document).ready(function () {
    var ListParentChild = {};
    $.each($("input"), function () {
        var TempValue = $("#" + $(this).attr("id") + "_Type_Fields").attr("value");
        if (TempValue == 3 && $(this).data("kendoComboBox") != null && $(this).data("kendoComboBox").element.attr("ParentCombo") != null) {
            OpenComboDynamic($(this).data("kendoComboBox"));//Sự kiện load lần đầu
            var ParentCombo = $(this).data("kendoComboBox").element.attr("ParentCombo");
            var Listparent = ParentCombo.split(',');
            for (i = 0; i < Listparent.length; i++) {
                if (ListParentChild[Listparent[i]] != null) {
                    ListParentChild[Listparent[i]] += $(this).data("kendoComboBox").element.attr("id") + ",";
                } else {
                    ListParentChild[Listparent[i]] = $(this).data("kendoComboBox").element.attr("id") + ",";
                }
            };
        }
    });
    setTimeout(function () {
        $.each(ListParentChild, function (key, value) {//key là parent, value là child
            if ($("#" + key).data("kendoComboBox") != null) {
                $("#" + key).data("kendoComboBox").bind("change", function () {
                    var ListChild = value.split(',');
                    for (i = 0; i < ListChild.length - 1; i++) {
                        $("#" + ListChild[i]).data("kendoComboBox").value("");
                        //$("#" + ListChild[i]).trigger('change');
                    };
                });
            }
        });
    }, 500);
});

function onComboSuccess(result, combo) {
    combo.dataSource.data(result);
    if (result.length == 0) {
        combo.value("");
    }
};

function onComboSuccessMulti(result, combo) {
    combo.setDataSource([]);
    combo.setDataSource(result);
}

function OpenComboDynamic(combo) {
    if (combo.sender != null) {
        SendFromCombo(combo.sender, "/combobox/ASOFTComboBoxDynamicLoadData");
    }
    else {
        SendFromCombo(combo, "/combobox/ASOFTComboBoxDynamicLoadData");
    }
};

function OpenMultiCheckListDynamic(combo) {
    SendFromCombo(combo, "/combobox/ASOFTMultiCheckListDynamicLoadData")
};

function OpenMultiSelectDynamic(combo) {
    if (combo.sender != null) {
        SendFromCombo(combo.sender, "/combobox/ASOFTComboBoxDynamicLoadData", 1)
    }
    else {
        SendFromCombo(combo, "/combobox/ASOFTComboBoxDynamicLoadData", 1)
    }
};


function SendFromCombo(combo, url, type) {
    var datamaster = ASOFT.helper.dataFormToJSON(id);
    var list = new Array();
    list.push(AddList("sysComboBoxID", combo.element.attr("sysComboBoxID")));
    list.push(AddList("ScreenID", combo.element.attr("ScreenID")));
    list.push(AddList("Module", combo.element.attr("Module")));
    $.each(datamaster, function (key, value) {
        if (key.indexOf("_input") == -1) {
            var item = new Object();
            list.push(AddList(key, value));
        }
    });
    ASOFT.helper.postTypeJsonComboBox(url, list, combo, type == 1 ? onComboSuccessMulti : onComboSuccess);
};

function AddList(key, value) {
    var item = new Object();
    item.key = key;
    item.value = value;
    return item;
};

function popupClose_Click(event) {
    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                action = 4;
                isClose = 1;
                save(url);
            },
            function () {
                parent.popupClose();
            });
    }
    else {
        parent.popupClose();
    }
}

function popupClose_ClickA(event) {
    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                action = 3
                checkunique = 1;
                save(urlupdate);
                //parent.popupClose();
            },
            function () {
                parent.popupClose();
            });
    }
    else {
        parent.popupClose();
    }
}


var isDataChanged = function () {
    var dataPost = getFormData();
    var cb = $("input[type='checkbox']");
    $(cb).each(function () {
        var temp = $(this).is(':checked');
        var id = $(this).attr("id");
        if (temp) {
            dataPost[id] = "1";
        }
        else {
            dataPost[id] = "0";
        }
    })
    var equal = isRelativeEqual(dataPost, defaultViewModel);
    return !equal;
};
var getFormData = function () {
    var dataPost = ASOFT.helper.dataFormToJSON(id);
    return dataPost;
};

var KENDO_INPUT_SUFFIX = '_input';
var KENDO_CHECKBOXINLIST = 'CheckInList'
var KENDO_CHECKBOX = 'TypeCheckBox'
// Kiểm tra bằng nhau giữa hai trạng thái của form
var isRelativeEqual = function (data1, data2) {
    if (data1 && data2
        && typeof data1 === "object"
        && typeof data2 === "object") {
        for (var prop in data1) {
            // So sánh thuộc tính của 2 data
            if (!data2.hasOwnProperty(prop)) {
                return false;
            }
            else {
                if (prop.indexOf(KENDO_INPUT_SUFFIX) != -1 || prop.indexOf(KENDO_CHECKBOX) != -1 || prop.indexOf(KENDO_CHECKBOXINLIST) != -1 || typeof data2[prop].valueOf() === "object") {
                    continue;
                }
                // Nếu giá trị hai thuộc tính không bằng nhau, thì data có khác biệt
                if (data1[prop].valueOf() != data2[prop].valueOf()) {
                    return false;
                }
            }
        }
        return true;
    }
    return undefined;
};

function LongDateTime(e) {
    $("#" + e.sender._form.context.id + "_timeview").css("overflow", "scroll");
    $("#" + e.sender._form.context.id + "_timeview").css("height", "300px");
}

function popupClose() {
    ASOFT.asoftPopup.hideIframe();
};


function onImageSuccess(data) {
    //if (data && data.response.counter > 0) {

    //    DRF1001.fieldName = data.response.array[0];
    //}
    var url = $('#UrlAvatar').val() + '?id=' + data.response.ImageLogo + '&Column=' + data.sender.element[0].id.split('_')[0];
    urlImage = url;
    $('#' + id + ' .' + data.sender.element[0].id.split('_')[0] + ' img').attr('src', url);
    $("." + data.sender.element[0].id.split('_')[0] + " .k-progress").css("top", "50px");
}

function onImageUpload(data) {
    if (fileUploaded[data.sender.element[0].id] == undefined)
        fileUploaded[data.sender.element[0].id] = 0;

    if (fileUploaded[data.sender.element[0].id] > 0) {
        $('.k-upload-files .k-file:first').remove();
    }

    fileUploaded[data.sender.element[0].id] = fileUploaded[data.sender.element[0].id] + 1;
}


function setReload() //hỗ trợ không cho reload lại trang
{
    updateSuccess = 0;
}


function Auto_Change(e) {
    if (typeof Auto_ChangeDynamic === "function") {
        var item = this.dataItem(e.item.index());
        Auto_ChangeDynamic(item);
    }
}


function OpenSearchClick(auto) {
    var autoComplete = $("#" + auto).data("kendoAutoComplete");
    OpenComboDynamic(autoComplete);
    autoComplete.search($("#" + auto).val());
}

function btnOpenSearchFocus() {
    var id = this.id.split('_')[1];
    var autoComplete = $("#" + id).data("kendoAutoComplete");
    OpenComboDynamic(autoComplete);
    autoComplete.search($("#" + id).val());
}

function Priority_Click(idCL, vl) {
    $("#" + idCL).val(vl);
    for (var i = 1; i <= 4; i++) {
        var imgSt = "/Content/Images/";
        imgSt = imgSt + (vl >= i ? "star.png" : "starnone.png");
        $(".st" + idCL + i).attr("src", imgSt);
    }
}

function GetKeyAutomatic(TableID, IDKey) {
    var data = {};
    data.TableID = TableID;
    ASOFT.helper.postTypeJson("/PopupLayout/GetKeyAutomatic", data, function (result) {
        $("#" + IDKey).val(result);
    });
}

function UpdateKeyAutomatic(TableID, Key) {
    var data = {};
    data.TableID = TableID;
    data.Key = Key;
    ASOFT.helper.postTypeJson("/PopupLayout/UpdateLastKeyAccount", data, function () { });
}

function OpenAdd(Src, area, type, e, typeCB) {
    var urlAdd = "/PopupLayout/Index/" + area + "/" + Src;
    if (type == "2") {
        urlAdd = "/PopupMasterDetail/Index/" + area + "/" + Src;
    }

    var idElm = typeCB == 1 ? $(e.parentElement.parentElement).attr("id") : $(e.parentElement.parentElement.parentElement.parentElement.parentElement).attr("id");
    localStorage.setItem("IDCommbox", idElm.split('-')[0]);

    ASOFT.asoftPopup.showIframe(urlAdd, {});
}

function AddValueCombobox() {
    if (localStorage.getItem("IDCommbox") != null) {
        var idComboBox = localStorage.getItem("IDCommbox");
        var cbb = $("#" + idComboBox).data("kendoComboBox");

        if (cbb != null) {
            OpenComboDynamic(cbb);
            $("#" + idComboBox).data("kendoComboBox").value(localStorage.getItem("ValueCombobox"));
        }
        else {
            var cbb = $("#" + idComboBox).data("kendoMultiSelect");
            if (cbb != null)
            {
                OpenMultiSelectDynamic(cbb);
                $("#" + idComboBox).data('kendoMultiSelect').open();
                $("#" + idComboBox).data('kendoMultiSelect').close();
                var vlMulti = $("#" + idComboBox).data('kendoMultiSelect').value();
                var vlMultiAdd = [];
                for (var i = 0; i < vlMulti.length; i++)
                {
                    vlMultiAdd.push(vlMulti[i]);
                }
                vlMultiAdd.push(localStorage.getItem("ValueCombobox"));
                $("#" + idComboBox).data('kendoMultiSelect').value([]);
                $("#" + idComboBox).data('kendoMultiSelect').value(vlMultiAdd);
            }
        }
    }
}
