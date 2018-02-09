function onAfterInsertSuccess(result, action) {
    if (action == 3 && result.Status == 0) {
        var url = parent.GetUrlContentMaster();
        var listSp = url.split('&');
        var division = listSp[listSp.length - 1];
        if ($("#IsCommon").is(':checked')) {
            url = url.replace(division, "DivisionID=" + "@@@");
        }
        else {
            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
        }
        window.parent.parent.location = url
        parent.setReload()
    }
    else if (action != 3 && result.Status == 0 && ($("#isUpdate").val() != "True")) {
        autoCode(false);
        this.ProcessSendEmail();
    }
}
function formatDate(date) {
    var monthNames = [
      "01", "02", "03",
      "04", "05", "06", "07",
      "08", "09", "10",
      "11", "12"
    ];

    var day = date.getDate();
    var monthIndex = date.getMonth();
    var year = date.getFullYear();

    return day + '/' + monthNames[monthIndex] + '/' + year;
}

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

        return this;0
    };

var currentChoose = null;
var ListChoose = {
    "ChooseAssigned": function (result) {
        $("#AssignedToUserID").val(result.EmployeeID);
        $("#AssignedToUserName").val(result.EmployeeName);
    }
}


function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
};


$(document)
    .ready(function () {
        var isUpdate = $('#isUpdate').val() === "True";

        autoCode(isUpdate);

        var templeteButton = new templateAsoftButton();

        //$("#TrainingPlanID")
        //    .css({
        //        "cursor": "not-allowed"
        //    })
        //    .focusin(function(e) { $(this).blur() });

        $("#AssignedToUserName")
            .css({
                "width": "75%",
                "background-color": "#d0c9c9",
                "cursor": "not-allowed"
            })
            .focusin(function(e) { $(this).blur() })
            .parent()
            .append(templeteButton.getAsoftButton("", "btnAssigned", "", "...", "btnChooseAssigned_click()") +
                templeteButton.getDeleteAsoftButton("btnDeleteAssigned", "btnDeleteAssigned_click()"));

        var GridHRMT2071 = $("#GridEditHRMT2071").data("kendoGrid")

        GridHRMT2071.bind("edit",
            function(e) {
                if (e.container.context.cellIndex == 2 && e.model.IsAll == 1) {
                    e.sender.closeCell()
                }
            })


        $(GridHRMT2071.tbody)
            .on("change",
                "td",
                function(e) {
                    var data = {};
                    var column = e.target.id;
                    var selectitem = GridHRMT2071.dataItem(e.currentTarget.parentElement)
                    var cbb = $("#" + column).data("kendoComboBox")
                    if (cbb) {
                        data = cbb.dataItem(cbb.select())
                    }
                    switch (column) {
                    case "cbbRepeatTimeName":
                    {
                        selectitem.set('RepeatTimeName', data.RepeatTimeName)
                        selectitem.set('RepeatTime', data.RepeatTime)
                        break;
                    }
                    case "cbbRepeatTypeName":
                    {
                        selectitem.set('RepeatTypeName', data.RepeatTypeName)
                        selectitem.set('RepeatTypeID', data.RepeatTypeID)
                        break;
                    }
                    case "cbbDepartmentName":
                    {
                        selectitem.set('DepartmentName', data.DepartmentName)
                        selectitem.set('DepartmentID', data.DepartmentID)
                        break
                    }
                    case "cbbTrainingFieldName":
                    {
                        selectitem.set('TrainingFieldName', data.TrainingFieldName)
                        selectitem.set('TrainingFieldID', data.TrainingFieldID)
                        break
                    }
                    case "CbGridEdit_IsAll":
                    {
                        var check = e.target.checked
                        selectitem.set('IsAll', check ? 1 : 0)
                        if (check) {
                            selectitem.set("CurrentDepartmentID", selectitem.get("DepartmentID"))
                            selectitem.set("CurrentDepartmentName", selectitem.get("DepartmentName"))
                            selectitem.set("DepartmentID", "%")
                            selectitem.set("DepartmentName", "")
                        } else {
                            selectitem.set("DepartmentID", selectitem.get("CurrentDepartmentID"))
                            selectitem.set("DepartmentName", selectitem.get("CurrentDepartmentName"))
                        }
                    }
                    }

                });

    });

function onCheckGridEdit(posGrid, key, tag) {
    return $(tag).is(":checked");
}


function btnChooseAssigned_click(e) {

    var urlPopup = '/PopupSelectData/Index/00/CMNF9003?DivisionID=' + ASOFTEnvironment.DivisionID;

    ASOFT.form.clearMessageBox();

    ASOFT.asoftPopup.showIframe(urlPopup, {});

    currentChoose = "ChooseAssigned";
}

function btnDeleteAssigned_click(e) {

    $("#AssignedToUserID").val("");

    $("#AssignedToUserName").val("");
}


function CustomerCheck() {

    var grid = $("#GridEditHRMT2071").data("kendoGrid")
    var message = [];

    for (i = 0; i < grid.dataSource.data().length; i++) {
        var itemGrid = grid.dataSource.at(i)
        var isAll = itemGrid.get("IsAll")
        if (isAll) {
            continue
        }
        var hasError = true
        if (itemGrid.get("DepartmentID")) {
            itemGrid.set("Orders", i)
            hasError = false
        }
        if (hasError) {
            var tr = grid.tbody.find('tr')[i];
            $($(tr).find('td')[2]).addClass('asf-focus-input-error')
            message.push(ASOFT.helper.getMessage("00ML000039").f($($(grid.thead).find('th')[2]).attr("data-title")))
        }

    }

    if (message.length > 0) {
        ASOFT.form.displayMessageBox("form#" + id, message)
    }

    return hasError

}


function autoCode(isUpdate) {

    if (!isUpdate) {
        var url = "/HRM/HRMF2070/GetVoucherNoText";
        var data = {
            tableID: "HRMT2070"
        }

        ASOFT.helper.postTypeJson(url,
            data,
            function(result) {
                if (result) {
                    $("#TrainingPlanID").val(result);
                }
            });
    }
};

function ProcessSendEmail() {
    var url = "/SendMail";
    ASOFT.asoftPopup.showIframe(url, {});
}

