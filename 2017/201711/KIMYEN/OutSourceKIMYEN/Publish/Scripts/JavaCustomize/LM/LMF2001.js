var currentChoose = null;
var pExchangeRateDecimal = "#,0{0}";
var pExchangeRateLength = 0;
var dptFromDate, dptToDate, OriginalLimit = 0;
var pOperator=0;
var templateAttachFile = function (textFileName, templateClass, textFileID) {
    this.getTemplate = kendo.format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label title='{3}'>{1}</label><label class='x-close'>&#10006</label></div>", templateClass, textFileName.length > 25 ? [textFileName.slice(0, 24), "..."].join("") : textFileName, textFileID, textFileName);
};

var  templateAsoftButton = function () {
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
    },
    "SearchLimitVoucherNo": function (result) {
        $('#LimitVoucherID').val(result.Column01);
        $('#LimitVoucherNo').val(result.Column02);
        $('#BankID').val(result.Column14);
        $('#BankName').val(result.Column04);
        $('#BankAccountID').data('kendoComboBox').trigger('open');        
        $('#BankAccountID').data('kendoComboBox').value(result.Column05);
        $('#CurrencyID').val(result.Column08);
        
        pExchangeRateLength = result.Column13;
        pOperator = result.Column12;

        var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
        dataExchangeRate.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        var dataOriginalAmountTotal = $('#OriginalAmount').data("kendoNumericTextBox");
        dataOriginalAmountTotal.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        var dataConvertedAmountTotal = $('#ConvertedAmountMaster').data("kendoNumericTextBox");

        $('#FromDate').val(result.Column06);
        $('#ToDate').val(result.Column07);
        dptFromDate = changeDate($("#FromDate").val());
        dptToDate = changeDate($("#ToDate").val());

        var dpkFromDate = $("#FromDate").data("kendoDatePicker");
        dpkFromDate.min(dptFromDate);
        dpkFromDate.max(dptToDate);
        var dpkToDate = $("#ToDate").data("kendoDatePicker");
        dpkToDate.min(dptFromDate);
        dpkToDate.max(dptToDate);

        dataExchangeRate.value(result.Column09);
        dataOriginalAmountTotal.value(result.Column10);
        OriginalLimit = dataOriginalAmountTotal.value();
        dataConvertedAmountTotal.value(result.Column11);
    },
    "ContractOfGuaranteeNo": function(result){
        $("#ContractOfGuaranteeNo").val(result.ContractOfGuaranteeNo);
        $("#ContractOfGuaranteeID").val(result.ContractOfGuaranteeID);
    }
};

function ExchangeRateDecimalLength(targetLength) {
    var output = '';
    while (output.length < targetLength) {
        output = '0' + output;
    }
    if (targetLength != 0) {
        output = '.' + output;
    }
    return output;
}

var templateDescription = "<div class=\"asf-form-container\"><table class=\"asf-table-view\" id=\"ContentAll\"></table></div>";

var templateFromToDate = "<div id=\"FromToDate\"></div>"
var templateCurrency_ExchangRate = "<div id=\"Currency_ExchangRate\"></div>"

var btnLimitVoucherNo = '<a id="btSearchFromEmployee" style="z-index:100001; position: absolute; right: 2px; height: 27px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchLimitVoucherNo_Click()">...</a>';

