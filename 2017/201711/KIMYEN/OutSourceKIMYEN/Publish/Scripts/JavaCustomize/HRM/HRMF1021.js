var DivTag2block = "<div class='asf-filter-main' id='{0}'>" +
        "<div class='block-left'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
        "<div class='block-right'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
    "</div>";
var DivTag1block = "<div class='asf-filter-main' id='{0}'>" +
        "<div class='block-left' style ='width: 100%;'>" +
            "<div class='asf-filter-label'  style ='width: 20%;'></div>" +
            "<div class='asf-filter-input'  style ='width: 80%;'></div>" +
        "</div>" +
    "</div>";
var divAttach = "<div class='asf-filter-main' id='divAttach'>" +
                "<div class='block-left' style ='width:150px;'>" +
                        "<div class='asf-filter-label'></div>" +
                        "<div class='asf-filter-input' style ='position: relative;'></div>" +
                "</div>" +
                "</div>";
var isCheck = false;
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

var currentChoose = "";

function btnUpload_click(e) {

    var urlPopup3 = "/AttachFile?Type=5";

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


$(document).ready(function () {
    var templeteButton = new templateAsoftButton(),
       form = $("#sysScreenID"),
       parentSysScreenID = parent.$("#sysScreenID").val();

    var grid = $('#GridEditHRMT1021').data('kendoGrid');
    $(grid.tbody).on("change", "td", function (e) {
        var selectitem = grid.dataItem(grid.select());
        var column = e.target.id;
        if (column == 'cbbDutyID') {
            var id = e.target.value;
            var combobox = $("#cbbDutyID").data("kendoComboBox");
            if (combobox) {
                var data = combobox.dataItem();
                selectitem.DutyID = data.DutyID;
                selectitem.DutyName = data.DutyName;
            }
            grid.refresh();
        }
    });

    // Layout control
    $(".FromDate").after($(".ToDate"));
    $(".ToDate").after($(".Attach"));
    $(".Attach").after($(".Disabled"));
    $("#HRMF1021 .grid_6_1.alpha").addClass("grid_12");
    $("#HRMF1021 .grid_6_1.alpha").removeClass("grid_6_1");
    $("#HRMF1021 .grid_6.omega").css('display', 'none');

    // Xu li layout control
    $("#HRMF1021 .grid_12 table").css('display', 'none');
    // Div BoundaryID    
    $("#HRMF1021 .grid_12").append(kendo.format(DivTag2block, 'divBoundaryID'));
    $('#divBoundaryID .block-left .asf-filter-label').append($(".BoundaryID").children()[0]);
    $('#divBoundaryID .block-left .asf-filter-input').append($($(".BoundaryID").children()[0]).children());

    $("#HRMF1021 .grid_12").append(kendo.format(DivTag1block, 'divDescription'));
    $('#divDescription .block-left .asf-filter-label').append($(".Description").children()[0]);
    $('#divDescription .block-left .asf-filter-input').append($($(".Description").children()[0]).children());

    $("#HRMF1021 .grid_12").append(kendo.format(DivTag2block, 'divDepartmentID'));
    $('#divDepartmentID .block-left .asf-filter-label').append($(".DepartmentID").children()[0]);
    $('#divDepartmentID .block-left .asf-filter-input').append($($(".DepartmentID").children()[0]).children());
    $('#divDepartmentID .block-right .asf-filter-label').css('width', '0%');
    $('#divDepartmentID .block-right .asf-filter-input').css('width', '100%');
    $('#divDepartmentID .block-right .asf-filter-input').append($($(".DepartmentName").children()[1]).children());

    $("#HRMF1021 .grid_12").append(kendo.format(DivTag2block, 'divFromToDate'));
    $('#divFromToDate .block-left .asf-filter-label').append($(".FromDate").children()[0]);
    $('#divFromToDate .block-left .asf-filter-input').append($($(".FromDate").children()[0]).children());
    $('#divFromToDate .block-right .asf-filter-label').append($(".ToDate").children()[0]);
    $('#divFromToDate .block-right .asf-filter-input').append($($(".ToDate").children()[0]).children());

    $("#HRMF1021 .grid_12").append(kendo.format(DivTag2block, 'divAmount'));
    $('#divAmount .block-left .asf-filter-label').append($(".CostBoundary").children()[0]);
    $('#divAmount .block-left .asf-filter-input').append($($(".CostBoundary").children()[0]).children());

    $("#HRMF1021 .grid_12").append(kendo.format(DivTag2block, 'divDisabled'));
    $('#divDisabled .block-left .asf-filter-input').append($(".Disabled").children()[1]);

    // Attach   
    $(".container_12.asf-form-button").prepend(divAttach);
    $("#divAttach .block-left .asf-filter-label").append($(".Attach").children()[0]);
    $("#divAttach .block-left .asf-filter-input").append($($(".Attach").children()[0]).children());
    $("#Attach").css('display', 'none');

    if ($("#isUpdate").val() == "False") {
        $("#divDisabled").css('display', 'none');

        $("#Attach")
            .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
            .parent()
            .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));
        $($(".Attach").children()[0]).css("width", "14%");
    }

    var cbo = $("#DepartmentID").data('kendoComboBox');
    if (cbo) {
        cbo.bind('change', function () {
            $("#DepartmentName").val(cbo.dataItem().DepartmentName);
        });
    }
});

