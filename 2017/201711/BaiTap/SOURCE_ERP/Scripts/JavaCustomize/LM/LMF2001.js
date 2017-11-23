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

        $attach.val(JSON.stringify(result)).trigger("change");

        $(".x-close").unbind("click").bind("click", function () {
            deleteFile($(this));
        });
    },
    1: function (result) {
        $('#LimitVoucherID').val(result.Column01);
        $('#LimitVoucherNo').val(result.Column02);
        $('#BankID').val(result.BankID);
        $('#BankName').val(result.Column04);
        $('#BankAccountID').val(result.Column05);
        $('#CurrencyID').val(result.Column08);
        

        var url = "/LM/LMF4444/GetExchangeRateDecimal";
        var data = {
            CurrencyID: $('#CurrencyID').val()
        };
        ASOFT.helper.postTypeJson(url, data, function (data1) {
            pExchangeRateLength = data1.ExchangeRateDecimal;
            pOperator = data1.Operator;
        });

        var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
        dataExchangeRate.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        var dataOriginalAmountTotal = $('#OriginalAmount').data("kendoNumericTextBox");
        dataOriginalAmountTotal.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        var dataConvertedAmountTotal = $('#ConvertedAmount').data("kendoNumericTextBox");
        //dataConvertedAmountTotal.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })

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
    }
};

var templateDescription = "<div class=\"asf-form-container\"><table class=\"asf-table-view\" id=\"ContentAll\"></table></div>";

var templateFromToDate = "<div id=\"FromToDate\"></div>"
var templateCurrency_ExchangRate = "<div id=\"Currency_ExchangRate\"></div>"

var btnLimitVoucherNo = '<a id="btSearchFromEmployee" style="z-index:100001; position: absolute; right: 2px; height: 27px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchLimitVoucherNo_Click()">...</a>';

var currentChoose = 0;
function btnSearchLimitVoucherNo_Click() {
    var divisionID = $("#EnvironmentDivisionID").val();
    var voucherDate = $("#VoucherDate").val();
    var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&VoucherDate=", voucherDate, "&ScreenID=LMF2001&Type=2"].join("");
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = 1;
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
    $("#RelatedToTypeID").val(3);
    var templeteButton = new templateAsoftButton(),
       form = $("#sysScreenID"),
       parentSysScreenID = parent.$("#sysScreenID").val();

    $('div.asf-form-container.container_12.pagging_bottom').after(templateDescription)
    $('#ContentAll').append($(".Description"))

    $($(".Description").children()[0]).css("width", "14%")

    if ($('#isUpdate').val() != "True") {
        $("#Attach")
            .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
            .parent()
            .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

        $('#ContentAll').append($(".Attach"))
        $($(".Attach").children()[0]).css("width", "14%")
    }else{
        var url = "/LM/LMF4444/GetExchangeRateDecimal";
        var data = {
            CurrencyID: $('#CurrencyID').val()
        };
        ASOFT.helper.postTypeJson(url, data, function (data1) {
            pExchangeRateLength = data1[0].ExchangeRateDecimal;
            pOperator = data1[0].Operator;
        });
    }

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
    
    var dpkFromDate = $("#FromDate").data("kendoDatePicker");
    var dpkToDate = $("#ToDate").data("kendoDatePicker");

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
        if (column == 'cbbAssetName') {
            var value = $("#cbbAssetName").data("kendoComboBox").dataItem();
            selectitem.AssetID = value.AssetID;
            selectitem.AssetName = value.AssetName;
            gridLMT2003.refresh();
        }
    });
    
    $('#LimitVoucherNo').attr('readonly', 'readonly')
    $('#BankName').attr('readonly', 'readonly')
    $('#CurrencyID').attr('readonly', 'readonly')

    $('#ExchangeRate').attr('onchange', 'ExchangeRate_Change()')
    $('#OriginalAmount').attr('onchange', 'OriginalAmount_Change()')

    formatForNumericTextBox("ConvertedAmount", ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, 0, 100, { isDefault: true, Value: 0 }, k_NumericTextBox_ConvertAmount_Change);

    
})

k_NumericTextBox_ConvertAmount_Change = function (e) {
    var sender = e.sender;
    //e.preventDefault();
    (sender.value() == null || sender.value() == "") ? sender.value(0) : sender.value();
}

formatForNumericTextBox = function (id, stringFormat, min, max, objDefault, changeFunction) {
    var kendoNumTxtBx = "kendoNumericTextBox",
        k_NumericTextBox = $("#" + id).data(kendoNumTxtBx);

    if (typeof k_NumericTextBox !== "undefined") {
        stringFormat !== null ? (k_NumericTextBox.setOptions({ format: stringFormat, decimals: ASOFTEnvironment.NumberFormat.ConvertedDecimals }), k_NumericTextBox.value(k_NumericTextBox.value())) : false;

        k_NumericTextBox.min(min);

        k_NumericTextBox.max(max);

        if (objDefault !== null && objDefault.isDefault) {
            k_NumericTextBox.value() === null || k_NumericTextBox.value() == "" ? k_NumericTextBox.value(objDefault.Value) : false;
        }

        typeof changeFunction === "function" ? k_NumericTextBox.bind("change", changeFunction) : false;
    }

    return false;
}


function OriginalAmount_Change() {
    CalConvertedAmount(parseFloat($('#OriginalAmount').val().replace(',', '')),parseFloat($('#ExchangeRate').val().replace(',', '')))
}

function ExchangeRate_Change() {
    CalConvertedAmount(parseFloat($('#OriginalAmount').val().replace(',', '')),parseFloat($('#ExchangeRate').val().replace(',', '')))
}

function CalConvertedAmount(OriginalAmount,ExchangeRate){
    var totalConvertedAmount = OriginalAmount * ExchangeRate;
    $('#ConvertedAmount').val(kendo.toString(totalConvertedAmount, ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString));
}

function CustomerCheck(e) {
    ASOFT.form.clearMessageBox();
    if(dpkDate_CompareDate($("#FromDate").val(), $("#ToDate").val(),dptFromDate,dptToDate)){
        return true;
    }

    if(parseFloat($("#OriginalLimit").val())>parseFloat(OriginalLimit)){
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('LMFML000006')], null);
        return true;
    }

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
        if (result.Status == 0 && action == 1) {
            $('#RelatedToTypeID').val(3);
            refreshGrid1("LMT2002");
            refreshGrid1("LMT2003");
            $('#DivisionID').val($("#EnvironmentDivisionID").val());
        }
    };

    function getListDetail(tb) {
        var dataPost1 = ASOFT.helper.dataFormToJSON(id);
        var data = [];
        var dt = getDetail(tb).Detail;
        for (i = 0; i < dt.length; i++) {
            dt[i]["Orders"] = (i + 1).toString();
            data.push(dt[i]);
        }
        return data;
    }

    function CustomRead() {
        var ct = [];
        ct.push($("#DivisionID").val());
        ct.push($("#PK").val());
        return ct;
    }

    function CustomInsertPopupDetail(datagrid) {
        tableName = []
        tableName.push("LMT2002");
        tableName.push("LMT2003");
        $.each(tableName, function (key, value) {
            datagrid.push(getListDetail(value));
        })
        return datagrid;
    }