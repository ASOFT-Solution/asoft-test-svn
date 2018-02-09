var DivTag2block = "<div class='asf-filter-main' id='{0}' style = 'padding: 0px'>" +
        "<div class='block-left'>" +            
            "<div class='asf-filter-input' style = 'float:left'></div>" +
        "</div>" +
        "<div class='block-right'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
    "</div>";
var btnInherit =
    "<a class='k-button-icontext asf-button k-button' id='btnInherit' data-role='button' role='button' aria-disabled='false' tabindex='0' style = 'min-width:27px'><span class='asf-button-text'>...</span></a>";
var newRow = "<tr class={0}><td class ='asf-td-caption'></td><td class = 'asf-td-field'></td></tr>";
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
        gridName: 'GridEditHRMT2101',
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

    // Layout control
    // RecruitPeriodID
    $($(".FromDate").find('td')[1]).addClass('asf-td-field');
    var fromDate = $($(".FromDate").children()[1]).children();
    $(".FromDate .asf-td-field").append(kendo.format(DivTag2block, "divFromTodate"));
    $('#divFromTodate .block-left .asf-filter-input').append(fromDate);
    $('#divFromTodate .block-right .asf-filter-label').append($(".ToDate").children()[0]);
    $('#divFromTodate .block-right .asf-filter-input').append($($(".ToDate").children()[0]).children());
    $(".FromDate .asf-td-caption").css('vertical-align', 'inherit');

    $(".AssignedToUserName").after(kendo.format(newRow, "btnInherit"));
    $(".btnInherit .asf-td-field").append(btnInherit);
    $(".btnInherit .asf-td-caption").append(ASOFT.helper.getLanguageString("HRMF2101.Inherit", "HRMF2101", "HRM"));

    $("#btnInherit").bind('click', btnInherit_Click);

    // Add event change for combo TrainingCourseID
    var cboTrainingCourseID = $("#TrainingCourseID").data("kendoComboBox");
    if (cboTrainingCourseID) {
        cboTrainingCourseID.bind('change', function () {
            var data = cboTrainingCourseID.dataItem();
            if (data) {                
                $("#TrainingTypeName").val(data["TrainingTypeName"]);
                $("#ObjectName").val(data["ObjectName"]);
                $("#Address").val(data["Address"]);
            }
        });
    }

    var TrainingFieldID = $("#TrainingFieldID").data("kendoComboBox");
    if (TrainingFieldID) {
        TrainingFieldID.bind('change', function () {
            var data = TrainingFieldID.dataItem();
            $("#btnInherit").parent().removeClass('asf-disabled-li');
            $(".asf-message").remove();
        });
    }

    // Set readonly control
    $("#TrainingTypeName").attr('readonly', 'readonly');
    $("#ObjectName").attr('readonly', 'readonly');
    $("#Address").attr('readonly', 'readonly');

    // Check required AssignedToUserName
    $("#AssignedToUserName").attr("data-val-required", "The field is required").attr("requaird", "0");
    $("#AssignedToUserName").removeAttr("disabled").attr("readonly", true).css("background-color", "#dddddd");;

    $("#btnAssignedToUserName").bind('click', btnChooseUserName_Click);
    $("#btnDeleteAssignedToUserName").bind('click', btnDeleteUserNameD_Click);

    // Event checkbox change    
    var grid = $("#GridEditHRMT2101").data('kendoGrid');

    if ($("#isUpdate").val() == 'True') {
        $($("#IsAll").parent().parent()).addClass('asf-disabled-li');
        IsAll_CheckedChange(null);
        $('.Attach').css('display', 'none');

        $("#TrainingScheduleID").attr("readonly", true);
        $("#btnInherit").parent().addClass('asf-disabled-li');
        $("#TrainingFieldID").parent().addClass('asf-disabled-li');
    } else {
        grid.hideColumn(1);
        $("#Attach")
           .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
           .parent()
           .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));
        $($(".Attach").children()[0]).css("width", "14%");
        autoCode();
        $('#Attach').css('display', 'none');
        $("#IsAll").bind('click', IsAll_CheckedChange);
    }

    // Add event grid
    $(grid.tbody).bind("focusout", "td", function (e) {
        var column = e.target.id;
        var selectedRow = grid.dataItem(grid.select());
        if (column == "ScheduleAmount_DT") {            
            var totalScheduleAmount = 0;
            grid.dataSource.data().forEach(function (value) {
                if (selectedRow == value) {
                    totalScheduleAmount += parseFloat($("#ScheduleAmount_DT").val());
                } else {
                    totalScheduleAmount += parseFloat(value.ScheduleAmount_DT);
                }
            });
            $("#ScheduleAmount").data('kendoNumericTextBox').value(totalScheduleAmount);
            return;
        }
    });
});

