var currentChoose = null;
var pExchangeRateDecimal = "#,0{0}";
var pExchangeRateLength = 0;
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
    }
};

var templateDescription = "<div class=\"asf-form-container\"><table class=\"asf-table-view\" id=\"ContentAll\"></table></div>";

var templateFromToDate = "<div id=\"FromToDate\"></div>"

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
    $("#RelatedToTypeID").val(2);
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
    }

    $('.ToDate').css('display', 'none')
    $($('#FromDate').parent().parent()).css('width', '46%')
    $($('#ToDate').parent().parent()).css('width', '46%')
    $($('.FromDate').children()[1]).append(templateFromToDate)
    $('div#FromToDate').append($($('#FromDate').parent().parent()))
    $('div#FromToDate').append("<span style=\"padding-left:4px ;padding-right:4px\">---</span>")
    $('div#FromToDate').append($($('#ToDate').parent().parent()))

    $('#ExchangeRateDecimal').css('text-align', 'right');
    $('#OriginalLimitTotal').css('text-align','right');
    $('#ConvertedLimitTotal').css('text-align', 'right');

    var grid = $('#GridEditLMT1011').data('kendoGrid');
    $(grid.tbody).on("change", "td", function (e) {
        var selectitem = grid.dataItem(grid.select());

        var column = e.target.id;
        if (column == 'cbbCreditFormID') {
            var value = $("#cbbCreditFormID").data("kendoComboBox").dataItem();

            selectitem.CreditFormID = value.CreditFormID;
            selectitem.CreditFormName = value.CreditFormName;
            grid.refresh();
        }
    });

    grid.bind("dataBound", function (e) {
        var dataSource = this.dataSource._data;
        var totalOriginalLimit =  parseFloat('0');
        var totalConvertedLimit =  parseFloat('0');
        $(dataSource).each(function () {
            totalOriginalLimit = parseFloat(totalOriginalLimit) + parseFloat(this.OriginalLimitAmount?this.OriginalLimitAmount:0);
            totalConvertedLimit = parseFloat(totalConvertedLimit) + parseFloat(this.ConvertedLimitAmount ? this.ConvertedLimitAmount : 0);
        });
        var dataOriginalLimitTotal = $('#OriginalLimitTotal').data("kendoNumericTextBox");
        dataOriginalLimitTotal.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        var dataConvertedLimitTotal = $('#ConvertedLimitTotal').data("kendoNumericTextBox");
        //dataConvertedLimitTotal.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })

        dataOriginalLimitTotal.value(totalOriginalLimit);
        dataConvertedLimitTotal.value(totalConvertedLimit);
    });

    var cboVoucherTypeID = $('#VoucherTypeID').data('kendoComboBox');
    cboVoucherTypeID.bind('change', cboVoucherTypeID_Change);

    var cboCurrencyID = $('#CurrencyID').data('kendoComboBox');
    cboCurrencyID.select(function (dataItem) {
        return dataItem.CurrencyID === ASOFTEnvironment.BaseCurrencyID;
    });
    cboCurrencyID_Change(cboCurrencyID);
    cboCurrencyID.bind('change', cboCurrencyID_Change);

    $('#ExchangeRate').attr('onchange', 'ExchangeRate_Change()')

    var dpkFromDate = $("#FromDate").data("kendoDatePicker");
    dpkFromDate.bind('open', dpkDate_Open);
    var dpkToDate = $("#ToDate").data("kendoDatePicker");
    dpkToDate.bind('open', dpkDate_Open);

    formatForNumericTextBox("ConvertedLimitTotal", ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, 0, 100, { isDefault: true, Value: 0 }, k_NumericTextBox_ConvertAmount_Change);
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

function changeDate(curDate) {
    var arr = curDate.split('/');
    return new Date(arr[2], arr[1]-1, arr[0]);
}

