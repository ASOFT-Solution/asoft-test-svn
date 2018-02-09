 var btnInherit = "<a class='k-button-icontext asf-button k-button' id='btnInherit' data-role='button' role='button' aria-disabled='false' tabindex='0' style = 'min-width:27px'><span class='asf-button-text'>...</span></a>"
var newRow = "<tr class={0}><td class ='asf-td-caption'></td><td class = 'asf-td-field'></td></tr>"
var currentChoose = "";
var oldVoucherNo = "";

var templateAttachFile = function (textFileName, templateClass, textFileID) {
    this.getTemplate = kendo.format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label title='{3}'>{1}</label><label class='x-close'>&#10006</label></div>", templateClass, textFileName.length > 25 ? [textFileName.slice(0, 24), "..."].join("") : textFileName, textFileID, textFileName);
};

var templateAsoftButton = function () {
    this.getAsoftButton = function (buttonClass, buttonID, spanClass, buttonCaption, onclickFunction) {
        return kendo.format("<a onclick='{4}' class='k-button k-button-icontext asf-button {0}' id='{1}' data-role='button' role='button' style='min-width:35px; margin-left:5px;' aria-disabled='false' tabindex='0'><span class='asf-button-text {2}'>{3}</span></a>",
            buttonClass,
            buttonID,
            spanClass,
            buttonCaption,
            onclickFunction);
    };

    this.getDeleteAsoftButton = function (buttonID, onclickFunction) {
        return kendo.format("<a id='{0}' onclick='{1}' aria-disabled='false' tabindex='0' data-role='button' role='button' style='height: 16px;'><span style='height: 16px' class='k-sprite asf-icon asf-icon-32 asf-i-delete-32 disabledButton'></span></a>",
            buttonID,
            onclickFunction);
    };

    return this;
};

setButtonDeleteDisableWhenObjectChange = function ($Object, $ButtonDelete, buttonEventClick) {

    if (typeof $Object !== "undefined" && typeof $ButtonDelete !== "undefined") {
        if (typeof $Object.val === "function" && typeof $Object.val() !== "undefined") {
            $Object.val() == ""
            ? $ButtonDelete.unbind("click").children().addClass("disabledButton")
            : $ButtonDelete.bind("click", typeof buttonEventClick === "function" ? buttonEventClick : false).children().removeClass("disabledButton");
        }
        if (typeof $Object.value === "function" && $Object.value() !== "undefined") {
            $Object.value() == ""
            ? $ButtonDelete.unbind("click").children().addClass("disabledButton")
            : $ButtonDelete.bind("click", typeof buttonEventClick === "function" ? buttonEventClick : false).children().removeClass("disabledButton");
        }
    }
    return false;
}

function getResultAfterDelete(result, apkDelete) {

    var $resultAfterDelete = $.map(result, (function (obj) {

        if (obj.APK != apkDelete)
            return obj;
    }));

    return $resultAfterDelete.length > 0 ? $resultAfterDelete : "";
}

function deleteFile(jqueryObjectClick) {

    var $parentXClose = jqueryObjectClick.parent(),

        $templeteAll = $(".templeteAll"),

        $apkDelete = $parentXClose.attr("id"),

        $attach = $("#Attach"),

        $result = $attach.val().split(','),

        $resultAfterDelete = getResultAfterDelete($result, $apkDelete);

    $attach.val(JSON.stringify($resultAfterDelete));

    $parentXClose.remove();

    typeof $templeteAll !== "undefined"
        ? ($templeteAll.find(".file-templete").length == 0
            ? ($templeteAll.remove(), $attach.val("").trigger("change"))
            : false)
        : false;
}

function btnUpload_click(e) {

    var urlPopup3 = "/AttachFile?Type=5";

    ASOFT.asoftPopup.showIframe(urlPopup3, {});

    currentChoose = "Attach";
}