jQuery("#ScheduleAmount").blur(function () {
    var grid = $("#GridEditHRMT2101").data('kendoGrid');
    var length = grid.dataSource.data().length;
    if (length == 0) return;
    grid.dataSource.data().forEach(function (value) {
        value.ScheduleAmount_DT = parseFloat($("#ScheduleAmount").val()) / length;
    });
    grid.refresh();
});

//Inherit đề xuất đào tạo
function btnInherit_Click(e) {
    var TrainingFieldID = $("#TrainingFieldID").val();
    if (TrainingFieldID == "undefined" || TrainingFieldID == "") {
        ASOFT.form.displayError('#HRMF2101', ASOFT.helper.getMessage("00ML000039").f(ASOFT.helper.getLanguageString("HRMF2101.TrainingFieldID", "HRMF2101", "HRM")));
        $("#btnInherit").parent().addClass('asf-disabled-li');
    }
    else {
        currentChoose = "Inherit";
        var urlChoose = "/PopupSelectData/Index/HRM/HRMF2103?ScreenID=HRMF2101&type=1";
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe(urlChoose, {});
    }
}

// Choose value EmployeeID
function ChooseEmployeeID_Click() {
    currentChoose = "EmployeeID";
    var urlChoose = "/PopupSelectData/Index/HRM/OOF2004?ScreenID=HRMF2101";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

// Receive result from popup
function receiveResult(result, isAll) {
    ListChoose[currentChoose](result, isAll);
}

function receiveResultVersion2(result, isAll) {
    ListChoose[currentChoose](result, isAll);
}

// Event choose data from popup
var ListChoose = {    
    "EmployeeID": function (result) {
        var grid = $('#GridEditHRMT2101').data('kendoGrid');
        var selectItem = grid.dataItem(grid.select());
        var length = grid.dataSource.data().length;
        if (grid.select()) {
            if (selectItem) {
                selectItem.EmployeeID = result["EmployeeID"];
                selectItem.EmployeeName = result["EmployeeName"];
                selectItem.DepartmentName = result["DepartmentName"];
                selectItem.DepartmentID = result["DepartmentID"];
                selectItem.DutyName = result["DutyName"];
            }
            grid.refresh();
        }
        //Update ScheduleAmount
        if (selectItem.ScheduleAmount_DT == "" || selectItem.ScheduleAmount_DT == undefined) {
            grid.dataSource.data().forEach(function (value) {
                value.ScheduleAmount_DT = parseFloat($("#ScheduleAmount").val()) / length;
            });
            grid.refresh();
        }
    },
    "Inherit": function (results, isAll) {
        if (isAll == 1) {
            $("#IsAll").prop('checked', true);
            $("#TrainingProposeID").val(results[0].TrainingProposeID);
        } else {
            $("#IsAll").prop('checked', false);
            var grid = $("#GridEditHRMT2101").data('kendoGrid');
            grid.dataSource.data([]);            
            var data = [];
            for (var i = 0; i < results.length; i++) {               
                var item = {};
                item.InheritID = results[i].InheritID;
                item.EmployeeID = results[i].EmployeeID;
                item.EmployeeName = results[i].EmployeeName;
                item.DepartmentID = results[i].DepartmentID;
                item.DepartmentName = results[i].DepartmentName;
                item.DutyName = results[i].DutyName;
                item.FromDate_DT = results[i].FromDate;
                item.ToDate_DT = results[i].ToDate;
                item.InheritTransactionID = results[i].InheritTransactionID;
                data.push(item);
            }
            grid.showColumn(1);
            grid.dataSource.data(data);
        }
        $($("#IsAll").parent().parent()).addClass('asf-disabled-li');
        IsAll_CheckedChange(null);
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

// Customer Check
function CustomerCheck() {
    var grid = $('#GridEditHRMT2101').data('kendoGrid');
    var grid_tr = $('#GridEditHRMT2101 .k-grid-content tr');
    var dataGrid = grid.dataSource._data;
    if (dataGrid.length == 0 && !$("#IsAll").prop('checked')) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage("00ML000061")], null);
        return true;
    }
    var message = [];
    if ($("#AssignedToUserName").val() == 'undefined' || $("#AssignedToUserName").val() == '') {
        message.push(kendo.format(ASOFT.helper.getMessage('00ML000039'), $(".AssignedToUserName .asf-td-caption label").html()));
        $("#AssignedToUserName").addClass('asf-focus-input-error');
    }
    else {
        $("#AssignedToUserName").removeClass('asf-focus-input-error');
    }

    for (var i = 0; i < dataGrid.length; i++) {
        var item = grid.dataSource._data[i];
        // Set gia tri default
        item.DivisionID = $("#EnvironmentDivisionID").val();
        item.TrainingScheduleID = $("#TrainingScheduleID").val();
        if(!item.TransactionID)
            item.TransactionID = "";
        item.IsAll = $("#IsAll").prop('checked') ? 1 : 0;
        if (item.EmployeeID == "" || !item.EmployeeID) {
            $($(grid_tr[i]).children()[GetColIndex(grid, "EmployeeID")]).addClass('asf-focus-input-error');
            message.push(ASOFT.helper.getMessage('00ML000039').f($($(grid.thead).find('th')[GetColIndex(grid, "EmployeeID")]).attr("data-title")));
        }
    }

    //check từ ngày phải nhỏ hơn đến ngày
    var messageMaster = [];
    var fromdatestr = $("#FromDate").val(), date1 = fromdatestr.split("/");
    var todatestr = $("#ToDate").val(), date2 = todatestr.split("/");
    var fromdate = new Date(date1[2], date1[1] - 1, date1[0]);
    var todate = new Date(date2[2], date2[1] - 1, date2[0]);
    var ScheduleAmount = $("#ScheduleAmount").val();
    var ProposeAmount_MT = $("#ProposeAmount_MT").val();

    if (fromdate > todate) {
        messageMaster.push(ASOFT.helper.getMessage('OOFML000022'));
    }
    var msgg = "{0} không được là số âm";
    if (Number(ScheduleAmount) < 0) {
        messageMaster.push(msgg.f(ASOFT.helper.getLanguageString("HRMF2101.ScheduleAmount", "HRMF2101", "HRM")))
    }

    if (Number(ProposeAmount_MT) < 0) {
        messageMaster.push(msgg.f(ASOFT.helper.getLanguageString("HRMF2101.ProposeAmount_MT", "HRMF2101", "HRM")))
    }

    if (messageMaster.length > 0) {
        ASOFT.form.displayError('#' + $('#sysScreenID').val(), messageMaster);
        return true;
    }
    if ((message.length > 0 && !$("#IsAll").prop('checked'))) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), message);
        return true;
    }
    return false;
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

