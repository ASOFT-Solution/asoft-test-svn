// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #    25/01/2018  Văn Tài         Create New
// ##################################################################

// #region --- Attach ---

this.btnUpload_click = function (e) {

    CSMF2011.CurrentChoose = CSMF2011.ACTION_CHOOSE_ATTACH;

    var urlPopup3 = "/AttachFile?Type=5";
    ASOFT.asoftPopup.showIframe(urlPopup3, {});
}

this.btnDeleteUpload_click = function (e) {
    $(".templeteAll").remove();
    $("#AttachID").val("").trigger("change");
}

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

        $attach = $("#AttachID"),

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

this.ListChoose = {
    "Attach": function (result) {

        var $templeteParent = $(".templeteAll"),

            templeteAll = result.map(function (obj) {

                var objFileName = obj.AttachName,

                    objFileID = obj.APK;

                return new templateAttachFile(objFileName, "file-templete", objFileID).getTemplate;
            }),

            parentAttach = $("#AttachID").parent(),

            templeteAll = templeteAll.join(""),

            $attach = $("#AttachID");

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
}

// #endregion --- Attach ---

$(document)
    .ready(function () {

        // #region --- First Processing ---

        CSMF2011.LayoutSetting();
        
        CSMF2011.isUpdate = $('#isUpdate').val() === "True";
        CSMF2011.isInherit = $('#isInherit').val() === "True";

        // #region --- Data Processing ---

        CSMF2011.CurrentDivisionID = $("#EnvironmentDivisionID").val();
        CSMF2011.SetTextBoxValue(CSMF2011.FIELD_DIVISIONID, CSMF2011.CurrentDivisionID);

        if (!CSMF2011.isUpdate) { // Add New
            CSMF2011.GenVoucherNo();
        } else { // Update 
            CSMF2011.CurrentDivisionID = $("#" + CSMF2011.FIELD_DIVISIONID).val();
        }

        // #endregion --- Data Processing ---

        // #region  --- Xử lý đính kèm ---

        var templeteButton = new templateAsoftButton();
        $('#AttachID').css('display', 'none');
        $("#AttachID")
            .change(function () {
                setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click);
            })
            .parent()
            .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") +
                templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

        $('.FirstName').after($(".AttachID"));
        $($(".AttachID").children()[0]).css("width", "14%");

        // #endregion --- Xử lý đính kèm ---

        // #endregion --- First Processing ---

    });