function btnDeleteUpload_click(e) {

    $(".templeteAll").remove();

    $("#Attach").val("").trigger("change");
}

$(document).ready(function () {
    GRID_AUTOCOMPLETE.config({
        gridName: 'GridEditHRMT2091',
        inputID: 'autocomplete-box',
        autoSuggest: false,
        serverFilter: true,
        NameColumn: "EmployeeID",
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.container.parent().css('background', '')
            selectedRowItem.model.set("EmployeeID", dataItem.EmployeeID);
            selectedRowItem.model.set("EmployeeName", dataItem.EmployeeName);
            selectedRowItem.model.set("DutyName", dataItem.DutyName);
            selectedRowItem.model.set("DepartmentName", dataItem.DepartmentName);
        }
    });
    var templeteButton = new templateAsoftButton(),
       form = $("#sysScreenID"),
       parentSysScreenID = parent.$("#sysScreenID").val();
    $(".ProposeAmount").after(kendo.format(newRow, "btnInherit"));
    $(".btnInherit .asf-td-field").append(btnInherit);
    $(".btnInherit .asf-td-caption").append(ASOFT.helper.getLanguageString("HRMF2091.Inherit", "HRMF2091", "HRM"));

    $("#btnInherit").bind('click', btnInherit_Click);

    // Change DepartmentID
    var DepartmentID = $("#DepartmentID").data("kendoComboBox");
    if (DepartmentID) {
        DepartmentID.bind('change', function () {
            $("#btnInherit").parent().removeClass('asf-disabled-li');
            $(".asf-message").remove();
        });
    }

    $("#btnAssignedToUserName").bind('click', btnChooseUserName_Click);
    $("#btnDeleteAssignedToUserName").bind('click', btnDeleteUserNameD_Click);

    // Event checkbox change    
    if ($("#isUpdate").val() == 'True') {
        chkIsAll_CheckedChaneg(null);
        $('.Attach').css('display', 'none');

        $("#TrainingProposeID").attr("readonly", true);
        $($("#IsAll").parent().parent()).addClass('asf-disabled-li');
        $("#btnInherit").parent().addClass('asf-disabled-li');
        $($("#DepartmentID").parent().parent()).addClass('asf-disabled-li');
    } else {
        $("#Attach")
            .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
            .parent()
            .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));
        $($(".Attach").children()[0]).css("width", "14%");
        autoCode();
        $("#Attach").css('display', 'none');
        $("#IsAll").bind('click', chkIsAll_CheckedChaneg);
    }
    // Event change grid
    var grid = $('#GridEditHRMT2091').data('kendoGrid');
    if ($("#isUpdate").val() != 'True') {
        grid.hideColumn(1);
    }
    $(grid.tbody).on("change", "td", function (e) {
        var selectitem = grid.dataItem(grid.select());
        var column = e.target.id;
        if (column == 'cbbTrainingFieldName') {
            var id = e.target.value;
            var combobox = $("#cbbTrainingFieldName").data("kendoComboBox");
            if (combobox) {
                var data = combobox.dataItem();
                selectitem.TrainingFieldID = data.TrainingFieldID;
                selectitem.TrainingFieldName = data.TrainingFieldName;
            }
            grid.refresh();
        } else if (column == 'cbbID') {
            var id = e.target.value;
            var combobox = $("#cbbID").data("kendoComboBox");
            if (combobox) {
                var data = combobox.dataItem();
                selectitem.ID = data.ID;
                selectitem.TrainingFieldID = data.TrainingFieldID;
                selectitem.TrainingFieldName = data.TrainingFieldName;
                selectitem.ToDate = data.ToDate;
                selectitem.FromDate = data.FromDate;
                selectitem.InheritID = data.InheritID;
                selectitem.InheritTableID = data.InheritTableID;
                selectitem.TranQuarter = data.TranQuarter;
                selectitem.TranYear = data.TranYear;
            }
            grid.refresh();
        }
    });

    // Add event grid
    $(grid.tbody).bind("focusout", "td", function (e) {
        var column = e.target.id;
        var selectedRow = grid.dataItem(grid.select());
        if (column == "ProposeAmount_DT") {
            var totalProposeAmount = 0;
            grid.dataSource.data().forEach(function (value) {
                if (selectedRow == value) {
                    totalProposeAmount += parseFloat($("#ProposeAmount_DT").val());
                } else {
                    totalProposeAmount += parseFloat(value.ProposeAmount_DT);
                }
            });
            $("#ProposeAmount").data('kendoNumericTextBox').value(totalProposeAmount);
            return;
        }
    });

    $("#DepartmentID").data('kendoComboBox').bind('change', cboDepartment_ValueChanged);

    // Check required AssignedToUserName
    $("#AssignedToUserName").attr("data-val-required", "The field is required").attr("requaird", "0");
    $("#AssignedToUserName").removeAttr("disabled").attr("readonly", true).css("background-color", "#dddddd");;
});

