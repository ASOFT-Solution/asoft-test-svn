// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #    06/11/2017  Văn Tài         Create New
// ##################################################################

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

    SCREEN2131.CurrentChoose = SCREEN2131.ACTION_CHOOSE_ATTACH;

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

$(document)
    .ready(function () {

        var templeteButton = new templateAsoftButton(),
           form = $("#sysScreenID"),
           parentSysScreenID = parent.$("#sysScreenID").val();

        SCREEN2131.isUpdate = $('#isUpdate').val() === "True";
        SCREEN2131.isInherit = $('#isInherit').val() === "True";

        if (!SCREEN2131.isUpdate) { // Add New
            SCREEN2131.GenTrainingCostID();
        } 

        // #region --- Events ---

        GRID_AUTOCOMPLETE.config({
            gridName: 'GridEditHRMT2131',
            inputID: 'autocomplete-box',
            autoSuggest: false,
            serverFilter: true,
            NameColumn: "EmployeeID",
            setDataItem: function (selectedRowItem, dataItem) {
                selectedRowItem.container.parent().css('background', '')
                selectedRowItem.model.set("EmployeeID", dataItem.EmployeeID);
                selectedRowItem.model.set("EmployeeName", dataItem.EmployeeName);
            }
        });

        // Các sự kiện
        SCREEN2131.AllEvents();

        // #endregion --- Events ---

        // #region --- After Loading ---

        $("#TrainingCourseID").attr("readonly", "readonly");
        $("#TrainingFieldID").attr("readonly", "readonly");
        $("#TrainingType").attr("readonly", "readonly");
        $("#ObjectName").attr("readonly", "readonly");
        $("#Address").attr("readonly", "readonly");

        $("#GridEditHRMT2131").attr("AddNewRowDisabled", "false");

        // #endregion --- After Loading ---

        // #region --- Attach ---

        $('#Attach').css('display', 'none');
        $('#btnAttach').css('display', 'none');
        $('#btnDeleteAttach').css('display', 'none');

        if ($('#isUpdate').val() != "True") {
            $("#Attach")
                .change(function() {
                    setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click);
                })
                .parent()
                .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") +
                    templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

            $($(".Attach").children()[0]).css("width", "14%");
        } else {
            $("#TrainingCostID").attr("readonly", true);
            $('#Attach').remove();
            $('.Attach').remove();
            $('#btnAttach').remove();
            $('#btnDeleteAttach').remove();
        }

        // #endregion --- Attach ---
    });

// HRMF2131 : Ghi nhận chi phí
SCREEN2131 = new function () {
    this.CurrentChoose = "";
    this.ACTION_CHOOSE_USER = "ACTION_CHOOSE_USER";
    this.ACTION_CHOOSE_EMPLOYEE = "ACTION_CHOOSE_EMPLOYEE";
    this.ACTION_CHOOSE_ATTACH = "ACTION_CHOOSE_ATTACH";
    this.ACTION_CHOOSE_TRAININGSCHEDULE = "ACTION_CHOOSE_TRAININGSCHEDULE";

    this.isUpdate = false;
    this.isInherit = false;

    this.oldID = "";

    /**
    * Gen mã tự động
    * @returns {} 
    * @since [Văn Tài] Created [27/11/2017]
    */
    this.GenTrainingCostID = function() {
        //Xử lý Gen động
        var url = "/HRM/Common/GetVoucherNoText";
        ASOFT.helper.postTypeJson(url,
            { tableID: "HRMF2130" },
            function(result) {
                if (result) {
                    $("#TrainingCostID").val(result);
                    SCREEN2131.oldID = result;
                }
            });
    };

    /**
     * Gen lại mã mới
     * @returns {} 
     * @since [Văn Tài] Created [25/12/2017]
     */
    this.ReGenTrainingCostID = function() {
        var oldID = SCREEN2131.oldID;
        var url = "/HRM/Common/UpdateVoucherNo";
        ASOFT.helper.postTypeJson(url, { VoucherNo: oldID, tableID: "HRMF2130" }, null);
        SCREEN2131.GenTrainingCostID();
    };

    /**
     * Xử lý sự kiện cho các Controls
     * @returns {} 
     * @since [Văn Tài] Created [11/12/2017]
     */
    this.AllEvents = function () {

        $('#btnTrainingSchedule')
         .click(function () {
             SCREEN2131.CurrentChoose = SCREEN2131.ACTION_CHOOSE_TRAININGSCHEDULE;

             var urlChoose = "/PopupSelectData/Index/HRM/HRMF2133";
             ASOFT.form.clearMessageBox();
             ASOFT.asoftPopup.showIframe(urlChoose, {});
         });

        // Chọn người phụ trách
        $('#btnAssignedToUser')
           .click(function () {

               SCREEN2131.CurrentChoose = SCREEN2131.ACTION_CHOOSE_USER;
               var urlChoose = "/PopupSelectData/Index/HRM/OOF2004?ScreenID=HRMF2131";
               ASOFT.form.clearMessageBox();
               ASOFT.asoftPopup.showIframe(urlChoose, {});
           });

        // Xóa lịch đào tạo
        $("#btnDeleteTrainingSchedule")
            .click(function () {
                $("#TrainingScheduleID").val("");
                $("#TrainingSchedule").val("");

                var grid = $("#GridEditHRMT2131").data("kendoGrid");
                grid.dataSource.data([]);
            });

        // Xóa người phụ trách
        $("#btnDeleteAssignedToUser")
            .click(function () {
                $("#AssignedToUser").val("");
                $("#AssignedToUserID").val("");
            });

        // Grid
        var grid = $('#GridEditHRMT2131').data('kendoGrid');
        // Focus Out
        $(grid.tbody).bind("focusout", "td", function (e) {
            var column = e.target.id;
            var selectedRow = grid.dataItem(grid.select());
            if (column == "CostAmountHRMT2131") {
                var totalCostAmount = 0;
                grid.dataSource.data().forEach(function (value) {
                    if (selectedRow == value) {
                        totalCostAmount += parseFloat($("#CostAmountHRMT2131").val());
                    } else {
                        totalCostAmount += parseFloat(value.CostAmount);
                    }
                });
                $("#CostAmount").data('kendoNumericTextBox').value(totalCostAmount);
                return;
            }
        });

        // Textbox Chi phí
        jQuery("#CostAmount").blur(function () {
            SCREEN2131.CostAmountOnChange();
        });
    };

    /**
     * Chi phí thay đổi giá trị
     * @returns {} 
     * @since [Văn Tài] Created [11/12/2017]
     */
    this.CostAmountOnChange = function () {
        var grid = $('#GridEditHRMT2131').data('kendoGrid');
        var length = grid.dataSource.data().length; 
        if (length == 0) return;

        // Kiểm tra undefined và rỗng
        if (typeof ($("#CostAmount").val()) == "undefined" || $("#CostAmount").val() == "") $("#CostAmount").data('kendoNumericTextBox').value(0);
        grid.dataSource.data().forEach(function (value) {
            value.CostAmount = parseInt(parseFloat($("#CostAmount").val()) / length);
        });
        grid.refresh();
    }
}