function btnSearchLimitVoucherNo_Click() {
    var divisionID = $("#EnvironmentDivisionID").val();
    var voucherDate = $("#VoucherDate").val();
    var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&VoucherDate=", voucherDate, "&ScreenID=LMF2001&Type=2"].join("");
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = "SearchLimitVoucherNo";
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

    var urlPopup3 = "/AttachFile?Type=2";

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
    $('#DivisionID').val($("#EnvironmentDivisionID").val());
    $("#RelatedToTypeID").val(3);
    var templeteButton = new templateAsoftButton(),
       form = $("#sysScreenID"),
       parentSysScreenID = parent.$("#sysScreenID").val();

    $('div.asf-form-container.container_12.pagging_bottom').after(templateDescription);
    $('#ContentAll').append($(".Description"));

    $($(".Description").children()[0]).css("width", "14%");


    $("#LimitVoucherNo").parent().after(btnLimitVoucherNo);
    $('.ExchangeRate ').css('display', 'none')
    $($('#CurrencyID').parent()).append(templateCurrency_ExchangRate)
    $('div#Currency_ExchangRate').append($('#CurrencyID').css('width', '51%'))
    $('div#Currency_ExchangRate').append("<span style=\"padding-left:3px ;padding-right:3px\"></span>")
    $('div#Currency_ExchangRate').append($('#ExchangeRate').parent().parent().css('width', '46%').css('height', '27px'))

    $('.ToDate').css('display', 'none')
    $($('#FromDate').parent().parent()).css('width', '46%')
    $($('#ToDate').parent().parent()).css('width', '46%')
    $($('.FromDate').children()[1]).append(templateFromToDate)
    $('div#FromToDate').append($($('#FromDate').parent().parent()))
    $('div#FromToDate').append("<span style=\"padding-left:3px ;padding-right:3px\">---</span>")
    $('div#FromToDate').append($($('#ToDate').parent().parent()))

    var cboVoucherTypeID = $('#VoucherTypeID').data('kendoComboBox');
    cboVoucherTypeID.bind('change', cboVoucherTypeID_Change);

    var gridLMT2002 = $('#GridEditLMT2002').data('kendoGrid');
    
    $(gridLMT2002.tbody).on("change", "td", function (e) {
        var selectitem = gridLMT2002.dataItem(gridLMT2002.select());

        var column = e.target.id;
        if (column == 'cbbCostTypeName') {
            var value = $("#cbbCostTypeName").data("kendoComboBox").dataItem();

            selectitem.CostTypeID = value.CostTypeID;
            selectitem.CostTypeName = value.CostTypeName;
            gridLMT2002.refresh();
        }
        cbo_AnaChange(selectitem, column, gridLMT2002);
    });

    var gridLMT2003 = $('#GridEditLMT2003').data('kendoGrid');
    gridLMT2003.hideColumn('SourceID');
    $(gridLMT2003.tbody).on("change", "td", function (e) {
        var selectitem = gridLMT2003.dataItem(gridLMT2003.select());

        var column = e.target.id;
        if (column == 'cbbSourceName') {
            var value = $("#cbbSourceName").data("kendoComboBox").dataItem();
            selectitem.SourceID = value.OrderNo;
            selectitem.SourceName = value.Description;
            gridLMT2003.refresh();
        }
        if (column == 'cbbAssetID') {
            var value = $("#cbbAssetID").data("kendoComboBox").dataItem();
            selectitem.AssetID = value.AssetID;
            selectitem.AssetName = value.AssetName;
            selectitem.AccountingValue = value.AccountingValue;
            selectitem.LoanLimitAmount = value.LoanLimitAmount;
            selectitem.LoanLimitRate = value.LoanLimitRate;
            selectitem.RemainAmount = value.RemainAmount;
            gridLMT2003.refresh();
        }
        cbo_AnaChange(selectitem, column, gridLMT2003);
    });

    var gridLMT2004 = $('#GridEditLMT2004').data('kendoGrid');    
    $(gridLMT2004.tbody).on("change", "td", function (e) {
        var selectitem = gridLMT2004.dataItem(gridLMT2004.select());
        var column = e.target.id;        
        cbo_AnaChange(selectitem, column, gridLMT2004);
    });

    $(gridLMT2004.tbody).on("focusout", function (e) {
        if(e.target.id =="OriginalAmountLMT2004"){
            var selectitem = gridLMT2004.dataItem(gridLMT2004.select());
            selectitem.ConvertedAmount = e.target.value * $("#ExchangeRate").val();            
            selectitem.OriginalAmount= e.target.value;
        }
    });
    
    $('#LimitVoucherNo').attr('readonly', 'readonly')
    $('#BankName').attr('readonly', 'readonly')
    $('#CurrencyID').attr('readonly', 'readonly')

    $('#ExchangeRate').attr('onchange', 'OriginalAmountOrExchangeRate_Change()')
    $('#OriginalAmount').attr('onchange', 'OriginalAmountOrExchangeRate_Change()')

    var dpkVoucherDate = $("#VoucherDate").data("kendoDatePicker");
    var dpkFromDate = $("#FromDate").data("kendoDatePicker");
    dpkFromDate.bind('open', dpkDate_Open);
    var dpkToDate = $("#ToDate").data("kendoDatePicker");
    dpkToDate.bind('open', dpkDate_Open);

    formatForNumericTextBox("OriginalAmount", ASOFTEnvironment.NumberFormat.KendoExchangeRateDecimalsFormatString, null, null, { isDefault: true, Value: 0 }, k_NumericTextBox_ConvertAmount_Change, ASOFTEnvironment.NumberFormat.ExchangeRateDecimals);

    formatForNumericTextBox("ConvertedAmount", ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, null, null, { isDefault: true, Value: 0 }, k_NumericTextBox_ConvertAmount_Change, ASOFTEnvironment.NumberFormat.ConvertedDecimals);
    $('#ConvertedAmount').attr('id','ConvertedAmountMaster');
    if ($('#isUpdate').val() != "True") {
        dpkFromDate.value(ASOFTEnvironment.BeginDate);
        dpkToDate.value(ASOFTEnvironment.EndDate);
        dpkVoucherDate.value(new Date());
        $("#Attach")
            .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
            .parent()
            .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

        $('#ContentAll').append($(".Attach"))
        $($(".Attach").children()[0]).css("width", "14%")
        $("#Status").data('kendoComboBox').select(0);
    }else{
        var url = "/LM/LMF4444/GetExchangeRateDecimal";
        var data = {
            CurrencyID: $('#CurrencyID').val()
        };
        ASOFT.helper.postTypeJson(url, data, function (data1) {
            pExchangeRateLength = data1[0].ExchangeRateDecimal;
            pOperator = data1[0].Operator;
        });

        if($('#IsStatusNo').val()=='3'){
            ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage($('#IsStatusMessage').val())], null);
            dpkVoucherDate.readonly();
            dpkFromDate.readonly();
            dpkToDate.readonly();
            cboVoucherTypeID.readonly();
            var cboCreditFormID = $('#CreditFormID').data('kendoComboBox');
            cboCreditFormID.readonly();
            var cboBankAccountID = $('#BankAccountID').data('kendoComboBox');
            cboBankAccountID.readonly();
            var cboStatus = $('#Status').data('kendoComboBox');
            cboStatus.readonly();
            $('#ExchangeDate').attr('readonly', 'readonly')
            $('#OriginalAmount').attr('readonly', 'readonly')
            $('#ConvertedAmountMaster').attr('readonly', 'readonly')

            $(gridLMT2002.tbody).on("focusin", function (e) {
                gridLMT2002.closeCell();
            });
        }
    }

    // Bind event
    $("#btnContractOfGuaranteeNo").bind('click',btnContractOfGuaranteeNo_Click);
    $("#btnDeleteContractOfGuaranteeNo").bind('click',btnDeleteContractOfGuaranteeNo_Click);
    LoadCaptionGrid();
})