// Event checked change of checkbox All
function chkIsAll_CheckedChaneg(e) {
    if ($("#IsAll").prop('checked')) {
        $("#GridEditHRMT2091").css('display', 'none');
        $($("#DepartmentID").parent().parent()).addClass('asf-disabled-li');
        $("#DepartmentID").val("%");
        $("#btnInherit").parent().removeClass('asf-disabled-li');
        $(".asf-message").remove();
    } else {
        $("#GridEditHRMT2091").css('display', 'block');
        $($("#DepartmentID").parent().parent()).removeClass('asf-disabled-li');
    }
}

// Event value change of cbo department
function cboDepartment_ValueChanged(e) {
    if ($("#DepartmentID").data('kendoComboBox').dataItem().DepartmentID == '%') {
        $("#IsAll").prop('checked', true);
        chkIsAll_CheckedChaneg(null);
    }
}

//Inherit đề xuất đào tạo
function btnInherit_Click(e) {
    var DepartmentID = $("#DepartmentID").val();
    if (DepartmentID == "undefined" || DepartmentID == "") {
        ASOFT.form.displayError('#HRMF2091', ASOFT.helper.getMessage("00ML000039").f(ASOFT.helper.getLanguageString("HRMF2091.DepartmentID", "HRMF2091", "HRM")));
        $("#btnInherit").parent().addClass('asf-disabled-li');
    }
    else {
        currentChoose = "Inherit";
        var urlChoose = "/PopupSelectData/Index/HRM/HRMF2093?type=1";
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe(urlChoose, {});
    }
}

