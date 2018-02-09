//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     26/12/2017      Kim Vu          Create new
//####################################################################

var currentChoose = "";

$(document).ready(function () {
    LMF2061.AddEventControl();
    LMF2061.LayoutControl();
    LMF2061.SetEnableControl();
    $("#RelatedToTypeID").val(10);
    $(".LoanConvertedAmount").addClass('asf-disabled-li');
    $(".FromDate").addClass('asf-disabled-li');
    $(".ToDate").addClass('asf-disabled-li');
});

var LMF2061 = new function () {

    // #region  ---- Member Variable ---

    this.templatediv = "<div id='{0}'></div>";

    // #endregion ---- Member Variable ---

    /**
    * Layout form LMF2061
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.LayoutControl = function () {

        // FromDate -- ToDate
        $('.ToDate').css('display', 'none')
        $($('#FromDate').parent().parent()).css('width', '46%')
        $($('#ToDate').parent().parent()).css('width', '46%')
        $($('.FromDate').children()[1]).append(kendo.format(this.templatediv, 'FromToDate'));
        $('div#FromToDate').append($($('#FromDate').parent().parent()))
        $('div#FromToDate').append("<span style=\"padding-left:3px ;padding-right:3px\">---</span>")
        $('div#FromToDate').append($($('#ToDate').parent().parent()))

        $($(".Description").parent()).find('.asf-td-caption').css('width', '10%');
        $($(".Description").parent()).find('.asf-td-field').css('width', '80%');
        $(".LoanVoucherID").css('display', 'none');
        var templeteButton = new this.templateAsoftButton(),
        form = $("#sysScreenID"),
        parentSysScreenID = parent.$("#sysScreenID").val();
        $('#Attach').css('display', 'none');
        if ($('#isUpdate').val() != "True") {
            $("#Attach")
                .change(function () { LMF2061.setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
                .parent()
                .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

            $($(".Attach").children()[0]).css("width", "14%");
        } else {
            $(".LoanVoucherNo").addClass('asf-disabled-li');
        }
    };

    /**
    * Set Enable control 
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.SetEnableControl = function () {
        $("#GridEditLMT2061").attr("AddNewRowDisabled", "false");
    };

    /**
    * Add event for Control 
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.AddEventControl = function () {
        $("#btnLoanVoucherNo").bind('click', LMF2061.btnLoanVoucherNo_Click);
        $("#btnDeleteLoanVoucherNo").bind('click', LMF2061.btnDeleteLoanVoucherNo_Click);
    };

    /**  
    * Load data inherit for grid detail
    *
    * [Kim Vu] Create New [26/12/2017]
    **/
    this.LoadGridDetail = function (loanVoucherID) {
        var url = "/LM/LMF2060/GetDetailInherit";
        ASOFT.helper.postTypeJson(url, { loanVoucherID: loanVoucherID }, function (result) {
            if (result) {                
                var dataSource = [];
                result.forEach(function (row) {
                    var data = {};
                    data.UnwindAmount = row.UnwindAmount;
                    data.SourceName = row.SourceName;
                    data.AssetID = row.AssetID;
                    data.AssetName = row.AssetName;
                    data.AccountingValue = row.AccountingValue;
                    data.EvaluationValue = row.EvaluationValue;
                    data.LoanLimitRate = row.LoanLimitRate;
                    data.LoanLimitAmount = row.LoanLimitAmount;
                    data.MortgageAmount = row.MortgageAmount;
                    data.RemainAmount = row.RemainAmount;
                    data.Ana01Name = row.Ana01Name;
                    data.Ana02Name = row.Ana02Name;
                    data.Ana03Name = row.Ana03Name;
                    data.Ana04Name = row.Ana04Name;
                    data.Ana05Name = row.Ana05Name;
                    data.Ana06Name = row.Ana06Name;
                    data.Ana07Name = row.Ana07Name;
                    data.Ana08Name = row.Ana08Name;
                    data.Ana09Name = row.Ana09Name;
                    data.Ana10Name = row.Ana10Name;
                    data.LoanVoucherID = row.LoanVoucherID;
                    data.LoanTransactionID = row.LoanTransactionID;
                    dataSource.push(data);
                });
                $("#GridEditLMT2061").data('kendoGrid').dataSource.data(dataSource);
            }
        })
    }

    // #region --- Attach ---

    this.templateAttachFile = function (textFileName, templateClass, textFileID) {
        this.getTemplate = kendo.format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label title='{3}'>{1}</label><label class='x-close'>&#10006</label></div>", templateClass, textFileName.length > 25 ? [textFileName.slice(0, 24), "..."].join("") : textFileName, textFileID, textFileName);
    };

    this.templateAsoftButton = function () {
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

    this.setButtonDeleteDisableWhenObjectChange = function ($Object, $ButtonDelete, buttonEventClick) {

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

    this.getResultAfterDelete = function (result, apkDelete) {

        var $resultAfterDelete = $.map(result, (function (obj) {

            if (obj.APK != apkDelete)
                return obj;
        }));

        return $resultAfterDelete.length > 0 ? $resultAfterDelete : "";
    }

    this.deleteFile = function (jqueryObjectClick) {

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

    // #endregion --- Attach ---

    /**
    * List Choose data
    *
    * [Kim Vu] Create New [28/11/2017]
    **/
    this.ListChoose = {
        "Attach": function (result) {

            var $templeteParent = $(".templeteAll"),

                templeteAll = result.map(function (obj) {

                    var objFileName = obj.AttachName,

                        objFileID = obj.APK;

                    return new LMF2061.templateAttachFile(objFileName, "file-templete", objFileID).getTemplate;
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
        },
        "LoanVoucherNo": function (result) {
            $("#LoanVoucherNo").val(result.LoanVoucherNo);
            $("#LoanVoucherID").val(result.LoanVoucherID);            
            $("#LoanConvertedAmount").data('kendoNumericTextBox').value(result.LoanConvertedAmount);
            $("#FromDate").data('kendoDatePicker').value(result.FromDate);
            $("#ToDate").data('kendoDatePicker').value(result.ToDate);
            LMF2061.LoadGridDetail(result.LoanVoucherID);
        }
    };

    /**  
    * Get data of param
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.getUrlParameter = function (param) {
        var url = new URL(window.location.href);
        var result = url.searchParams.get(param);
        return result;
    }

    /**  
    * Get Index of columns
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.GetColIndex = function (grid, columnName) {
        var columns = grid.columns;
        for (var i = 0; i < columns.length; i++) {
            if (columns[i].field == columnName)
                return i;
        }
        return 0;
    }

    /**  
    * Test Input
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.TestInput = function () {
        var mess = [];        
        var totalAmountGrid = 0;
        var grid = $("#GridEditLMT2061").data('kendoGrid');
        var check = false;
        grid.dataSource._data.forEach(function (value) {
            if (value.RemainAmount < value.UnwindAmount) {
                check = true;
            }
        });
        if (check) {
            mess.push(ASOFT.helper.getMessage('LMFML000024'));           
            var grid_tr = $('#GridEditLMT2061 .k-grid-content tr');
            for (var i = 0; i < grid.dataSource._data.length; i++) {
                var value = grid.dataSource._data[i];
                if (value.RemainAmount < value.UnwindAmount) {
                    $($(grid_tr[i]).children()[LMF2061.GetColIndex(grid, "UnwindAmount")]).addClass('asf-focus-input-error');
                }
            }
        }
        return mess;
    }

    // #region  --- Event Handle ---

    /**
    * Show LMF4444 when click
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.btnLoanVoucherNo_Click = function (e) {
        var divisionID = $("#EnvironmentDivisionID").val();
        var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&ScreenID=LMF2061&Type=2"].join("");
        ASOFT.asoftPopup.showIframe(urlpopup, {});
        currentChoose = "LoanVoucherNo";
    };

    /**
    * Clear value when click
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.btnDeleteLoanVoucherNo_Click = function (e) {
        $("#LoanVoucherNo").val('');
        $("#LoanVoucherID").val('');
        $("#LoanConvertedAmount").data('kendoNumericTextBox').value(0)
        $("#FromDate").data('kendoDatePicker').value('');
        $("#ToDate").data('kendoDatePicker').value('');
    };

    // #endregion  --- Event Handle ---
};

// #region --- receive result from popup select data ---

function receiveResult(result) {
    this[LMF2061.ListChoose[currentChoose](result)];
};

// #endregion --- receive result from popup select data ---

// #region ---- Event Attach File ---
function btnUpload_click(e) {

    var urlPopup3 = "/AttachFile?Type=5";

    ASOFT.asoftPopup.showIframe(urlPopup3, {});

    currentChoose = "Attach";
}

function btnDeleteUpload_click(e) {

    $(".templeteAll").remove();

    $("#Attach").val("").trigger("change");
}

// #endregion ---- Event Attach File ---

this.deleteFile = function (jqueryObjectClick) {

    var $parentXClose = jqueryObjectClick.parent(),

        $templeteAll = $(".templeteAll"),

        $apkDelete = $parentXClose.attr("id"),

        $attach = $("#Attach"),

        $result = $attach.val().split(','),

        $resultAfterDelete = LMF2061.getResultAfterDelete($result, $apkDelete);

    $attach.val(JSON.stringify($resultAfterDelete));

    $parentXClose.remove();

    typeof $templeteAll !== "undefined"
        ? ($templeteAll.find(".file-templete").length == 0
            ? ($templeteAll.remove(), $attach.val("").trigger("change"))
            : false)
        : false;
}

/**  
* Xu li sau khi chay insert thanh cong
*
* [Kim Vu] Create New [27/12/2017]
**/
function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && result.Data != null) {
        var url = "/LM/LMF2060/ExcuteAfterInsertOrUpdate";
        ASOFT.helper.postTypeJson(url, { voucherID: result.Data.RefKey }, null);
    }
}

/**  
* Custom check input before save
*
* [Kim Vu] Create New [04/12/2017]
**/
function CustomerCheck() {
    var mess = LMF2061.TestInput();
    if (mess.length > 0) {
        ASOFT.form.displayError("#LMF2061", mess);
        return true;
    }
}