function receiveResult(result) {

    // Chọn lịch đào tạo
    if (SCREEN2131.CurrentChoose == SCREEN2131.ACTION_CHOOSE_TRAININGSCHEDULE) {
        $("#TrainingScheduleID").val(result["TrainingScheduleID"]);
        $("#TrainingSchedule").val(result["TrainingScheduleID"]);
        $("#TrainingCourseID").val(result["TrainingCourseID"]);
        $("#TrainingTypeName").val(result["TrainingTypeName"]);
        $("#TrainingFieldName").val(result["TrainingFieldName"]);
        $("#ObjectName").val(result["ObjectName"]);

        //Đổ nguồn cho lưới khi chọn lịch đào tạo
        var data = {
            TrainingScheduleID: $("#TrainingScheduleID").val(),
        }
        $.ajax({
            url: '/HRM/HRMF2131/LoadGrid',
            async: false,
            data: data,
            success: function (receiveData) {
                var grid = $("#GridEditHRMT2131").data("kendoGrid");
                var datasource = grid.dataSource;
                var data = JSON.parse(receiveData);
                //Xóa lưới
                grid.dataSource.data([]);
                //insert dữ liệu cho lưới
                for (i = 0, len = data.length; i < len; i++) {
                    datasource.insert({
                        Orders: i + 1,
                        EmployeeID: data[i]["EmployeeID"],
                        EmployeeName: data[i]["EmployeeName"],
                        DepartmentName: data[i]["DepartmentName"],
                        DutyName: data[i]["DutyName"],
                        InheritTransactionID: data[i]["InheritTransactionID"],
                        InheritID: data[i]["InheritID"],
                        TransactionID: data[i]["InheritTransactionID"],
                        TrainingCostID: ''
                    });
                };
                //Kiểm tra sô dòng lưới
                if (grid._data == 0) {
                    grid.addRow();
                }

                SCREEN2131.CostAmountOnChange();
            }
        });
    }

    // Chọn người phụ trách
    if (SCREEN2131.CurrentChoose == SCREEN2131.ACTION_CHOOSE_USER) {
        if (result) {
            $("#AssignedToUser").val(result.EmployeeName);
            $("#AssignedToUserID").val(result.EmployeeID);
        }
    }

    // Đính kèm
    if (SCREEN2131.CurrentChoose == SCREEN2131.ACTION_CHOOSE_ATTACH) {
        ListChoose["Attach"](result);
    }
}

/**
 * Xử lý sau khi xử lý lưu
 * @param {} result 
 * @param {} action 
 * @returns {} 
 * @since [Văn Tài] Created [30/11/2017]
 */
function onAfterInsertSuccess(result, action) {
    if (result.Status == 1) return;
    switch (action) {
        case 1://save new                
            {
                // Gen mã mới
                if (!(SCREEN2131.isUpdate)) {
                    SCREEN2131.ReGenTrainingCostID();
                }
                $("#TrainingSchedule").val("");
                $("#TrainingScheduleID").val("");
                $("#AssignedToUser").val("");
                $("#AssignedToUserID").val("");
                $("#btnDeleteUpload").trigger("click");
            }
            break;
        case 2://save copy
            {
                // Gen mã mới
                if (!(SCREEN2131.isUpdate)) {
                    SCREEN2131.ReGenTrainingCostID();
                }
            }
            break;
    }
}