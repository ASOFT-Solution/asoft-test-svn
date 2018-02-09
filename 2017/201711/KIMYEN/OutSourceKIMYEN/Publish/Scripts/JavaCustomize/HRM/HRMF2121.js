
// #region --- Foreign Methods ---

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

var templateAttachFile = function (textFileName, templateClass, textFileID) {
    this.getTemplate = kendo
        .format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label title='{3}'>{1}</label><label class='x-close'>&#10006</label></div>", templateClass, textFileName.length > 25 ? [textFileName.slice(0, 24), "..."].join("") : textFileName, textFileID, textFileName);
};
var templateAsoftButton = function () {
    this.getAsoftButton = function (buttonClass, buttonID, spanClass, buttonCaption, onclickFunction) {
        return kendo
            .format("<a onclick='{4}' class='k-button k-button-icontext asf-button {0}' id='{1}' data-role='button' role='button' style='min-width:35px; margin-left:5px;' aria-disabled='false' tabindex='0'><span class='asf-button-text {2}'>{3}</span></a>",
                buttonClass,
                buttonID,
                spanClass,
                buttonCaption,
                onclickFunction);
    };

    this.getDeleteAsoftButton = function (buttonID, onclickFunction) {
        return kendo
            .format("<a id='{0}' onclick='{1}' aria-disabled='false' tabindex='0' data-role='button' role='button' style='height: 16px;'><span style='height: 16px' class='k-sprite asf-icon asf-icon-32 asf-i-delete-32 disabledButton'></span></a>",
                buttonID,
                onclickFunction);
    };

    return this;
};

var ListChoose = {
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

        templeteParent = "<div class='templeteAll' style='padding-top: 5px;'>{0}</div>";

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

    var urlPopup3 = "/AttachFile?Type=2";

    SCREEN2121.CurrentChoose = SCREEN2121.ACTION_CHOOSE_ATTACH;

    ASOFT.asoftPopup.showIframe(urlPopup3, {});

    currentChoose = "Attach";
}

function btnDeleteUpload_click(e) {

    $(".templeteAll").remove();

    $("#Attach").val("").trigger("change");
}

function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
};