// Choose value EmployeeID
function ChooseEmployeeID_Click() {
    currentChoose = "EmployeeID";
    var urlChoose = "/PopupSelectData/Index/HRM/OOF2004?ScreenID=HRMF2101&DepartmentID=" + $("#DepartmentID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function receiveResult(result, departmentID) {
    ListChoose[currentChoose](result, departmentID);
}

var ListChoose = {
    "EmployeeID": function (result) {
        var grid = $('#GridEditHRMT2091').data('kendoGrid');
        var selectItem = grid.dataItem(grid.select());
        if (grid.select()) {
            if (selectItem) {
                selectItem.set("EmployeeID", result["EmployeeID"]);
                selectItem.set("EmployeeName", result["EmployeeName"]);
                selectItem.set("DepartmentName", result["DepartmentName"]);
                selectItem.set("DepartmentID", result["DepartmentID"]);
                selectItem.set("DutyName", result["DutyName"]);
            }
            grid.refresh();
        }
    },
    "Inherit": function (result, departmentID) {
        var inheritID1 = "";
        var inheritID2 = "";
        result.forEach(function (value) {
            if (value.InheritID1 != "") {
                inheritID1 += value.InheritID1 + ",";
            }
            if (value.InheritID2 != null && value.InheritID2 != "") {
                inheritID2 += value.InheritID2 + ",";
            }
        });
        if (inheritID1 != "") {
            inheritID1 = inheritID1.substring(0, inheritID1.length - 1);
        }
        if (inheritID2 != "") {
            inheritID2 = inheritID2.substring(0, inheritID2.length - 1);
        }
        $("#InheritID1").val(inheritID1);
        $("#InheritID2").val(inheritID2);
        $('#GridEditHRMT2091').data('kendoGrid').showColumn(1);


        if (departmentID == '%') {
            $("#IsAll").prop('checked', true);
            $($("#IsAll").parent().parent()).addClass('asf-disabled-li');
        } else {
            $("#IsAll").prop('checked', false);
            $($("#IsAll").parent().parent()).removeClass('asf-disabled-li');
            $("#DepartmentID").data("kendoComboBox").value(departmentID);
        }
        chkIsAll_CheckedChaneg(departmentID);
    },
    "AssignedToUser": function (result) {
        $("#AssignedToUserID").val(result.EmployeeID);
        $('#AssignedToUserName').val(result.EmployeeName);
    },
    "Attach": function (result) {

        var $templeteParent = $(".templeteAll"),

            templeteAll = result.map(function (obj) {

                var objFileName = obj.AttachName,

                    objFileID = obj.APK;

                return new templateAttachFile(objFileName, "file-templete", objFileID).getTemplate;
            }),

            parentAttach = $("#Attach").parent(),

            templeteAll = templeteAll.join(""),

            $attach = $("#Attach");

        $templeteParent.remove();

        templeteParent = "<div class='templeteAll'>{0}</div>";

        parentAttach.append(kendo.format(templeteParent, templeteAll));

        var objFileID = result.map(function (obj) {
            return obj.AttachID;
        });

        $attach.val(objFileID.join(',')).trigger("change");

        $(".x-close").unbind("click").bind("click", function () {
            deleteFile($(this));
        });
    }
};

var dataCheck = [];
function CustomerCheck() {
    dataCheck = [];
    var grid = $('#GridEditHRMT2091').data('kendoGrid');
    var grid_tr = $('#GridEditHRMT2091 .k-grid-content tr');
    var dataGrid = grid.dataSource._data;    
    var message = [];
    var messagemaster = [];
    var msg = "{0} Không được là số âm";

    if ($("#AssignedToUserName").val() == 'undefined' || $("#AssignedToUserName").val() == '') {
        messagemaster.push(kendo.format(ASOFT.helper.getMessage('00ML000039'), $(".AssignedToUserName .asf-td-caption label").html()));
        $("#AssignedToUserName").addClass('asf-focus-input-error');
    }
    else {
        $("#AssignedToUserName").removeClass('asf-focus-input-error');
    }

    if (Number($("#ProposeAmount").val()) < 0) {
        messagemaster.push(msg.f(ASOFT.helper.getLanguageString("HRMF2091.ProposeAmount", "HRMF2091", "HRM")));
    }

    if (messagemaster.length > 0) {
        ASOFT.form.displayError("#HRMF2091", messagemaster);
        return true;
    }

    if ($("#IsAll").prop('checked'))
        return false;
    for (var i = 0; i < dataGrid.length; i++) {
        var item = grid.dataSource._data[i];

        // Set gia tri default
        item.DivisionID = $("#EnvironmentDivisionID").val();
        item.DepartmentID = $("#DepartmentID").val();
        item.TrainingProposeID = $("#TrainingProposeID").val();
        if (!item.TransactionID)
            item.TransactionID = "";
        dataCheck.push({
            FromDate: item.FromDate,
            ToDate: item.ToDate,
            ProposeAmount: item.ProposeAmount_DT,
            IsAll: $("#IsAll").prop('checked') ? 1 : 0
        });

        if ($("#InheritID1").val() != "" || $("#InheritID2").val() != "") {
            if (!item.ID || item.ID == "") {
                $($(grid_tr[i]).children()[GetColIndex(grid, "ID")]).addClass('asf-focus-input-error');
                message.push(ASOFT.helper.getMessage('00ML000039').f($($(grid.thead).find('th')[GetColIndex(grid, "ID")]).attr("data-title")));
            }
        } else if (!item.TrainingFieldID || item.TrainingFieldID == "") {
            $($(grid_tr[i]).children()[GetColIndex(grid, "TrainingFieldName")]).addClass('asf-focus-input-error');
            message.push(ASOFT.helper.getMessage('00ML000039').f($($(grid.thead).find('th')[GetColIndex(grid, "TrainingFieldName")]).attr("data-title")));
        }
        if (!item.EmployeeID || item.EmployeeID == '') {
            $($(grid_tr[i]).children()[GetColIndex(grid, "EmployeeID")]).addClass('asf-focus-input-error');
            message.push(ASOFT.helper.getMessage('00ML000039').f($($(grid.thead).find('th')[GetColIndex(grid, "EmployeeID")]).attr("data-title")));
        }
    }

    if (message.length > 0) {        
        ASOFT.form.displayError("#HRMF2091", message);
        return true;
    }

    return false;
}

function CustomerConfirm() {

    var data = {
        isAll: $("#IsAll").prop('checked') ? 1 : 0,
        departmentID: $("#DepartmentID").val(),
        dataCheck: dataCheck
    };
    url = "/HRM/HRMF2090/CheckDataBeforeSave";

    var Confirm = {};
    Confirm.Status = 0;
    ASOFT.helper.postTypeJson(url, data, function (data) {
        if (data && data.data.length > 0 && data.data[0].Status == 1) {
            var mess = data.data[0].Message == "HRMFML000027" ?
                kendo.format(ASOFT.helper.getMessage(data.data[0].Message), data.data[0].TranYear) :
                kendo.format(ASOFT.helper.getMessage(data.data[0].Message), data.data[0].TranQuarter, data.data[0].TranYear);
            Confirm.Status = 1;
            Confirm.Message = data.data[0].Message;
        }
    });
    return Confirm;
}

// Choose Data AssignedToUserID
function btnChooseUserName_Click() {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#EnvironmentDivisionID").val();
    currentChoose = "AssignedToUser";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});

}