// Event IsAll checked change
function IsAll_CheckedChange(e) {
    if ($("#IsAll").prop('checked')) {
        $("#GridEditHRMT2101").css('display', 'none');        
    } else {
        $("#GridEditHRMT2101").css('display', 'block');
    }
}

function GetColIndex(grid, columnName) {
    var columns = grid.columns;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].field == columnName)
            return i;
    }
    return 0;
}

/**  
* Process auto Code
*
* [Kim Vu] Create New [11/12/2017]
**/
function autoCode() {
    var url = "/HRM/HRMF2100/GetVoucherNoText"
    ASOFT.helper.postTypeJson(url, {}, function (result) {
        if (result) {
            $("#TrainingScheduleID").val(result)
            oldVoucherNo = result;
        }
    })
}

/**  
* Process after insert data
*
* [Kim Vu] Create New [11/12/2017]
**/
function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && ($("#isUpdate").val() != "True")) {
        var url = "/HRM/HRMF2100/UpdateVoucherNo"
        ASOFT.helper.postTypeJson(url, { VoucherNo: oldVoucherNo }, null);
        this.autoCode();
        this.ProcessSendEmail();
    }
}

/**  
* Call Form Send Email
*
* [Kim Vu] Create New [11/12/2017]
**/
function ProcessSendEmail() {
    var url = "/SendMail";
    ASOFT.asoftPopup.showIframe(url, {});
}

/**  
* Get data Send Mail
*
* [Kim Vu] Create New [11/12/2017]
**/
function customSendMail() {
    var dataSet = {};
    var url = "/HRM/Common/GetUsersSendMail"
    ASOFT.helper.postTypeJson(url, { formID: 'HRMF2101', departmentID: '%' }, function (result) {
        dataSet.EmailToReceiver = result;
    });
    return dataSet;
}