function cboCommonGrid(e) {

    var grid = $('#GridEditLMT1011').data('kendoGrid');
    var dataSource = grid.dataSource._data;

    var creditFormID = dataSource.map(function (item) { return item.CreditFormID });

    e.sender.setDataSource(e.sender.dataSource._data.filter(function (item) {
            return creditFormID.indexOf(item.CreditFormID) == -1;
    }));
}
function ExchangeRate_Change() {
    var dataExchangeRate = $('#ExchangeRate').val().replace(',', '');

    var grid = $('#GridEditLMT1011').data('kendoGrid');
    var dataSource = grid.dataSource._data;
    var totalOriginalLimit = parseFloat('0');
    var totalConvertedLimit = parseFloat('0');
    if (dataSource) {
        $(dataSource).each(function (index) {
            totalOriginalLimit = parseFloat(totalOriginalLimit) + parseFloat(this.OriginalLimitAmount ? this.OriginalLimitAmount : 0);
            totalConvertedLimit = parseFloat(totalConvertedLimit) + parseFloat(this.OriginalLimitAmount ? this.OriginalLimitAmount : 0) * parseFloat(dataExchangeRate);
            dataSource[index].ConvertedLimitAmount = parseFloat(this.OriginalLimitAmount ? this.OriginalLimitAmount : 0) * parseFloat(dataExchangeRate);
        });
        grid.refresh();
    }
    $('#OriginalLimitTotal').val(kendo.toString(totalOriginalLimit, kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength))));
    $('#ConvertedLimitTotal').val(kendo.toString(totalConvertedLimit, ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString));

}

    function cboVoucherTypeID_Change(e) {
        var dataItem = e.sender.dataItem();
        if (dataItem) {
            var VoucherTypeID = dataItem.VoucherTypeID;
            var url = "/LM/LMF1011/GetVoucherNoText";
            var data = {
                VoucherTypeID: VoucherTypeID,
                TableID: "LMT1010"
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

    function cboCurrencyID_Change(e) {
        var dataItem = e.sender ? e.sender.dataItem() : e.dataItem();
        if (dataItem) {
            pExchangeRateLength = dataItem.ExchangeRateDecimal ? dataItem.ExchangeRateDecimal : '0';
            var current = ASOFTEnvironment.NumberFormat.ExchangeRateDecimals;
            ASOFTEnvironment.NumberFormat.ExchangeRateDecimals = pExchangeRateLength;
            ASOFTEnvironment.NumberFormat.ExchangeRateDecimalsFormatString =kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength));
            ASOFTEnvironment.NumberFormat.KendoExchangeRateDecimalsFormatString = kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength));

            var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
            dataExchangeRate.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
            var dataOriginalLimitTotal = $('#OriginalLimitTotal').data("kendoNumericTextBox");
            dataOriginalLimitTotal.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
            var dataConvertedLimitTotal = $('#ConvertedLimitTotal').data("kendoNumericTextBox");
            //dataConvertedLimitTotal.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })

            dataExchangeRate.value(dataItem.ExchangeRate);
            var grid = $('#GridEditLMT1011').data('kendoGrid');
            var colOriginalLimitAmount = grid.columns.filter(function (item) { if (item.title == 'OriginalLimitAmount') { return item } })

            var colOriginalLimitAmountEditorformat = colOriginalLimitAmount[0].editor.split(kendo.format('"format":"{0}"', colOriginalLimitAmount[0].format));
            colOriginalLimitAmount[0].format = ASOFTEnvironment.NumberFormat.ExchangeRateDecimalsFormatString;
            colOriginalLimitAmount[0].editor = colOriginalLimitAmountEditorformat.join(kendo.format('"format":"{0}"', colOriginalLimitAmount[0].format))

            var colOriginalLimitAmountEditordecimal= colOriginalLimitAmount[0].editor.split(kendo.format('"decimals":{0}', current));
            colOriginalLimitAmount[0].editor = colOriginalLimitAmountEditordecimal.join(kendo.format('"decimals":{0}', ASOFTEnvironment.NumberFormat.ExchangeRateDecimals))
        
            var dataSource = grid.dataSource._data;
            var totalOriginalLimit = parseFloat('0');
            var totalConvertedLimit = parseFloat('0');
            if (dataSource) {
                $(dataSource).each(function () {
                    totalOriginalLimit = parseFloat(totalOriginalLimit) + parseFloat(this.OriginalLimitAmount ? this.OriginalLimitAmount : 0);
                    totalConvertedLimit = parseFloat(totalConvertedLimit) + parseFloat(this.ConvertedLimitAmount ? this.ConvertedLimitAmount : 0);
                });
            }
            $('#OriginalLimitTotal').val(kendo.toString(totalOriginalLimit, kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength))));
            $('#ConvertedLimitTotal').val(kendo.toString(totalConvertedLimit, ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString));
            grid.refresh();
        }
    }

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
            if (e.values.OriginalLimitAmount != undefined) {
                var pOriginalLimitAmount = parseFloat(e.values.OriginalLimitAmount);
                var pConvertedLimitAmount = parseFloat(e.values.OriginalLimitAmount) * parseFloat($('#ExchangeRate').val().replace(',', ''));
                e.model.set("OriginalLimitAmount", kendo.toString(pOriginalLimitAmount, kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength))));
                e.model.set("ConvertedLimitAmount", pConvertedLimitAmount);
                getDataMaster();
            }

            if (e.values.ConvertedLimitAmount != undefined) {
                e.model.set("ConvertedLimitAmount", e.values.ConvertedLimitAmount);
                getDataMaster();
            }
        
        }
    }

    function getDataMaster() {
        var grid = $('#GridEditLMT1011').data('kendoGrid');
        var dataSource = grid.dataSource._data;
        var totalOriginalLimit = parseFloat('0');
        var totalConvertedLimit = parseFloat('0');
        if (dataSource) {
            $(dataSource).each(function () {
                totalOriginalLimit = parseFloat(totalOriginalLimit) + parseFloat(this.OriginalLimitAmount ? this.OriginalLimitAmount : 0);
                totalConvertedLimit = parseFloat(totalConvertedLimit) + parseFloat(this.ConvertedLimitAmount ? this.ConvertedLimitAmount : 0);
            });
        }
        var dataOriginalLimitTotal = $('#OriginalLimitTotal').data("kendoNumericTextBox");
        var dataConvertedLimitTotal = $('#ConvertedLimitTotal').data("kendoNumericTextBox");
        dataOriginalLimitTotal.value(totalOriginalLimit);
        dataConvertedLimitTotal.value(totalConvertedLimit);
    }

    function CustomerCheck() {
        ASOFT.form.clearMessageBox();
        var grid = $('#GridEditLMT1011').data('kendoGrid');
        var dataSource = grid.dataSource._data;

        //var creditFormID = dataSource.map(function (item) { return item.CreditFormID });
        //var creditFormIDArray = creditFormID.sort();

        //var reportcreditFormIDDuplicate = [];
        //for (var i = 0; i < creditFormIDArray.length - 1; i++) {
        //    if (creditFormIDArray[i + 1] == creditFormIDArray[i]) {
        //        if (reportcreditFormIDDuplicate.indexOf(creditFormIDArray[i]) == -1) {
        //            reportcreditFormIDDuplicate.push(creditFormIDArray[i]);
        //        }
        //    }
        //}

        var originalLimitAmount = dataSource.map(function (item) { return parseFloat(item.OriginalLimitAmount) });
        var convertedLimitAmount = dataSource.map(function (item) { return parseFloat(item.ConvertedLimitAmount) });

        var totaloriginalLimitAmount = originalLimitAmount.reduce(function (a, b) { return a + b; })
        var totalconvertedLimitAmount = convertedLimitAmount.reduce(function (a, b) { return a + b; })

        var check = false;
        
        if (parseFloat(totaloriginalLimitAmount) != parseFloat($('#OriginalLimitTotal').val().replace(',', ''))) {            
            var element = $('#OriginalLimitTotal');
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

            check = true;
        }

        if (parseFloat(totalconvertedLimitAmount) != parseFloat($('#ConvertedLimitTotal').val().replace(',', ''))) {
            var element = $('#ConvertedLimitTotal');
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
            check = true;
        }

        if (check) {
            ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('LMFML000004')], null);
        }

        return check;
    };


    function onAfterInsertSuccess(result, action) {
        if (result.Status == 0 && action == 1) {
            $('#RelatedToTypeID').val(2);
            refreshGrid1("LMT1011");
            $('#DivisionID').val($("#EnvironmentDivisionID").val());
        }
    };


    function CustomRead() {
        var ct = [];
        ct.push($("#DivisionID").val());
        ct.push($("#PK").val());    
        return ct;
    }

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

    function CustomInsertPopupDetail(datagrid) {
        tableName = []
        tableName.push("LMT1011");
        $.each(tableName, function (key, value) {
            datagrid.push(getListDetail(value));
        })
        return datagrid;
    }