// #endregion --- Foreign Methods ---
var oldVoucherNo = "";
$(document)
    .ready(function () {

        var templeteButton = new templateAsoftButton(),
            form = $("#sysScreenID"),
            parentSysScreenID = parent.$("#sysScreenID").val();

        //$("#TrainingResultID").attr("readonly", "readonly");

        // #region --- Grid Events ---

        var grid = $('#GridEditHRMT2121').data('kendoGrid');

        // No AddNew row

        $("#GridEditHRMT2121").attr("AddNewRowDisabled", "false");

        $(grid.tbody)
            .on("change",
                "td",
                function (e) {
                    var selectitem = grid.dataItem(grid.select());
                    var column = e.target.id;
                    if (column == 'cbbResultName') {
                        var selectitem = grid.dataItem(grid.select());
                        var id = e.target.value;
                        var combobox = $("#cbbResultName").data("kendoComboBox");
                        if (combobox) {
                            selectitem.ResultName = combobox.dataItem().ResultName;
                            selectitem.ResultID = combobox.dataItem().ResultID;
                        }
                        grid.refresh();
                    } else if (column == 'cbbStatusTypeName') {
                        var item = grid.dataItem(grid.select());
                        var id = e.target.value;
                        var comboboxx = $("#cbbStatusTypeName").data("kendoComboBox");
                        if (comboboxx) {
                            item.StatusTypeName = comboboxx.dataItem().StatusName;
                            item.StatusTypeID = comboboxx.dataItem().StatusID;
                            if (item.StatusTypeID == 0) {
                                item.ResultID = "";
                                item.ResultName = "";
                            }
                        }
                        grid.refresh();
                    }
                });
        grid.bind('dataBound',
            function (e) {
                $("#GridEditHRMT2121")
                    .find('td')
                    .on("focusin",
                        function (e) {
                            var selectitem = grid.dataItem(grid.select());
                            var index = e.delegateTarget.cellIndex;
                            var th = $($("#GridEditHRMT2121").find('th')[index]).attr("data-field");
                            if (th == 'ResultName') {
                                if (selectitem.StatusTypeID && selectitem.StatusTypeID == 0) {
                                    grid.closeCell();
                                }
                            }
                        });
            }
        );
        // #region --- Grid Events ---

        SCREEN2121.SetReadOnlyControl();

        // #region --- Button Events ---

        $('#btnTrainingScheduleName')
            .click(function () {
                SCREEN2121.CurrentChoose = SCREEN2121.ACTION_CHOOSE_TRAININGSCHEDULE;
                var urlChoose = "/PopupSelectData/Index/HRM/HRMF2133";
                ASOFT.asoftPopup.showIframe(urlChoose, {});
            });

        var isUpdate = $('#isUpdate').val() === "True";

        if (!isUpdate) {
            autoCode();
            setTimeout(function () {
                grid.dataSource.data([]);
            }, 0);
        }


        $('#btnAssignedToUserName')
            .click(function () {

                SCREEN2121.CurrentChoose = SCREEN2121.ACTION_CHOOSE_USER;
                ChooseStatus = 4;
                var urlChoose = "/PopupSelectData/Index/HRM/OOF2004?ScreenID=HRMF2121";
                ASOFT.asoftPopup.showIframe(urlChoose, {});
            });

        $("#btnDeleteAssignedToUserName").click(function (e) {
            $("#AssignedToUserName").val('');
            $("#AssignedToUserID").val('');
        });

        $("#btnDeleteTrainingScheduleName").click(function (e) {
            $('#TrainingScheduleName').val('');
            $('#TrainingScheduleID').val('');
            $('#ObjectName').val('');
            $('#TrainingCourseID').val('');
            $('#TrainingFieldName').val('');
            $('#TrainingTypeName').val('');
        });


        // #endregion --- Button Events ---

        // #region --- Attach ---

        $('#Attach').css('display', 'none');
        $('#btnAttach').css('display', 'none');
        $('#btnDeleteAttach').css('display', 'none');
        if ($('#isUpdate').val() != "True") {
            $("#Attach")
                .change(function () {
                    setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click);
                })
                .parent()
                .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") +
                    templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

            $($(".Attach").children()[0]).css("width", "14%");
        }
        else {
            $("#TrainingResultID").attr("readonly", true);
        }

        // #endregion --- Attach ---

        $("#TrainingScheduleName").attr("data-val-required", "The field is required").attr("requaird", "0");
        $("#TrainingScheduleName").removeAttr("disabled").attr("readonly", true).css("background-color", "#dddddd");

        $("#AssignedToUserName").attr("data-val-required", "The field is required").attr("requaird", "0");
        $("#AssignedToUserName").removeAttr("disabled").attr("readonly", true).css("background-color", "#dddddd");;

    });

// HRMF2121 : Ghi nhận kết quả
SCREEN2121 = new function () {

    this.CurrentChoose = "";
    this.ACTION_CHOOSE_TRAININGSCHEDULE = "ACTION_CHOOSE_TRAININGSCHEDULE";
    this.ACTION_CHOOSE_USER = "ACTION_CHOOSE_USER";
    this.ACTION_CHOOSE_ATTACH = "ACTION_CHOOSE_ATTACH";

    this.SetReadOnlyControl = function () {
        $('.TrainingCourseID').addClass('asf-disabled-li');
        $('.TrainingTypeName').addClass('asf-disabled-li');
        $('.TrainingFieldName').addClass('asf-disabled-li');
        $('.ObjectName').addClass('asf-disabled-li');
        $('.Address').addClass('asf-disabled-li');
    };
};

