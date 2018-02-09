var gridCost = null;
var gridContract = null;
var TabStrip = null;
var ExchangRateDecimal = 0;
var BankID = "";
var Operator = 0;
var currentChoose = "";

$(document).ready(function () {
    gridCost = $("#GridEditLMT2052").data('kendoGrid');
    gridContract = $("#GridEditLMT2053").data('kendoGrid');
    TabStrip = $("#Tabs").kendoTabStrip().data("kendoTabStrip");
    LMF2051.AddEventControl();
    LMF2051.LayoutControl();
    $("#btnUseLoanContract").bind('click', LMF2051.btnUseLoanContract_Click);
    $("#IsUseLoanContract").bind('click', LMF2051.IsUseLoanContract_CheckedChange);
    $("#RelatedToTypeID").val('9');
});

var LMF2051 = new function () {

    // #region  ---- Member Variable ---

    this.templatediv = "<div id='{0}'></div>";
    this.btnUseLoanContract = '<a class="k-button-icontext asf-button k-button" id="btnUseLoanContract" style="margin-left: 10px; height: 25px; min-width: 27px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="asf-button-text">...</span></a>'

    // #endregion ---- Member Variable ---

    // #region  --- Private Method ---

    /**
    * Fill caption dynamic lable (parameter)
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.LoadCaptionGrid = function () {
        $($(gridCost.thead).find('th')[LMF2051.GetColIndex(gridCost, "ConvertedAmount")]).context.innerText =
            ASOFT.helper.getLanguageString("LMF2052.ConvertedAmount_LMT2052", "LMF2052", "LM");
        //$($(gridContract.thead).find('th')[LMF2051.GetColIndex(gridContract, "ConvertedAmount")]).context.innerText =
        //    ASOFT.helper.getLanguageString("LMF2052.ConvertedAmount_LMT2053", "LMF2052", "LM");
    };

    /**
    * Fill Data Grid Cost
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.FillGridTab1 = function () {
        var url = '/LM/LMF2050/GetDataGridCost';
        ASOFT.helper.postTypeJson(url, {}, function (data) {
            gridCost.dataSource.data([]);
            var results = data.data;
            var datasource = [];
            for (var i = 0; i < results.length; i++) {
                var item = {};
                item.CostID = results[i].ID;
                item.CostDescription = results[i].CostDescription;
                datasource.push(item);
            }
            gridCost.dataSource.data(datasource);
        });
        $("#BtnNext").remove();
    };

    /**
    * Fill Data Grid Contract 
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.FillGridTab2 = function (results) {
        gridContract.dataSource.data([]);
        var datasource = [];
        var exchangeRate = $("#ExchangeRate").data('kendoNumericTextBox').value();
        for (var i = 0; i < results.length; i++) {
            var item = {};
            item.ContractNo = results[i].ContractNo;
            item.ContractID = results[i].ContractID;
            item.LimitAmount = results[i].LimitAmount;
            item.LimitCAmount = results[i].LimitCAmount;
            item.OriginalAmount = results[i].OriginalAmount;
            var convertedAmount = 0;
            if (Operator == 0) {
                convertedAmount = item.OriginalAmount * exchangeRate;
            } else {
                if (exchangeRate && exchangeRate > 0) {
                    convertedAmount = item.OriginalAmount / exchangeRate;
                }
            }
            item.ConvertedAmount = convertedAmount;
            item.Notes = results[i].Description;
            datasource.push(item);
        }
        gridContract.dataSource.data(datasource);
    };

    /**
    * Layout form LMF2051
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

        // CurrencyID
        $('.ExchangeRate').css('display', 'none');
        $($('#CurrencyID').parent()).css('width', '46%');
        $($('#ExchangeRate').parent().parent()).css('width', '50%');
        $($('.CurrencyID').children()[1]).append(kendo.format(this.templatediv, 'FromCurrencyID'));
        $('div#FromCurrencyID').append($($('#CurrencyID').parent()))
        $('div#FromCurrencyID').append("<span style=\"padding-left:3px ;padding-right:3px\"></span>");
        $('div#FromCurrencyID').append($($('#ExchangeRate').parent().parent()));

        $($(".Description").parent()).find('.asf-td-caption').css('width', '10%');
        $($(".Description").parent()).find('.asf-td-field').css('width', '80%');

        $(".IsUseLoanContract .asf-td-field").append(this.btnUseLoanContract);

        var templeteButton = new this.templateAsoftButton(),
        form = $("#sysScreenID"),
        parentSysScreenID = parent.$("#sysScreenID").val();
        $('#Attach').css('display', 'none');
        if ($('#isUpdate').val() != "True") {
            $("#Attach")
                .change(function () { LMF2051.setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
                .parent()
                .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

            $($(".Attach").children()[0]).css("width", "14%");
            var cbostatus = $("#Status").data('kendoComboBox');
            if (cbostatus) {
                cbostatus.select(0)
            }
            this.LoadAddNew();
        } else {
            $(".VoucherTypeID").addClass('asf-disabled-li');
            $(".VoucherNo").addClass('asf-disabled-li');
            this.LoadEdit();
            $(".Attach").css('display', 'none');
        }
        this.SetEnableControl();
        this.LoadCaptionGrid();
    };

    /**
    * Set Enable control 
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.SetEnableControl = function () {
        $("#GridEditLMT2053").attr("AddNewRowDisabled", "false");
        $(".BankName").addClass('asf-disabled-li');
        $(".BankAccountID").addClass('asf-disabled-li');
        $(".ObjectName").addClass('asf-disabled-li');
        $(".InheritLimitOAmount").css('display', 'none');
        $(".InheritLimitFromDate").css('display', 'none');
        $(".InheritLimitToDate").css('display', 'none');

    };

    /**
    * Add event for Control 
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.AddEventControl = function () {
        $("#btnLimitVoucherNo").bind('click', LMF2051.btnChooseLimitVoucherNo_Click);
        $("#btnDeleteLimitVoucherNo").bind('click', LMF2051.btnDeleteLimitVoucherNo_Click);
        $("#VoucherTypeID").bind('change', LMF2051.cboVoucherTypeID_ValueChange);
        $("#FromDate").bind('change', LMF2051.dtm_Change);
        $("#ToDate").bind('change', LMF2051.dtm_Change);
        $(gridCost.tbody).on('change', 'td', LMF2051.GridCost_Change);
        $(gridContract.tbody).on('change', 'td', LMF2051.GridContract_Change);
        $("#CurrencyID").bind('change', LMF2051.cboCurrencyID_Change);
    };

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

                    return new LMF2051.templateAttachFile(objFileName, "file-templete", objFileID).getTemplate;
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
        "ChooseLimitVoucherNo": function (result) {
            $("#LimitVoucherID").val(result.Column01);
            $("#LimitVoucherNo").val(result.Column02);
            $("#BankName").val(result.Column04);
            $("#BankAccountID").val(result.Column05);
            $("#CurrencyID").data('kendoComboBox').value(result.Column08);
            $("#ExchangeRate").data('kendoNumericTextBox').value(result.Column09);
            $("#OriginalAmount").data('kendoNumericTextBox').value(result.Column10);
            $("#ConvertedAmount").data('kendoNumericTextBox').value(result.Column11);
            
            $("#FromDate").data('kendoDatePicker').value(result.Column06);
            $("#ToDate").data('kendoDatePicker').value(result.Column07);
            
            Operator = result.Column12;
            $("#InheritLimitFromDate").data("kendoDatePicker").value(result.Column06);
            $("#InheritLimitToDate").data("kendoDatePicker").value(result.Column07);
            $("#InheritLimitOAmount").data('kendoNumericTextBox').value(result.Column10);
            ExchangRateDecimal = result.Column13;
            BankID = result.Column14;
            LMF2051.CalculatorConvertedAmount_GridCost();
            LMF2051.CalculatorConvertedAmount_GridContract();
        },
        "ChooseUseLoanContract": function (result) {
            LMF2051.FillGridTab2(result);
        }
    };

    /*
    * Load add new
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.LoadAddNew = function () {
        setTimeout(LMF2051.FillGridTab1, 200);
        $("#btnUseLoanContract").addClass('asf-disabled-li');
        $(TabStrip.items()[1]).hide();

        // Set value default
        $("#CurrencyID").data('kendoComboBox').value(ASOFTEnvironment.BaseCurrencyID);
        $("#CurrencyID").trigger('change');
        var todayDate = kendo.toString(kendo.parseDate(new Date()), 'dd/MM/yyyy');
        $("#VoucherDate").data('kendoDatePicker').value(todayDate);
        $("#FromDate").data('kendoDatePicker').value(ASOFTEnvironment.BeginDate);
        $("#ToDate").data('kendoDatePicker').value(ASOFTEnvironment.EndDate);
    };

    /**
    * AutoGen VoucherNo when change value VoucherType
    *
    * [Kim Vu] Create New [29/11/2017]
    **/
    this.autoCode = function () {
        var url = "/LM/LMF2050/GetVoucherNoText?VoucherTypeID=" + $("#VoucherTypeID").val();
        ASOFT.helper.postTypeJson(url, {}, function (result) {
            if (result) {
                $("#VoucherNo").val(result)
            }
        })
    }

    /**
    * Calculator ConvertedAmount when Fromdate, ToDate, ConvertedAmount change
    *
    * [Kim Vu] Create New [29/11/2017]
    **/
    this.CalculatorConvertedAmount_GridCost = function () {
        gridCost.dataSource.data().forEach(function (datarow) {
            if (datarow.CostID == 0) {
                LMF2051.CalculatorConvertedAmount(datarow);
            }
        });
        gridCost.refresh();
    };

    /**
    * Calculator ConvertedAmount when ExchangeRate,CurrencyID, OriginalAmount
    *
    * [Kim Vu] Create New [29/11/2017]
    **/
    this.CalculatorConvertedAmount_GridContract = function () {
        gridContract.dataSource.data().forEach(function (datarow) {
            LMF2051.CalculatorConvertedAmount_Contract(datarow);
        });
        gridContract.refresh();
    };

    /**  
    * Calculator Contract Grid
    *
    * [Kim Vu] Create New [24/01/2018]
    **/
    this.CalculatorConvertedAmount_Contract = function (dataRow) {
        var exchangeRate = $("#ExchangeRate").data('kendoNumericTextBox').value();
        var convertedAmount = 0;
        var original = dataRow.OriginalAmount;
        if (Operator == 0) {
            convertedAmount = original * exchangeRate;
        } else {
            if (exchangeRate && exchangeRate > 0) {
                convertedAmount = original / exchangeRate;
            }
        }
        dataRow.ConvertedAmount = convertedAmount;
    }

    /**
    * Calculator ConvertedAmount for current Row
    *
    * [Kim Vu] Create New [29/11/2017]
    **/
    this.CalculatorConvertedAmount = function (dataRow) {
        var fromDate = $("#FromDate").data("kendoDatePicker");
        var toDate = $("#ToDate").data("kendoDatePicker");
        var days = 1;
        if (fromDate && toDate) {
            var total = toDate.value() - fromDate.value();
            days = Math.floor(total / (1000 * 60 * 60 * 24)) + 1;
            var costRate = dataRow.CostRate ? dataRow.CostRate : 0;
            if (days > 0) {
                dataRow.ConvertedAmount = ($("#ConvertedAmount").val() * days * dataRow.CostRate)/100 / 360;
            }
        }
    }

    /**  
    * Load Edit
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.LoadEdit = function () {
        var cbo = $("#CurrencyID").data('kendoComboBox');
        if (cbo) {
            Operator = cbo.dataItem().Operator;
            ExchangRateDecimal = cbo.dataItem().ExchangRateDecimal;
        }
        LMF2051.CheckEdit();
    }

    /**  
    * Check Edit
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.CheckEdit = function () {
        // Kiem tra sua data
        ASOFT.helper.postTypeJson("/LM/LMF2050/CheckEdit?voucherID=" + LMF2051.getUrlParameter("PK"), {}, function (result) {
            if (result && result.length > 0) {
                if (result[0].Status == 3) {
                    $(".VoucherTypeID").addClass('asf-disabled-li');
                    $(".LimitVoucherNo").addClass('asf-disabled-li');
                    $(".VoucherNo").addClass('asf-disabled-li');
                    $(".VoucherDate").addClass('asf-disabled-li');
                    $(".CreditFormID").addClass('asf-disabled-li');
                    $(".FromDate").addClass('asf-disabled-li');
                    $(".CurrencyID").addClass('asf-disabled-li');
                    $(".OriginalAmount").addClass('asf-disabled-li');
                    $(".ConvertedAmount").addClass('asf-disabled-li');
                    $(".Status").addClass('asf-disabled-li');
                    $(".IsAnswerable").addClass('asf-disabled-li');
                    $(".IsUseLoanContract").addClass('asf-disabled-li');
                    $("#Tabs-1").addClass('asf-disabled-li');
                    $("#Tabs-2").addClass('asf-disabled-li');
                }
            }
            return true;
        });
    }

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
    * Test Input
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.TestInput = function () {
        var mess = [];
        var fromDate = $("#FromDate").data('kendoDatePicker').value();
        var fromDateInherit = $("#InheritLimitFromDate").data('kendoDatePicker').value();
        var toDate = $("#ToDate").data('kendoDatePicker').value();
        var toDateInherit = $("#InheritLimitToDate").data('kendoDatePicker').value();
        if (!(fromDate >= fromDateInherit && toDate <= toDateInherit)) {
            $("#FromDate").addClass('asf-focus-input-error');
            $("#ToDate").addClass('asf-focus-input-error');
            mess.push(ASOFT.helper.getMessage('LMFML000005'));
        }
        var totalGridContract = 0;
        var checkDetailContract = false;
        if ($("#IsUseLoanContract").prop('checked')) {
            gridContract.dataSource._data.forEach(function (value) {
                totalGridContract += (value.OriginalAmount ? value.OriginalAmount : 0);
                if (value.OriginalAmount > value.LimitAmount)
                    checkDetailContract = true;
            });
        }
        var totalMaster = $("#OriginalAmount").data('kendoNumericTextBox').value();
        var totalInherit = $("#InheritLimitOAmount").data('kendoNumericTextBox').value();
        if (totalGridContract > totalMaster) {
            mess.push(ASOFT.helper.getMessage('LMFML000030'));
            var i = 0;
            var grid_tr = $('#GridEditLMT2053 .k-grid-content tr');
            for (var i = 0; i < gridContract.dataSource._data.length; i++) {
                $($(grid_tr[i]).children()[LMF2051.GetColIndex(gridContract, "OriginalAmount")]).addClass('asf-focus-input-error');
            }

        } else if (checkDetailContract) {
            mess.push(ASOFT.helper.getMessage('LMFML000031'));
            var i = 0;
            var grid_tr = $('#GridEditLMT2053 .k-grid-content tr');
            for (var i = 0; i < gridContract.dataSource._data.length; i++) {
                var curentRow = gridContract.dataSource._data[i];
                if (curentRow.OriginalAmount > curentRow.LimitAmount) {
                    $($(grid_tr[i]).children()[LMF2051.GetColIndex(gridContract, "OriginalAmount")]).addClass('asf-focus-input-error');
                }
            }
        }
        else if (totalMaster > totalInherit) {
            $("#ConvertedAmount").addClass('ConvertedAmount');
        }

        var urlCheckMaster = "/LM/LMF2000/CheckSaveData";
        var dataCheckMaster = {
            originalAmount: $("#OriginalAmount").val(),
            voucherID: $("#VoucherID").val(),
            limitVoucherID: $("#LimitVoucherID").val()
        };

        ASOFT.helper.postTypeJson(urlCheckMaster, dataCheckMaster, function (result) {
            if (result == 1) {
                mess.push(ASOFT.helper.getMessage('LMFML000006'));
                LMF2051.inputError("OriginalAmount");
            }
        });

        return mess;
    }

    this.inputError = function (pVariable) {
        var element = $('#' + pVariable);
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
    // #endregion  --- Private Method ---

    // #region  --- Event Handle ---

    /**
    * Show LMF4444 when click
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.btnChooseLimitVoucherNo_Click = function (e) {
        var divisionID = $("#EnvironmentDivisionID").val();
        var voucherDate = $("#VoucherDate").val();
        var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&VoucherDate=", voucherDate, "&ScreenID=LMF2051&Type=2"].join("");
        ASOFT.asoftPopup.showIframe(urlpopup, {});
        currentChoose = "ChooseLimitVoucherNo";
    };

    /**
    * Clear value when click
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.btnDeleteLimitVoucherNo_Click = function (e) {
        $("#LimitVoucherID").val('');
        $("#LimitVoucherNo").val('');
        $("#BankName").val('');
        $("#BankAccountID").val('');
        Operator = result.Column12;
        LimitFromdate = null;
        LimitTodate = null;
        ExchangRateDecimal = result.Column13;
        BankID = null;
    };

    /**
    * UseLoanContract Click
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.btnUseLoanContract_Click = function (e) {
        var divisionID = $("#EnvironmentDivisionID").val();
        var voucherDate = $("#VoucherDate").val();
        var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&VoucherDate=", voucherDate, "&ScreenID=LMF2051_1&type=1"].join("");
        ASOFT.asoftPopup.showIframe(urlpopup, {});
        currentChoose = "ChooseUseLoanContract";
    };

    /**
    * Event checked  change of checbox
    *
    * [Kim Vu] Create New [28/11/2017]
    **/
    this.IsUseLoanContract_CheckedChange = function (e) {
        if (e.target.checked) {
            $("#btnUseLoanContract").removeClass('asf-disabled-li');
            $(TabStrip.items()[1]).show();
        } else {
            $("#btnUseLoanContract").addClass('asf-disabled-li');
            $(TabStrip.items()[1]).hide();
        }
    };

    /**
    * Grid Cost change data
    *
    * [Kim Vu] Create New [29/11/2017]
    **/
    this.GridCost_Change = function (e) {
        var selectitem = gridCost.dataItem(gridCost.select());
        var column = e.target.id;
        if (column == 'cbbCostTypeID') {
            var id = e.target.value;
            var combobox = $("#cbbCostTypeID").data("kendoComboBox");
            if (combobox) {
                var data = combobox.dataItem();
                selectitem.CostTypeID = data ? data.CostTypeID : "";
            }
            gridCost.refresh();
        } else if (column == 'CostRate') {
            selectitem.CostRate = e.target.value;
            if (selectitem.CostID == 0) {
                LMF2051.CalculatorConvertedAmount(selectitem);
            }
        }
    }

    /**
    * Grid Contract change data
    *
    * [Kim Vu] Create New [29/11/2017]
    **/
    this.GridContract_Change = function (e) {
        var selectitem = gridContract.dataItem(gridContract.select());
        var column = e.target.id;
        if (column == 'OriginalAmountLMT2053') {
            selectitem.OriginalAmount = e.target.value;
            LMF2051.CalculatorConvertedAmount_Contract(selectitem);
        }
    }

    /**
    * Event Change value ComboBox
    *
    * [Kim Vu] Create New [29/11/2017]
    **/
    this.cboVoucherTypeID_ValueChange = function (e) {
        LMF2051.autoCode();
    }

    /**  
    * datetimepicker change
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.dtm_Change = function (e) {
        LMF2051.CalculatorConvertedAmount_GridCost();
    };

    /**  
    * Fill value when currencyID change
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.cboCurrencyID_Change = function (e) {
        var cbo = $("#CurrencyID").data('kendoComboBox');
        if (cbo) {
            $("#ExchangeRate").data('kendoNumericTextBox').value(cbo.dataItem().ExchangeRate);
            Operator = cbo.dataItem().Operator;
            ExchangRateDecimal = cbo.dataItem().ExchangRateDecimal;
            LMF2051.ExchangeRate_change();
        }
    };

    /**  
    * ExchangeRate change
    *
    * [Kim Vu] Create New [24/01/2018]
    */
    this.ExchangeRate_change = function (e) {
        LMF2051.CalculatorConvertedAmount_Master();
        LMF2051.CalculatorConvertedAmount_GridContract();
    }

    this.CalculatorConvertedAmount_Master = function () {
        var original = $("#OriginalAmount").data('kendoNumericTextBox').value();
        var exchangeRate = $("#ExchangeRate").data('kendoNumericTextBox').value();
        var convertedAmount = 0;
        if (Operator == 0) {
            convertedAmount = original * exchangeRate;
        } else {
            if (exchangeRate && exchangeRate > 0) {
                convertedAmount = original / exchangeRate;
            }
        }
        $("#ConvertedAmount").data('kendoNumericTextBox').value(convertedAmount);
        LMF2051.dtm_Change();
    }

    // #endregion  --- Event Handle ---
};

