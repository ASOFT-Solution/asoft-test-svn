var gridCost = null;
var ExchangRateDecimal = 0;
var Operator = 0;
var currentChoose = "";

$(document).ready(function () {    
    gridCost = $("#GridEditLMT2052").data('kendoGrid');
    var height = $("#GridEditLMT2052").height();
    if (height > 250) {
        var h = height - 250;
        $("#GridEditLMT2052").css('height', h);
        $("#GridEditLMT2052 .k-grid-content").css('height',  $("#GridEditLMT2052 .k-grid-content").height() - h);
    }
    LMF2071.AddEventControl();
    LMF2071.LayoutControl();
    $("#RelatedToTypeID").val('9');
    $("#IsType").val('1');
});

var LMF2071 = new function () {

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
        $($(gridCost.thead).find('th')[LMF2071.GetColIndex(gridCost, "ConvertedAmount")]).context.innerText =
            ASOFT.helper.getLanguageString("LMF2052.ConvertedAmount_LMT2052", "LMF2052", "LM");
    };

    /**
    * Fill Data Grid Cost
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.FillGridTab1 = function () {
        gridCost.dataSource.data([]);
        $("#BtnNext").remove();
    };

    /**  
    * After choose Inherit Data call back server get data grid
    *
    * [Kim Vu] Create new [20/12/2017]
    **/
    this.FillGridAfterInherit = function (voucherID) {
        var url = '/LM/LMF2070/GetDataGridCost';
        ASOFT.helper.postTypeJson(url, { VoucherID: voucherID }, function (data) {            
            gridCost.dataSource.data([]);
            var results = data.data;
            var datasource = [];
            for (var i = 0; i < results.length; i++) {
                var item = {};
                item.CostID = results[i].ID;
                item.CostDescription = results[i].CostDescription;
                item.ConvertedAmount = results[i].ConvertedAmount;
                item.CostTypeID = results[i].CostTypeID;
                item.Notes = results[i].Notes;
                datasource.push(item);
            }
            gridCost.dataSource.data(datasource);
        });
    }

    /**
    * Layout form LMF2071
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
                .change(function () { LMF2071.setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
                .parent()
                .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

            $($(".Attach").children()[0]).css("width", "14%");
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
        $("#GridEditLMT2052").attr("AddNewRowDisabled", "false");
    };

    /**
    * Add event for Control 
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.AddEventControl = function () {
        $("#VoucherTypeID").bind('change', this.cboVoucherTypeID_ValueChange);
        $("#FromDate").bind('change', this.dtm_Change);
        $("#ToDate").bind('change', this.dtm_Change);
        $("#CurrencyID").bind('change', LMF2071.cboCurrencyID_Change);
        $("#btnGuaranteeVoucherNo").bind('click', this.btnChooseGuaranteeVoucherNo_Click);
        $("#btnDeleteGuaranteeVoucherNo").bind('click', this.btnDeleteGuaranteeVoucherNo_Click);
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

                    return new LMF2071.templateAttachFile(objFileName, "file-templete", objFileID).getTemplate;
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
        "GuaranteeVoucherNo": function (result) {
            $("#LimitVoucherID").val(result.LimitVoucherID);
            $("#GuaranteeVoucherID").val(result.GuaranteeVoucherID);
            $("#GuaranteeVoucherNo").val(result.GuaranteeVoucherNo);
            $("#CurrencyID").data('kendoComboBox').value(result.CurrencyID);
            $("#CurrencyID").trigger('change');
            $("#OriginalAmount").data('kendoNumericTextBox').value(result.OriginalAmount);
            $("#ConvertedAmount").data('kendoNumericTextBox').value(result.ConvertedAmount);
            $("#FromDate").data('kendoDatePicker').value(result.FromDate);
            $("#ToDate").data('kendoDatePicker').value(result.ToDate);
            // parameter
            for (var i = 0; i < 20; i++) {
                var id = kendo.format("Parameter{0:00}", i + 1);
                $("#" + id).val(result[id]);
            }

            // Load grid
            LMF2071.FillGridAfterInherit(result.GuaranteeVoucherID);
        }
    };

    /*
    * Load add new
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.LoadAddNew = function () {
        setTimeout(LMF2071.FillGridTab1, 200);
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
        var url = "/LM/LMF2070/GetVoucherNoText?VoucherTypeID=" + $("#VoucherTypeID").val();
        ASOFT.helper.postTypeJson(url, {}, function (result) {
            if (result) {
                $("#VoucherNo").val(result)
            }
        })
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

        LMF2071.CheckEdit();
    }

    /**  
    * Check Edit
    *
    * [Kim Vu] Create New [04/12/2017]
    **/
    this.CheckEdit = function () {
        // Kiem tra sua data
        ASOFT.helper.postTypeJson("/LM/LMF2070/CheckEdit?voucherID=" + LMF2071.getUrlParameter("PK"), {}, function (result) {
            if (result && result.length > 0) {
                if (result[0].Status == 3) {
                    $(".VoucherTypeID").addClass('asf-disabled-li');
                    $(".GuaranteeVoucherNo").addClass('asf-disabled-li');
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
                }
            }
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
    this.btnChooseGuaranteeVoucherNo_Click = function (e) {
        var divisionID = $("#EnvironmentDivisionID").val();
        var voucherDate = $("#VoucherDate").val();
        var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&VoucherDate=", voucherDate, "&ScreenID=LMF2071&Type=2"].join("");
        ASOFT.asoftPopup.showIframe(urlpopup, {});
        currentChoose = "GuaranteeVoucherNo";
    };

    /**
    * Clear value when click
    *
    * [Kim Vu] Create New [27/11/2017]
    **/
    this.btnDeleteGuaranteeVoucherNo_Click = function (e) {
        $("#GuaranteeVoucherNo").val('');
        $("#GuaranteeVoucherID").val('');
        $("#LimitVoucherID").val('');
        gridCost.dataSource.data([]);
    };

    /**
    * Event Change value ComboBox
    *
    * [Kim Vu] Create New [29/11/2017]
    **/
    this.cboVoucherTypeID_ValueChange = function (e) {
        LMF2071.autoCode();
    }

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
        }
    };

    // #endregion  --- Event Handle ---
};

// #region --- receive result from popup select data ---

function receiveResult(result) {
    this[LMF2071.ListChoose[currentChoose](result)];
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

/**  
* Bind default data when insert success mode addnew
*
* [Kim Vu] Create new [07/12/2017]
**/
function onAfterInsertSuccess(result, action) {
    result.Status == 0
    result.Data.VoucherID (Refkey)
}

/**  
* Xóa file đính kèm client
*
* [Kim Vu] Create new [07/12/2017]
**/
deleteFile = function (jqueryObjectClick) {

    var $parentXClose = jqueryObjectClick.parent(),

        $templeteAll = $(".templeteAll"),

        $apkDelete = $parentXClose.attr("id"),

        $attach = $("#Attach"),

        $result = $attach.val().split(','),

        $resultAfterDelete = LMF2071.getResultAfterDelete($result, $apkDelete);

    $attach.val(JSON.stringify($resultAfterDelete));

    $parentXClose.remove();

    typeof $templeteAll !== "undefined"
        ? ($templeteAll.find(".file-templete").length == 0
            ? ($templeteAll.remove(), $attach.val("").trigger("change"))
            : false)
        : false;
}