function CustomerCheck() {
    var grid = $('#GridEditHRMT1021').data('kendoGrid');
    var grid_tr = $('#GridEditHRMT1021 .k-grid-content tr');
    var arrValue = new Array();
    var dataGrid = grid.dataSource._data;
    var fromDate = kendo.toString($("#FromDate").data("kendoDatePicker").value(), 'yyyy-MM-dd');
    var toDate = kendo.toString($("#ToDate").data("kendoDatePicker").value(), 'yyyy-MM-dd');
    for (var i = 0; i < dataGrid.length; i++) {
        var item = grid.dataSource._data[i];

        // Set gia tri default
        item.DivisionID =  $("#EnvironmentDivisionID").val();
        item.DepartmentID = $("#DepartmentID").val();
        item.BoundaryID = $("#BoundaryID").val();
        arrValue.push(item.BoundaryID +',' + item.DepartmentID +',' + item.DutyID + ',' + fromDate+',' + toDate);        
    }

    var url = "/HRM/HRMF1020/CheckInsertOrUpdate";

    $.ajax({ 
        type: "POST",
        url: url,
        datatype: "json",
        traditional: true,
        async: false,
        data: { 'data': arrValue },              
        success: function (result) {
            CheckSuccess(result);
        }
    });
    
    //check từ ngày phải nhỏ hơn đến ngày
    var message = [];
    var fromdatestr = $("#FromDate").val(), date1 = fromdatestr.split("/");
    var todatestr = $("#ToDate").val(), date2 = todatestr.split("/");
    var fromdate2 = new Date(date1[2], date1[1] - 1, date1[0]);
    var todate2 = new Date(date2[2], date2[1] - 1, date2[0]);
    if (fromdate2 > todate2) {
        message.push(ASOFT.helper.getMessage('OOFML000022'));
    }

    var msgg = "{0} không được là số âm";
    if ($("#CostBoundary").val() < 0) {
        message.push(msgg.f(ASOFT.helper.getLanguageString("HRMF1021.CostBoundary", "HRMF1021", "HRM")))
    }

    if (message.length > 0) {
        ASOFT.form.displayError('#HRMF1021', message);
        return true;
    }
    var check = isCheck;
    isCheck = false;
    return check;
}

function GetColIndex(grid, columnName) {
    var columns = grid.columns;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].field == columnName)
            return i;
    }
    return 0;
}

function CheckSuccess(result) {
    if (result.isCheck) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage("HRMFML000007")], null);
        isCheck = true;

        var grid = $('#GridEditHRMT1021').data('kendoGrid');
        var grid_tr = $('#GridEditHRMT1021 .k-grid-content tr');
        var dataGrid = grid.dataSource._data;
        for (var i = 0; i < dataGrid.length; i++) {
            var item = grid.dataSource._data[i];
            var check = false;
            result.data.forEach(function find(data){
                if(data.DutyID == item.DutyID){
                    $($(grid_tr[i]).children()[GetColIndex(grid, "DutyID")]).addClass('asf-focus-input-error');
                    find.stop == true;
                }
            });
        }
    }
}