/**
    * Fill caption dynamic lable (parameter)
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
function LoadCaptionGrid() {
    var grid = $("#GridEditLMT2003").data('kendoGrid');
    $($(grid.thead).find('th')[GetColIndex(grid, "ConvertedAmount")]).context.innerText =
        ASOFT.helper.getLanguageString("LMF2001.ConvertedAmount_AssetID", "LMF2001", "LM");
};

function dpkDate_Open(e) {
    var item = e.sender;
    if (item.element.context.id == 'FromDate') {
        if ($("#ToDate").val()) {
            var dpkToDate = changeDate($("#ToDate").val());
            item.max(dpkToDate);
        } else {
            item.max(new Date(8640000000000000));
        }
    } else {
        if ($("#FromDate").val()) {
            var dpkFromDate = changeDate($("#FromDate").val());
            item.min(dpkFromDate);
        } else {
            item.min(new Date(1));
        }
    }
}

k_NumericTextBox_ConvertAmount_Change = function (e) {
    var sender = e.sender;
    //e.preventDefault();
    (sender.value() == null || sender.value() == "") ? sender.value(0) : sender.value();
}

formatForNumericTextBox = function (id, stringFormat, min, max, objDefault, changeFunction, fdecimals) {
    var kendoNumTxtBx = "kendoNumericTextBox",
        k_NumericTextBox = $("#" + id).data(kendoNumTxtBx);

    if (typeof k_NumericTextBox !== "undefined") {
        stringFormat !== null ? (k_NumericTextBox.setOptions({ format: stringFormat, decimals: fdecimals }), k_NumericTextBox.value(k_NumericTextBox.value())) : false;

        k_NumericTextBox.min(min);

        k_NumericTextBox.max(max);

        if (objDefault !== null && objDefault.isDefault) {
            k_NumericTextBox.value() === null || k_NumericTextBox.value() == "" ? k_NumericTextBox.value(objDefault.Value) : false;
        }

        typeof changeFunction === "function" ? k_NumericTextBox.bind("change", changeFunction) : false;
    }

    return false;
}


function OriginalAmountOrExchangeRate_Change() {
    var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
    var dataOriginalAmount = $('#OriginalAmount').data("kendoNumericTextBox");
    CalConvertedAmount(dataOriginalAmount,dataExchangeRate)
}

function CalConvertedAmount(dataOriginalAmount,dataExchangeRate){
    var dataConvertedAmount = $('#ConvertedAmountMaster').data("kendoNumericTextBox");

    var totalConvertedAmount =parseFloat("0");
    if(pOperator=='0'){
        totalConvertedAmount = dataOriginalAmount.value() * dataExchangeRate.value();
    }else{
        totalConvertedAmount = dataOriginalAmount.value() * dataExchangeRate.value();
    }
    dataConvertedAmount.value(totalConvertedAmount);
}

function CustomerCheck(e) {
    ASOFT.form.clearMessageBox();
    if ($('#isUpdate').val() == "True") {
        if (ASOFT.form.checkDateInPeriod('LMF2001', ASOFTEnvironment.BeginDate, ASOFTEnvironment.EndDate, ['VoucherDate'])) {
            return true;
        }
    }
    var dpkFromDate = $("#FromDate").data("kendoDatePicker");
    var dpkToDate = $("#ToDate").data("kendoDatePicker");
    if (dpkFromDate.value() ==null || dpkFromDate.value().getTime() > dpkToDate.value().getTime()) {
        var element = $('#FromDate');
        var fromWidget = element.closest(".k-widget");
        var widgetElement = element.closest("[data-" + kendo.ns + "role]");
        var widgetObject = kendo.widgetInstance(widgetElement);

        if (widgetObject != undefined && widgetObject.options.name != "TabStrip") {
            fromWidget.addClass('asf-focus-input-error');
            var input = fromWidget.find(">:first-child").find(">:first-child");
            if (input) {
                $(input).addClass('asf-focus-combobox-input-error');
            }
        } else {
            element.addClass('asf-focus-input-error');
        }

        var element = $('#ToDate');
        var fromWidget = element.closest(".k-widget");
        var widgetElement = element.closest("[data-" + kendo.ns + "role]");
        var widgetObject = kendo.widgetInstance(widgetElement);

        if (widgetObject != undefined && widgetObject.options.name != "TabStrip") {
            fromWidget.addClass('asf-focus-input-error');
            var input = fromWidget.find(">:first-child").find(">:first-child");
            if (input) {
                $(input).addClass('asf-focus-combobox-input-error');
            }
        } else {
            element.addClass('asf-focus-input-error');
        }

        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('LMFML000012')], null);
        return true;
    }

    if(dpkDate_CompareDate($("#FromDate").val(), $("#ToDate").val(),dptFromDate,dptToDate)){
        return true;
    }

    if(parseFloat($("#OriginalLimit").val())>parseFloat(OriginalLimit)){
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('LMFML000006')], null);
        return true;
    }

    var grid = $('#GridEditLMT2004').data('kendoGrid');
    var dataSource = grid.dataSource._data;

    var originalLimitAmount = dataSource.map(function (item) { return parseFloat(item.OriginalAmount) });
    var convertedLimitAmount = dataSource.map(function (item) { return parseFloat(item.ConvertedAmount) });

    var totaloriginalLimitAmount = originalLimitAmount.reduce(function (a, b) { return a + b; })
    var totalconvertedLimitAmount = convertedLimitAmount.reduce(function (a, b) { return a + b; })
    var originalAmountMaster = $("#OriginalAmount").data('kendoNumericTextBox').value();
    var convertedAmountMaster = $("#ConvertedAmountMaster").data('kendoNumericTextBox').value();
    if(originalAmountMaster != totaloriginalLimitAmount || 
        totalconvertedLimitAmount != convertedAmountMaster){
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('LMFML000027')], null);
        inputError("OriginalAmount");
        inputError("ConvertedAmountMaster");
        return true;
    }

    // Check grid tài sản đảm bảo
    if ($('#isUpdate').val() != "True"){
        var gridLMT2003 = $('#GridEditLMT2003').data('kendoGrid');
        var grid_tr = $('#GridEditLMT2003 .k-grid-content tr');
        var datapost = [];
        for (var i = 0; i < gridLMT2003.dataSource._data.length; i++) {
            var data = gridLMT2003.dataSource._data[i];
            datapost.push({
                AssetID : data.AssetID,
                ConvertedAmount : data.ConvertedAmount
            });
            if(data.ConvertedAmount > data.RemainAmount){
                ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('LMFML000023')], null);
                $($(grid_tr[i]).children()[GetColIndex(gridLMT2003, "ConvertedAmount")]).addClass('asf-focus-input-error');
                return true;
            }
        }

        // Check by store
        var urlpost = '/LM/LMF2000/CheckGridLMT2003';
        var postCheck = false;
        $.ajax({
            type: "POST",
            url: urlpost,
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify(datapost),
            async: false,
            success: function (result) {
                if(result.Status == 1){
                    ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('LMFML000023')], null);
                    for (var i = 0; i < gridLMT2003.dataSource._data.length; i++) {
                        $($(grid_tr[i]).children()[GetColIndex(gridLMT2003, "ConvertedAmount")]).addClass('asf-focus-input-error');
                    }
                    postCheck = true;
                }
            },
            error: function (xhr, status, exception) {
                if (success && typeof (success) === "function") {
                    error(xhr, status, exception);
                    return true;
                }
            }
        });   
        if(postCheck)
            return true;
    }

    var checkMasterPost = false;
    var urlCheckMaster = "/LM/LMF2000/CheckSaveData";
    var dataCheckMaster ={
        originalAmount : $("#OriginalAmount").val(),
        voucherID: $("#VoucherID").val(),
        limitVoucherID: $("#LimitVoucherID").val()
    };

    ASOFT.helper.postTypeJson(urlCheckMaster,dataCheckMaster,function(result){
        if(result==1){
            ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('LMFML000006')], null);
            inputError("OriginalAmount");
            checkMasterPost = true;
        }
    });

    if(checkMasterPost)
        return true;

    return false;
}

function dpkDate_CompareDate(fromDate,toDate,ptFromDate,ptToDate){
    if (fromDate && toDate) {
        let pFromDate = changeDate(fromDate);
        let pToDate =changeDate(toDate)
        let arrMsg=[];
        let ischeck=false;
        let num=0;
        if(pFromDate>pToDate){
            inputError("FromDate");
            inputError("ToDate");
            arrMsg.push(ASOFT.helper.getMessage('LMFML000012'));
            ischeck = true;
        }

        if(pFromDate < ptFromDate || pFromDate > ptToDate){
            inputError("FromDate");
            arrMsg.push(ASOFT.helper.getMessage('LMFML000005'));
            num = 1;
            ischeck = true;
        }

        if(pToDate < ptFromDate || pToDate > ptToDate){
            inputError("ToDate");
            if(num !=1){
                arrMsg.push(ASOFT.helper.getMessage('LMFML000005'));
            }
            ischeck = true;
        }

        if(ischeck){
            ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), arrMsg, null);
        }

        return ischeck;
    }
}


function inputError(pVariable){
    var element = $('#'+pVariable);
    var fromWidget = element.closest(".k-widget");
    var widgetElement = element.closest("[data-" + kendo.ns + "role]");
    var widgetObject = kendo.widgetInstance(widgetElement);

    if (widgetObject != undefined && widgetObject.options.name != "TabStrip") {
        fromWidget.addClass('asf-focus-input-error');
        var input = fromWidget.find(">:first-child").find(">:first-child");
        if (input) {
            $(input).addClass('asf-focus-combobox-input-error');
        }
    } else {
        element.addClass('asf-focus-input-error');
    }
}
function changeDate(curDate) {
    var arr = curDate.split('/');
    return new Date(arr[2], arr[1]-1, arr[0]);
}

function cboVoucherTypeID_Change(e) {
    var dataItem = e.sender.dataItem();
    if (dataItem) {
        var VoucherTypeID = dataItem.VoucherTypeID;
        var url = "/LM/LMF1011/GetVoucherNoText";
        var data = {
            VoucherTypeID: VoucherTypeID,
            TableID: "LMT2001"
        };
        ASOFT.helper.postTypeJson(url, data, function (data) {
            if (data.NewKey) {
                $("#VoucherNo").val(data.NewKey);
            } else {
                $("#VoucherNo").val("");
            }
        });
    }
    else {
        $("#VoucherNo").val("");
    }
};    

function ExchangeRateDecimalLength(targetLength) {
    var output = '';
    while (output.length < targetLength) {
        output = '0' + output;
    }
    if (targetLength != 0) {
        output = '.' + output;
    }
    return output;
}

function Grid_SaveCustom(e) {
    if (e.values == undefined || e.values == null) {
        return true;
    }

    if (e.values != null) {
    }
}

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 ){
        if (action == 1) {
            $('#RelatedToTypeID').val(3);
            refreshGrid1("LMT2002");
            refreshGrid1("LMT2003");
            refreshGrid1("LMT2004");
            $('#DivisionID').val($("#EnvironmentDivisionID").val());
        }
        
        if (action == 2) {
            var VoucherTypeID = $('#VoucherTypeID').val();
            var url = "/LM/LMF1011/GetVoucherNoText";
            var data = {
                VoucherTypeID: VoucherTypeID,
                TableID: "LMT2001"
            };
            ASOFT.helper.postTypeJson(url, data, function (data) {
                if (data.NewKey) {
                    $("#VoucherNo").val(data.NewKey);
                } else {
                    $("#VoucherNo").val("");
                }
            });
        }
        var urlUpdate = '/LM/LMF2000/ExcuteUpdateAfterInsertOrUpdate';
        ASOFT.helper.postTypeJson(urlUpdate, {voucherID: result.Data}, null);
    }    
};

function CustomRead() {
    var ct = [];
    ct.push($("#DivisionID").val()?$("#DivisionID").val():$("#EnvironmentDivisionID").val());
    ct.push($("#PK").val());
    return ct;
}

var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

/**  
* Xử lí show data
*
* [Kim Vu] Create New [28/12/2017]
**/
var cbo_AnaChange = function(row, column, grid){
    if(column == "cbbAna01Name" ||
        column == "cbbAna02Name" ||
        column == "cbbAna03Name" ||
        column == "cbbAna04Name" ||
        column == "cbbAna05Name" ||
        column == "cbbAna06Name" ||
        column == "cbbAna07Name" ||
        column == "cbbAna08Name" ||
        column == "cbbAna09Name" ||
        column == "cbbAna10Name"){

        var cbo = $("#"+column).data("kendoComboBox");
        if(cbo){
            var data = $("#"+column).data("kendoComboBox").dataItem();
            var index = column.match(/\d+/);
            if(index.length>0){
                var AnaID = kendo.format("Ana{0}ID",index);
                var AnaName =  kendo.format("Ana{0}Name",index);
                row[AnaID] = data.AnaID;
                row[AnaName] = data.AnaName;
            }
            grid.refresh();
        }
    }
}

/**  
* Delete ContractGuaranteeNo Click
*
* [Kim Vu] Create New [28/12/2017]
**/
function btnDeleteContractOfGuaranteeNo_Click(){
    $("#ContractOfGuaranteeNo").val('');
    $("#ContractOfGuaranteeID").val('');
}

/**  
* Choose ContractGuaranteeNo Click
*
* [Kim Vu] Create New [28/12/2017]
**/
function btnContractOfGuaranteeNo_Click(){
    var divisionID = $("#EnvironmentDivisionID").val();
    var voucherDate = $("#VoucherDate").val();
    var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&VoucherDate=", voucherDate, "&ScreenID=LMF2001_2&Type=2"].join("");
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = "ContractOfGuaranteeNo";
}

function GetColIndex(grid, columnName) {
    var columns = grid.columns;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].field == columnName)
            return i;
    }
    return 0;
}