// #region --- receive result from popup select data ---

function receiveResult(result) {
    this[LMF2051.ListChoose[currentChoose](result)];
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

jQuery("#ConvertedAmount").blur(LMF2051.dtm_Change);

jQuery("#OriginalAmount").blur(LMF2051.CalculatorConvertedAmount_Master);

jQuery("#ExchangeRate").blur(LMF2051.ExchangeRate_change);

/**  
* Custom check input before save
*
* [Kim Vu] Create New [04/12/2017]
**/
function CustomerCheck() {
    var mess = LMF2051.TestInput();
    if (mess.length > 0) {
        ASOFT.form.displayError("#LMF2051", mess);
        return true;
    }
}

/**  
* Bind default data when insert success mode addnew
*
* [Kim Vu] Create new [07/12/2017]
**/
function onAfterInsertSuccess(result, action) {
    if ($('#isUpdate').val() != "True") {
        LMF2051.LoadAddNew();
    }
}

deleteFile = function (jqueryObjectClick) {

    var $parentXClose = jqueryObjectClick.parent(),

        $templeteAll = $(".templeteAll"),

        $apkDelete = $parentXClose.attr("id"),

        $attach = $("#Attach"),

        $result = $attach.val().split(','),

        $resultAfterDelete = LMF2051.getResultAfterDelete($result, $apkDelete);

    $attach.val(JSON.stringify($resultAfterDelete));

    $parentXClose.remove();

    typeof $templeteAll !== "undefined"
        ? ($templeteAll.find(".file-templete").length == 0
            ? ($templeteAll.remove(), $attach.val("").trigger("change"))
            : false)
        : false;
}