// CSMF2011 : Cập nhật phiếu sửa chữa
var CSMF2011 = new function () {

    // #region --- Constants --- 

    // #region --- Actions ---

    this.ACTION_CHOOSE_ATTACH = "CHOOSE_ATTACH";

    // #endregion --- Actions ---

    this.SCREEN_ID = "CSMF2011";

    // Cấu trúc block fieldset
    this.block = '<div class="{0}"><fieldset id="{1}"><legend style="padding:10px"><label>{2}</label></legend></fieldset></div>';

    // #region --- Fields ---

    this.FIELD_DIVISIONID = "DivisionID";
    this.FIELD_ATTACHID = "AttachID";
    this.FIELD_VOUCHERNO = "VoucherNo";
    this.FIELD_VOUCHERDATE = "VoucherDate";
    this.FIELD_DISPATCHID = "DispatchID";
    this.FIELD_STATUSID = "StatusID";
    this.FIELD_STATUSNAME = "StatusName";
    this.FIELD_GSXSTATUS = "GSXStatus";
    this.FIELD_GSXSTATUSNAME = "GSXStatusName";
    this.FIELD_DISPATCHSTATUS = "DispatchStatus";
    this.FIELD_CUSTOMERTYPEID = "CustomerTypeID";
    this.FIELD_CUSTOMERTYPENAME = "CustomerTypeName";
    this.FIELD_CUSTOMERGROUPID = "CustomerGroupID";
    this.FIELD_AGENCYID = "AgencyID";
    this.FIELD_AGENCYNAME = "AgencyName";
    this.FIELD_STOREID = "StoreID";
    this.FIELD_STORENAME = "StoreName";
    this.FIELD_CUSTOMERNAME = "CustomerName";
    this.FIELD_APPELLATION = "Appellation";
    this.FIELD_APPELLATIONNAME = "AppellationName";
    this.FIELD_ADDRESS = "Address";
    this.FIELD_CITYID = "CityID";
    this.FIELD_CITYNAME = "CityName";
    this.FIELD_SERVICETYPEID = "ServiceTypeID";
    this.FIELD_PHONENUMBER = "PhoneNumber";
    this.FIELD_EMAIL = "Email";
    this.FIELD_FIRMID = "FirmID";
    this.FIELD_FIRMNAME = "FirmName";
    this.FIELD_PRODUCTTYPEID = "ProductTypeID";
    this.FIELD_PRODUCTTYPENAME = "ProductTypeName";
    this.FIELD_MODEL = "Model";
    this.FIELD_MODELNAME = "ModelName";
    this.FIELD_PRODUCTID = "ProductID";
    this.FIELD_PRODUCTNAME = "ProductName";
    this.FIELD_SERIALNUMBER = "SerialNumber";
    this.FIELD_IMEINUMBER = "IMEINumber";
    this.FIELD_PURCHASEDATE = "PurchaseDate";
    this.FIELD_ENDOFWARRANTY = "EndOfWarranty";
    this.FIELD_WARRANTYSTATUS = "WarrantyStatus";
    this.FIELD_WARRANTYSTATUSNAME = "WarrantyStatusName";
    this.FIELD_WARRANTYTYPEID = "WarrantyTypeID";
    this.FIELD_WARRANTYTYPENAME = "WarrantyTypeName";
    this.FIELD_ACCESSORYID = "AccessoryID";
    this.FIELD_ACCESSORYNAME = "AccessoryName";
    this.FIELD_SYMPTOMGROUP = "SymptomGroup";
    this.FIELD_SYMPTOMGROUPNAME = "SymptomGroupName";
    this.FIELD_SYMPTOMCODE = "SymptomCode";
    this.FIELD_SYMPTOMNAME = "SymptomName";
    this.FIELD_ISSUECODE = "IssueCode";
    this.FIELD_ISSUENAME = "IssueName";
    this.FIELD_MODIFIERCODE = "ModifierCode";
    this.FIELD_MODIFIERNAME = "ModifierName";
    this.FIELD_SYMPTOMDESCRIPTION = "SymptomDescription";

    // #endregion --- Fields ---

    // #endregion --- Constants ---

    // #region --- Variables & Controls ---

    // Variables 
    this.CurrentDivisionID = "";
    this.CurrentChoose = null;
    this.isUpdate = null;
    this.isInherit = null;
    this.SaveSuccess = false;
    this.APK = "";

    // #endregion --- Variables & Controls ---

    // #region --- Methods ---

    /**
     * Thiết lập lại layout
     * @returns {} 
     * @since [Văn Tài] Created [25/01/2018]
     */
    this.LayoutSetting = function () {

        var paddingStyle = "3px 0 3px 0";
        var paddingLeftStyle = "3px 0 3px 8px";

        $($("#CSMF2011").children()[0]).css({ "display": "none" });

        // #region --- Xử panel top ---

        var idPanel01 = "idPanel01";
        var idPanel01Left = "idPanel01Left";
        var idPanel01Right = "idPanel01Right";
        var panel01 = '<div class="container_12 ' +
            idPanel01 +
            ' ">' +
            '<div class="asf-filter-main">' +
            '<div class="grid_6">' +
            '<div class="asf-table-view ' +
            idPanel01Left +
            '" >' +
            '</div>' +
            '</div>' +
            '<div class="grid_6 line_left">' +
            '<div class="asf-table-view ' +
            idPanel01Right +
            '" >' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $(".asf-form-button").before(panel01);

        // Insert Controls
        $("." + idPanel01Left).append($("." + CSMF2011.FIELD_VOUCHERNO),
                $("." + CSMF2011.FIELD_DISPATCHID),
                $("." + CSMF2011.FIELD_STATUSID)
                );
        $("." + idPanel01Right).append($("." + CSMF2011.FIELD_VOUCHERDATE),
                $("." + CSMF2011.FIELD_DISPATCHSTATUS),
                $("." + CSMF2011.FIELD_GSXSTATUS)
                );

        // #endregion --- Xử panel top ---

        // #region --- panel: Thông tin khách hàng ---

        //! Count: 11 fields

        var idPanel02 = "idPanel02";
        var idFieldset02 = "idFieldset02";
        var languagePanel02 = CSMF2011.GetLanguageFromServer("CSMF2011.CustomerInfo");
        var block02 = CSMF2011.block.format(idPanel02, idFieldset02, languagePanel02);
        $(".asf-form-button").before(block02);

        // Insert Controls
        $("#" + idFieldset02).append($("." + CSMF2011.FIELD_CUSTOMERTYPEID),
                $("." + CSMF2011.FIELD_CUSTOMERGROUPID),
                $("." + CSMF2011.FIELD_AGENCYID),
                $("." + CSMF2011.FIELD_STOREID),
                $("." + CSMF2011.FIELD_CUSTOMERNAME),
                $("." + CSMF2011.FIELD_APPELLATION),
                $("." + CSMF2011.FIELD_ADDRESS),
                $("." + CSMF2011.FIELD_CITYID),
                $("." + CSMF2011.FIELD_SERVICETYPEID),
                $("." + CSMF2011.FIELD_PHONENUMBER),
                $("." + CSMF2011.FIELD_EMAIL)
                );

        $("." + CSMF2011.FIELD_CUSTOMERTYPEID).addClass("block-left");
        $("." + CSMF2011.FIELD_AGENCYID).addClass("block-left");
        $("." + CSMF2011.FIELD_CUSTOMERNAME).addClass("block-left");
        $("." + CSMF2011.FIELD_CITYID).addClass("block-left");
        $("." + CSMF2011.FIELD_PHONENUMBER).addClass("block-left");

        $("." + CSMF2011.FIELD_CUSTOMERGROUPID).addClass("block-right");
        $("." + CSMF2011.FIELD_STOREID).addClass("block-right");
        $("." + CSMF2011.FIELD_APPELLATION).addClass("block-right");
        $("." + CSMF2011.FIELD_SERVICETYPEID).addClass("block-right");
        $("." + CSMF2011.FIELD_EMAIL).addClass("block-right");

        $("#" + idFieldset02 + " .asf-filter-V2").css({ "clear": "inherit", "padding": paddingStyle });

        // Inputs
        $("#" + idFieldset02 + " .asf-filter-V2 .asf-filter-input").css("width", "71%");

        // Cột phải
        $("#" + idFieldset02).find(".block-right").css({ "border-left": "1px solid #b2b2b2", "padding": paddingLeftStyle });

        // Xử lý fields địa chỉ
        $('label[for="' + CSMF2011.FIELD_ADDRESS + '"]').parent().css("width", "13%");
        $('#' + CSMF2011.FIELD_ADDRESS).parent().css({ "width": "85.8%" });
        $("." + CSMF2011.FIELD_ADDRESS).css({ "float": "left", "width": "100%" });

        // #endregion --- panel: Thông tin khách hàng ---

        // #region --- panel: Thông tin sản phẩm  ---

        //! Count: 10 fields

        var idPanel03 = "idPanel03";
        var idFieldset03 = "idFieldset03";
        var languagePanel03 = CSMF2011.GetLanguageFromServer("CSMF2011.ProductInfo");
        var block03 = CSMF2011.block.format(idPanel03, idFieldset03, languagePanel03);
        $(".asf-form-button").before(block03);

        $("#" + idFieldset03).append($("." + CSMF2011.FIELD_FIRMID),
                $("." + CSMF2011.FIELD_PRODUCTTYPEID),
                $("." + CSMF2011.FIELD_MODEL),
                $("." + CSMF2011.FIELD_PRODUCTID),
                $("." + CSMF2011.FIELD_SERIALNUMBER),
                $("." + CSMF2011.FIELD_IMEINUMBER),
                $("." + CSMF2011.FIELD_PURCHASEDATE),
                $("." + CSMF2011.FIELD_ENDOFWARRANTY),
                $("." + CSMF2011.FIELD_WARRANTYSTATUS),
                $("." + CSMF2011.FIELD_WARRANTYTYPEID),
                $("." + CSMF2011.FIELD_ACCESSORYID)
            );

        // #region --- Origin Style ---

        $("." + CSMF2011.FIELD_PRODUCTTYPEID).addClass("block-left");
        $("." + CSMF2011.FIELD_SERIALNUMBER).addClass("block-left");
        $("." + CSMF2011.FIELD_PURCHASEDATE).addClass("block-left");
        $("." + CSMF2011.FIELD_WARRANTYSTATUS).addClass("block-left");

        $("." + CSMF2011.FIELD_MODEL).addClass("block-right");
        $("." + CSMF2011.FIELD_IMEINUMBER).addClass("block-right");
        $("." + CSMF2011.FIELD_ENDOFWARRANTY).addClass("block-right");
        $("." + CSMF2011.FIELD_WARRANTYTYPEID).addClass("block-right");

        $("." + CSMF2011.FIELD_FIRMID).css({ "clear": "inherit", "padding": paddingStyle });
        $("." + CSMF2011.FIELD_PRODUCTTYPEID).css({ "clear": "inherit", "padding": paddingStyle });
        $("." + CSMF2011.FIELD_MODEL).css({ "clear": "inherit", "padding": paddingStyle });
        $("." + CSMF2011.FIELD_PRODUCTID).css({ "clear": "inherit", "padding": paddingStyle });
        $("." + CSMF2011.FIELD_SERIALNUMBER).css({ "clear": "inherit", "padding": paddingStyle });
        $("." + CSMF2011.FIELD_IMEINUMBER).css({ "clear": "inherit", "padding": paddingStyle });
        $("." + CSMF2011.FIELD_PURCHASEDATE).css({ "clear": "inherit", "padding": paddingStyle });
        $("." + CSMF2011.FIELD_ENDOFWARRANTY).css({ "clear": "inherit", "padding": paddingStyle });
        $("." + CSMF2011.FIELD_WARRANTYSTATUS).css({ "clear": "inherit", "padding": paddingStyle });
        $("." + CSMF2011.FIELD_WARRANTYTYPEID).css({ "clear": "inherit", "padding": paddingStyle });
        $("." + CSMF2011.FIELD_ACCESSORYID).css({ "clear": "inherit", "padding": paddingStyle });

        // #endregion --- Origin Style ---

        // Inputs
        $("#" + idFieldset03 + " .asf-filter-V2 .asf-filter-input").css("width", "71%");

        // Cột phải
        $("#" + idFieldset03).find(".block-right").css({ "border-left": "1px solid #b2b2b2", "padding": paddingLeftStyle });

        // #region --- Xử lý fields: Hãng, Mã sản phẩm, Phụ kiện đính kèm ---
        $('label[for="' + CSMF2011.FIELD_FIRMID + '"]').parent().css("width", "14.1%");
        $('#' + CSMF2011.FIELD_FIRMID).parent().css({ "width": "85.8%" });
        $("." + CSMF2011.FIELD_FIRMID).css({ "float": "left", "width": "100%" });
        $("." + CSMF2011.FIELD_FIRMID + " .asf-filter-input").css({ "float": "left", "width": "40.7%" });

        $('label[for="' + CSMF2011.FIELD_PRODUCTID + '"]').parent().css("width", "14%");
        $('#' + CSMF2011.FIELD_PRODUCTID).parent().css({ "width": "85.8%" });
        $("." + CSMF2011.FIELD_PRODUCTID).css({ "float": "left", "width": "100%" });
        $("." + CSMF2011.FIELD_PRODUCTID + " .asf-filter-input").css({ "float": "left" });
        $("." + CSMF2011.FIELD_PRODUCTID + " .asf-filter-input .asf-textbox").css({ "width": "91%" });
        $("." + CSMF2011.FIELD_PRODUCTID + " .asf-filter-input .k-button").css({ "position": "", "right": "" });

        $('label[for="' + CSMF2011.FIELD_ACCESSORYID + '"]').parent().css("width", "14%");
        $('#' + CSMF2011.FIELD_ACCESSORYID).parent().css({ "width": "85.8%" });
        $("." + CSMF2011.FIELD_ACCESSORYID).css({ "float": "left", "width": "100%" });
        $("." + CSMF2011.FIELD_ACCESSORYID + " .asf-filter-input").css({ "float": "left" });
        $("." + CSMF2011.FIELD_ACCESSORYID + " .asf-filter-input .asf-textbox").css({ "width": "91%" });
        $("." + CSMF2011.FIELD_ACCESSORYID + " .asf-filter-input .k-button").css({ "position": "", "right": "" });
        // #endregion --- Xử lý fields: Hãng, Mã sản phẩm, Phụ kiện đính kèm ---

        // #endregion --- panel: Thông tin sản phẩm  ---

        // #region --- panel: Thông tin lỗi ---

        var idPanel04 = "idPanel04";
        var idFieldset04 = "idFieldset04";
        var languagePanel04 = CSMF2011.GetLanguageFromServer("CSMF2011.ErrorInfo");
        var block04 = CSMF2011.block.format(idPanel04, idFieldset04, languagePanel04);
        $(".asf-form-button").before(block04);

        // Insert Controls
        $("#" + idFieldset04).append($("." + CSMF2011.FIELD_SYMPTOMGROUP),
                $("." + CSMF2011.FIELD_SYMPTOMCODE),
                $("." + CSMF2011.FIELD_ISSUECODE),
                $("." + CSMF2011.FIELD_MODIFIERCODE),
                $("." + CSMF2011.FIELD_SYMPTOMDESCRIPTION)
                );

        $("." + CSMF2011.FIELD_SYMPTOMGROUP).addClass("block-left");
        $("." + CSMF2011.FIELD_ISSUECODE).addClass("block-left");

        $("." + CSMF2011.FIELD_SYMPTOMCODE).addClass("block-right");
        $("." + CSMF2011.FIELD_MODIFIERCODE).addClass("block-right");

        $("#" + idFieldset04 + " .asf-filter-V2").css({ "clear": "inherit", "padding": paddingStyle });

        // Inputs
        $("#" + idFieldset04 + " .asf-filter-V2 .asf-filter-input").css("width", "71%");

        // Cột phải
        $("#" + idFieldset04).find(".block-right").css({ "border-left": "1px solid #b2b2b2", "padding": paddingLeftStyle });

        // Xử lý fields mô tả lỗi
        $('label[for="' + CSMF2011.FIELD_SYMPTOMDESCRIPTION + '"]').parent().css("width", "13%");
        $('#' + CSMF2011.FIELD_SYMPTOMDESCRIPTION).parent().css({ "width": "85.8%" });
        $("." + CSMF2011.FIELD_SYMPTOMDESCRIPTION).css({ "float": "left", "width": "100%" });

        // #endregion --- panel: Thông tin lỗi ---

        // #region --- Đính kèm ---

        var panel05 = '<div class="container_12  ">' +
           '<div class="asf-filter-main AttachGroup">' +
           '</div>' +
           '</div>';

        $(".asf-form-button").before(panel05);
        $(".AttachGroup").append($("." + CSMF2011.FIELD_ATTACHID));
        $("#" + CSMF2011.FIELD_ATTACHID).parent().css({ "width": "85.5%" });

        // #endregion --- Đính kèm ---
    };

    // #region --- Utilities ---

    // Kiểm tra không phải null hay undefined
    this.IsNotNullOrUndefined = function (checker) {
        return (typeof (checker) != 'undefined' && checker != null);
    };

    /**
     * Kiểm tra chuỗi rỗng
     * @param {} str 
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.IsEmptyString = function (str) {
        return (!str || 0 === str.length);
    }

    /**
     * Lấy ngôn ngữ từ Server
     * @param {} languageID 
     * @returns {} 
     * @since [Văn Tài] Created [03/10/2017]
     */
    this.GetLanguageFromServer = function (languageID) {
        var language = ASOFT.helper.getLanguageString(languageID, $('#sysScreenID').val(), "CSM");
        return (CSMF2011.IsNotNullOrUndefined(language) ? language : "Undefined");
    }

    /**
     * Lấy giá trị Textbox
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.GetTextBoxValue = function (elementID) {
        var value = $("#" + elementID).val();
        if (SCREEN1031.IsNotNullOrUndefined(value)) return value;
        return "";
    }

    /**
     * Lấy giá trị của DateTimePicker
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.GetDateTimePickerValue = function (elementID) {
        return $("#" + elementID).data("kendoDatePicker").value();
    }

    /**
     * Lấy toàn bộ dữ liệu ComboBox được chọn
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.GetComboBoxValueItem = function (elementID) {
        var combo = $("#" + elementID).data("kendoComboBox");
        return combo.dataItem(combo.select());
    }

    /**
     * Set giá trị textbox
     * @param {} elementID 
     * @param {} value 
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.SetTextBoxValue = function (elementID, value) {
        $("#" + elementID).val(value);
    }

    /**
     * Set giá trị control dateTimePicker
     * @param {} elementID 
     * @param {} value 
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.SetDateTimePickerValue = function (elementID, value) {
        $("#" + elementID).data("kendoDatePicker").value(value);
    }

    /**
     * Set giá trị control ComboBox
     * @param {} elementID 
     * @param {} value 
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.SetComboBoxValue = function (elementID, value) {
        $("#" + elementID).data("kendoComboBox").value(value);
    }

    /**
     * Check giá trị cho RadioButton
     * @param {} element 
     * @param {} value 
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.SetRadioButtonValue = function (elementID, value) {
        $('input:radio[id="' + elementID + '"][value="' + value + '"]').prop('checked', true);
    }

    /**
     * Hiển thị lỗi
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [04/10/2017]
     */
    this.ShowElementError = function (elementID) {
        $("#" + elementID).addClass('asf-focus-input-error');
    }

    /**
     * Hiển thị lỗi combo 
     * @returns {} 
     * @since [Văn Tài] Created [06/10/2017]
     */
    this.ShowComboError = function (comboID) {
        $("#" + comboID).parent().addClass("asf-focus-input-error");
    }

    /**
     * Xóa các báo lỗi
     * @returns {} 
     * @since [Văn Tài] Created [06/10/2017]
     */
    this.RemoveElementError = function () {
        $(".asf-focus-input-error").removeClass("asf-focus-input-error");
    }

    /**
     * Ẩn lỗi
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [04/10/2017]
     */
    this.HideElementError = function (elementID) {
        $("#" + elementID).removeClass('asf-focus-input-error');
    }

    /**
     * Thực hiện xóa Message thông báo
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.ClearMessageBox = function () {
        ASOFT.form.clearMessageBox();
        $(".asf-focus-input-error").removeClass("asf-focus-input-error");
    }

    /**
     * Hiển thị nội dung lỗi
     * @param {} message_array 
     * @returns {} 
     * @since [Văn Tài] Created [06/10/2017]
     */
    this.ShowMessageErrors = function (message_array) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), message_array, null);
    }

    // #endregion --- Utilities ---

    // #endregion --- Methods ---
};

// #region --- Global Callback ---

function receiveResult(result) {
    // Dữ liệu file đính kèm
    if (CSMF2011.CurrentChoose == CSMF2011.ACTION_CHOOSE_ATTACH) {
        this[ListChoose['Attach'](result)];
    }
}

// #endregion --- Global Callback ---