// Delete Data AssignedToUserID
function btnDeleteUserNameD_Click() {
    $("#AssignedToUserID").val('');
    $('#AssignedToUserName').val('');
}

function autoCode() {
    var url = "/HRM/HRMF2090/GetVoucherNoText"
    ASOFT.helper.postTypeJson(url, {}, function (result) {
        if (result) {
            $("#TrainingProposeID").val(result)
            oldVoucherNo = result;
        }
    })
}

jQuery("#ProposeAmount").blur(function () {
    var grid = $("#GridEditHRMT2091").data('kendoGrid');
    var length = grid.dataSource.data().length;
    if (length == 0) return;
    grid.dataSource.data().forEach(function (value) {
        value.ProposeAmount_DT = parseFloat($("#ProposeAmount").val()) / length;
    });
    grid.refresh();
});

function GetColIndex(grid, columnName) {
    var columns = grid.columns;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].field == columnName)
            return i;
    }
    return 0;
}

/**  
* Process after insert data
*
* [Kim Vu] Create New [11/12/2017]
**/
function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && ($("#isUpdate").val() != "True")) {
        var url = "/HRM/HRMF2090/UpdateVoucherNo"
        ASOFT.helper.postTypeJson(url, { VoucherNo: oldVoucherNo }, null);
        if (action == 1) {
            $("#HRMF2091")[0].reset();
            $("#GridEditHRMT2091").css('display', 'block');
            $($("#DepartmentID").parent().parent()).removeClass('asf-disabled-li');
            $("#GridEditHRMT2091 .k-grid-content").css('height', '450px');
        }
        autoCode();
    }
}