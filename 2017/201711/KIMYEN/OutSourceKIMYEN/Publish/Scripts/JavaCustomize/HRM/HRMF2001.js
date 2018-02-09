var oldVoucherNo = "";
var
    templateAttachFile = function (textFileName, templeteClass, textFileID) {
        this.getTemplete = kendo.format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label title='{3}'>{1}</label><label class='x-close'>&#10006</label></div>", templeteClass, textFileName.length > 25 ? [textFileName.slice(0, 24), "..."].join("") : textFileName, textFileID, textFileName);
        return this;
    },

    templateAsoftButton = function () {
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

var currentChoose = null;
var ListChoose = {
    "Attach": function (result) {

        var $templeteParent = $(".templeteAll"),

            templeteAll = result.map(function (obj) {

                var objFileName = obj.AttachName,

                    objFileID = obj.APK;

                return new templateAttachFile(objFileName, "file-templete", objFileID).getTemplete;
            }),

            parentAttach = $("#Attach").parent(),

            templeteAll = templeteAll.join(""),

            $attach = $("#Attach");

        $templeteParent.remove();

        templeteParent = "<div class='templeteAll'>{0}</div>";

        parentAttach.append(kendo.format(templeteParent, templeteAll));

        $attach.val(JSON.stringify(result)).trigger("change");

        $(".x-close").unbind("click").bind("click", function () {
            deleteFile($(this));
        });
    }
}

function deleteFile(jqueryObjectClick) {

    var $parentXClose = jqueryObjectClick.parent(),
        $templeteAll = $(".templeteAll"),
        $apkDelete = $parentXClose.attr("id"),
        $attach = $("#Attach"),
        $result = JSON.parse($attach.val()),
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

    var urlTestPopup3 = "/AttachFile?Type=2";

    ASOFT.asoftPopup.showIframe(urlTestPopup3, {});

    currentChoose = "Attach";
}

function btnDeleteUpload_click(e) {

    $(".templeteAll").remove();

    $("#Attach").val("").trigger("change");
}

function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
};

function getResultAfterDelete(result, apkDelete) {

    var $resultAfterDelete = $.map(result, (function (obj) {

        if (obj.APK != apkDelete)
            return obj;
    }));

    return $resultAfterDelete.length > 0 ? $resultAfterDelete : "";
}

$(document)
    .ready(function() {
        var templeteButton = new templateAsoftButton();
        var GridHRMT2001 = $("#GridEditHRMT2001").data("kendoGrid");
        //Load chi phí hiện có, chi phí định biên
        $("#DepartmentID").data("kendoComboBox").bind("change", function (e) {
            LoadDataCostMaster();
        });

        $("#ActualCost").attr("readonly", true);
        $("#CostBoundary").attr("readonly", true);

        $("#Attach")
        .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
        .parent()
        .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

        $("#TotalCost")
            .css({
                "cursor": "not-allowed"
            })
            .focusin(function(e) { $(this).blur(); })
            .prop("readonly", true);

        $(GridHRMT2001.tbody)
            .on("change",
                "td",
                function(e) {
                    var data = null;
                    var column = e.target.id;
                    var selectitem = GridHRMT2001.dataItem(e.currentTarget.parentElement);
                    var cbb = $("#" + column).data("kendoComboBox");
                    if (cbb) {
                        data = cbb.dataItem(cbb.select());
                    }
                    if (column === 'cbbDutyID') {
                        if (data) {
                            ASOFT.form.clearMessageBox();
                            if ($("#DepartmentID").val() != '' && $("#DepartmentID").val() != 'undefined') {
                                selectitem.set('DutyID', data.DutyID)
                                selectitem.set('DutyName', data.DutyName)
                                //get data chi phí, số lượng
                                LoadData(data.DutyID, selectitem);
                                GridHRMT2001.refresh();
                            }
                            else {
                                selectitem.set('DutyID', '')
                                selectitem.set('DutyName', '')
                                ASOFT.form.displayError('#HRMF2001', ASOFT.helper.getMessage('00ML000039').f(ASOFT.helper.getLanguageString("HRMF2001.DepartmentID", "HRMF2001", "HRM")));
                            }
                        }
                    }
                    if (column === 'cbbWorkTypeName') {
                        if (data) {
                            selectitem.set('WorkType', data.ID)
                            selectitem.set('WorkTypeName', data.WorkType)
                        }
                    }
                    if (column === "RecruitCost") {
                        var totalCost = 0;

                        var data = GridHRMT2001.dataSource.data();

                        data.forEach(function(item, index) {
                            if (item.RecruitCost) {
                                totalCost += parseFloat(item.RecruitCost) || 0;
                            }
                        });

                        $("#TotalCost").val(totalCost);
                    }
                    if (column === "Quantity") {
                        var Quantity = Math.round($("#Quantity").val());
                        $("#Quantity").val(Quantity);
                    }
                });

        if ($("#isUpdate").val() == 'False') {
            autoCode();
        }
        
        $(".asf-td-caption").css('width', '35%');
    });