function receiveResult(result) {

    if (SCREEN2121.CurrentChoose == SCREEN2121.ACTION_CHOOSE_TRAININGSCHEDULE) {
        $('#TrainingScheduleName').val(result["TrainingScheduleID"]);
        $('#TrainingScheduleID').val(result["TrainingScheduleID"]);
        $('#ObjectName').val(result["ObjectName"]);
        $('#TrainingCourseID').val(result["TrainingCourseID"]);
        $('#TrainingFieldName').val(result['TrainingFieldName']);
        $('#TrainingTypeName').val(result['TrainingTypeName']);
        var data = {
            TrainingScheduleID: $('#TrainingScheduleID').val()
        };

        $.ajax({
            url: '/HRM/HRMF2120/LoadEmployeeList',
            async: false,
            data: data,
            success: function (result1) {
                var grid = $('#GridEditHRMT2121').data('kendoGrid');
                var datasource = grid.dataSource;
                var a = JSON.parse(result1);
                //  1. Xoa du lieu cu tren grid
                grid.dataSource.data([]);
                // 2. foreach a  insert
                for (var i = 0, len = a.length; i < len; i++) {
                    datasource.insert({
                        EmployeeID: a[i]["EmployeeID"],
                        EmployeeName: a[i]["EmployeeName"],
                        DepartmentID: a[i]["DepartmentID"],
                        DutyName: a[i]["DutyName"] ? a[i]["DutyName"] : '',
                        InheritTransactionID: a[i].InheritTransactionID,
                        InheritID: a[i].InheritID,
                        TrainingScheduleID: a[i].TrainingScheduleID,
                        DepartmentName: a[i].DepartmentName ? a[i].DepartmentName : '',
                        StatusTypeID: a[i].StatusTypeID,
                        ResultID: a[i].ResultID,
                        StatusTypeName: a[i].StatusTypeName,
                        ResultName: a[i].ResultName,
                        TransactionID: '',
                        TrainingResultID: '',
                        DivisionID: $("#EnvironmentDivisionID").val(),
                        Orders: (i + 1)
                    });
                };

                // 3. Kiem tra so dong cua grid 
                // if dong == 0
                // grid add row
                //if (grid._data == 0) {
                //    grid.addRow();
                //}

            }
        });
    }

    // Chọn người phụ trách
    if (SCREEN2121.CurrentChoose == SCREEN2121.ACTION_CHOOSE_USER) {
        if (result) {
            $("#AssignedToUserName").val(result.EmployeeName);
            $("#AssignedToUserID").val(result.EmployeeID);
        }
    }

    // Đính kèm
    if (SCREEN2121.CurrentChoose == SCREEN2121.ACTION_CHOOSE_ATTACH) {
        ListChoose["Attach"](result);
    }
};

// Customer Check
function CustomerCheck() {
    var grid = $('#GridEditHRMT2121').data('kendoGrid');
    var grid_tr = $('#GridEditHRMT2121 .k-grid-content tr');
    var dataGrid = grid.dataSource._data;    
    var message = [];

    if ($("#TrainingScheduleID").val() == 'undefined' || $("#TrainingScheduleID").val() == '') {
        message.push(kendo.format(ASOFT.helper.getMessage('00ML000039'), $(".TrainingScheduleName .asf-td-caption label").html()));
        $("#TrainingScheduleName").addClass('asf-focus-input-error');
    }
    else {
        $("#AssignedToUserName").removeClass('asf-focus-input-error');
    }

    if ($("#AssignedToUserID").val() == 'undefined' || $("#AssignedToUserID").val() == '') {
        message.push(kendo.format(ASOFT.helper.getMessage('00ML000039'), $(".AssignedToUserName .asf-td-caption label").html()));
        $("#AssignedToUserName").addClass('asf-focus-input-error');
    }
    else {
        $("#AssignedToUserName").removeClass('asf-focus-input-error');
    }

    for (var i = 0; i < dataGrid.length; i++) {
        var item = grid.dataSource._data[i];
        // Set gia tri default        
        if (item.StatusTypeName == "") {
            $($(grid_tr[i]).children()[GetColIndex(grid, "StatusTypeName")]).addClass('asf-focus-input-error');
            message.push(ASOFT.helper.getMessage('00ML000039').f($($(grid.thead).find('th')[GetColIndex(grid, "StatusTypeName")]).attr("data-title")));
        }
        if (item.ResultName == "") {
            $($(grid_tr[i]).children()[GetColIndex(grid, "ResultName")]).addClass('asf-focus-input-error');
            message.push(ASOFT.helper.getMessage('00ML000039').f($($(grid.thead).find('th')[GetColIndex(grid, "ResultName")]).attr("data-title")));
        }
    }

    if (message.length > 0) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), message);
        return true;
    }
    return false;
};

function GetColIndex(grid, columnName) {
    var columns = grid.columns;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].field == columnName)
            return i;
    }
    return 0;
}

function autoCode() {
    $.ajax({
        url: '/HRM/HRMF2120/GetVoucherNoText',
        async: false,
        data: {},
        success: function (newKey) {
            $("#TrainingResultID").val(newKey);
            oldVoucherNo = newKey;
        }
    });
}

/**  
* Process after insert data
*
* [Kim Vu] Create New [11/12/2017]
**/
function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 &&
            $("#isUpdate") != "True") {
        var url = "/HRM/HRMF2120/UpdateVoucherNo"
        ASOFT.helper.postTypeJson(url, { VoucherNo: oldVoucherNo }, null);
        autoCode();
    }
}