function CustomerCheck() {
    var check = false;
    var message = [];
    $('#' + id + ' .asf-focus-input-error').removeClass('asf-focus-input-error');
    $('#' + id + ' .asf-focus-combobox-input-error').removeClass('asf-focus-combobox-input-error');
    var grid = $("#GridEditHRMT2001").data("kendoGrid");
    var data = [];
    var ToDate = $("#ToDate").data("kendoDatePicker").value();
    var FromDate = $("#FromDate").data("kendoDatePicker").value();
    var DepartmentID = $("#DepartmentID").data("kendoComboBox").value();
    var RecruitPlanID = $("#RecruitPlanID").val();
    var TotalCost = $("#TotalCost").val();
    for (i = 0 ; i < grid.dataSource.data().length; i++) {
        var itemGrid = grid.dataSource.at(i);
        data.push({
            RecruitPlanID: RecruitPlanID,
            DutyID: itemGrid.DutyID,
            DepartmentID: DepartmentID,
            FromDate: FromDate,
            ToDate: ToDate,
            Quantity: itemGrid.Quantity,
            RecruitCost: itemGrid.RecruitCost
        });
        //var tr = grid.tbody.find('tr')[i];
        //$($(tr).find('td')[1]).addClass('asf-focus-input-error');
        //message.push(ASOFT.helper.getMessage('PAML000002').f($($(grid.thead).find('th')[1]).attr("data-title")));
        //check = true;
    }

    ASOFT.helper.postTypeJson("/HRMF2000/CheckDuplicateRequireRecruit", data, function (result) {
        result = JSON.parse(result);
        if (result == false) {
            check = false;
        }
        if (result) {
            for (i = 0; i < grid.dataSource.data().length; i++) {
                var itemGrid = grid.dataSource.at(i);
                if (result.dataDuplicateRecruitDate && result.dataDuplicateRecruitDate.length > 0)
                {
                    for (j = 0; j < result.dataDuplicateRecruitDate.length; j++) {
                        if (itemGrid.get("DutyID") == result.dataDuplicateRecruitDate[j].DutyID) {
                            var tr = grid.tbody.find('tr')[i];
                            $($(tr).find('td')[1]).addClass('asf-focus-input-error');
                            message.push(ASOFT.helper.getMessage(result.dataDuplicateRecruitDate[j].MessageID).f($($(grid.thead).find('th')[1]).attr("data-title")));
                            check = true;
                        }
                    }
                }
                if (result.dataRequireRecruit && result.dataRequireRecruit.length > 0) {
                    for (e = 0; e < result.dataRequireRecruit.length; e++) {
                        if(itemGrid.get("DutyID") == result.dataRequireRecruit[e].DutyID)
                        {
                            var tr = grid.tbody.find('tr')[i];
                            $($(tr).find('td')[1]).addClass('asf-focus-input-error');
                            if (result.dataRequireRecruit[e].Status_Quantity == 1) {
                                message.push(ASOFT.helper.getMessage("HRMFML000018").f($($(grid.thead).find('th')[1]).attr("data-title")))
                                
                            }
                            if (result.dataRequireRecruit[e].Status_Cost == 1) {
                                message.push(ASOFT.helper.getMessage("HRMFML000019").f($($(grid.thead).find('th')[1]).attr("data-title")))
                            }
                            check = true;
                        }
                    }
                }
            }
        }
        console.log(result);
    }, function (err) {
        console.log(err);
    })

    if (message.length > 0) {
        ASOFT.form.displayMessageBox("form#" + id, message);
    }

    var fromdatestr = $("#FromDate").val(), date1 = fromdatestr.split("/");
    var todatestr = $("#ToDate").val(), date2 = todatestr.split("/");
    var fromdate = new Date(date1[2], date1[1] - 1, date1[0]);
    var todate = new Date(date2[2], date2[1] - 1, date2[0]);
    if (fromdate > todate) {
        ASOFT.form.displayError('#' + $('#sysScreenID').val(), ASOFT.helper.getMessage('OOFML000022'));
        return true;
    }
    return check;
}

/**  
* Process after insert data
* [Kieu Nga] Create New [12/12/2017]
**/
function autoCode() {
    var urlTest = "/HRM/Common/GetVoucherNoText";
    //! Store một số trường hợp dùng Mã màn hình
    ASOFT.helper.postTypeJson(urlTest,
        { tableID: "HRMF2001" },
        function(result) {
            if (result) {
                $("#RecruitPlanID").val(result);
                oldVoucherNo = result;
            }
        });
}

/**  
* Process after insert data
*
* [Kieu Nga] Create New [12/12/2017]
**/
function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && ($("#isUpdate") != "True")) {
        //! Store một số trường hợp dùng Mã màn hình
        var urlTest = "/HRM/Common/UpdateVoucherNo";
        ASOFT.helper.postTypeJson(urlTest, { VoucherNo: oldVoucherNo, tableID: "HRMF2001" }, null);
        autoCode();
    }
}

/**  
* get data số lượng, chi phí
* [Thanh Trong] Create New [29/12/2017]
**/
function LoadData(dutyid, gridRow) {
    var data = {
        Mode:0,
        DutyID:dutyid,
        DepartmentID: $("#DepartmentID").val(),
        FromDate: $("#FromDate").val(),
        ToDate: $("#ToDate").val(),
        RecruitPlanID: $("#RecruitPlanID").val()
    };
    $.ajax({
        url: "/HRM/HRMF2001/LoadData",
        async: false,
        data: data,
        success: function(result) {
            var record = JSON.parse(result);

            if (record == undefined || record.length == 0) return;
            gridRow.ActualQuantity = record[0]["ActualQuantity"];
            gridRow.QuantityBoundary = record[0]["QuantityBoundary"];
        }
    });
}

function LoadDataCostMaster() {
    var data = {
        Mode: 0,
        DutyID:"",
        DepartmentID: $("#DepartmentID").val(),
        FromDate: $("#FromDate").val(),
        ToDate: $("#ToDate").val(),
        RecruitPlanID: $("#RecruitPlanID").val()
    };
    $.ajax({
        url: "/HRM/HRMF2001/LoadData",
        async: false,
        data: data,
        success: function(result) {
            var record = JSON.parse(result);

            if (record == undefined || record.length == 0) return;

            $("#CostBoundary").val(record[0]["CostBoundary"]);
            $("#ActualCost").val(record[0]["ActualCost"]);
        }
    });
}