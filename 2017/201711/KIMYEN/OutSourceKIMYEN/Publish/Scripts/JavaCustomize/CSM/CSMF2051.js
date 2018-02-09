var currentChoose = "";
var VoucherNo = "";
var VoucherDate = null;
var LastKey = 0;
$(document).ready(function () {
    CSMF2051.Layout();
    CSMF2051.AddEvent();
});

/**  
* Object CSMF2051
*
* [Kim Vu] Create New [30/01/2018]
**/
var CSMF2051 = new function () {

    /**  
    * Block control
    *
    * [Kim Vu] Create New [19/01/2018]
    **/
    this.block = '<div class="{0}"><fieldset id="{1}"><legend style="padding:10px"><label>{2}</label></legend></fieldset></div>';

    /**  
    * Div Container Attach
    *
    * [Kim Vu] Create New [19/01/2018]
    **/
    this.divfilter_main = '<div class ="asf-filter-main" id="dAttach"></div>';

    /**  
    * Layout Form
    *
    * [Kim Vu] Create New [19/01/2018]
    **/
    this.Layout = function () {

        var divNotes = $(".Notes").parent();
        var text = ASOFT.helper.getLanguageString("CSMF2051.Group2", "CSMF2051", "CSM");

        // Add Block right thông tin bên giao
        $(divNotes).after(kendo.format(this.block, "grid_6 omega float_right", "Group2", text));

        // Nạp control vào group2
        $("#Group2").append($(".DispatchReceiveName"),
            $(".StoreReceiveName"),
            $(".AddressReceive"),
            $(".ContactorReceive"),
            $(".TelReceive"),
            $(".EmailReceive"),
            $(".SoldToReceive"),
            $(".ShipToReceive"))

        // Add Block left thông tin bên giao
        text = ASOFT.helper.getLanguageString("CSMF2051.Group1", "CSMF2051", "CSM");
        $(divNotes).after(kendo.format(this.block, "grid_6_1 alpha float_left", "Group1", text));
        // Nạp control vào group1
        $("#Group1").append($(".DispatchSendName"),
            $(".StoreSendName"),
            $(".AddressSend"),
            $(".ContactorSend"),
            $(".TelSend"),
            $(".EmailSend"),
            $(".SoldToSend"),
            $(".ShipToSend"))

        // Xử lí layout Attach        
        if ($('#isUpdate').val() != "True") {
            $($("#Group2").parent()).after(this.divfilter_main);
            $("#dAttach").append($(".Attach"));
            $(".Attach .asf-filter-input").prepend($(".Attach label"));
            $('#Attach').css('display', 'none');
            var templeteButton = new this.templateAsoftButton(),
                            form = $("#sysScreenID"),
                            parentSysScreenID = parent.$("#sysScreenID").val();
            $("#Attach")
                .change(function () { CSMF2051.setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), CSMF2051.btnDeleteUpload_click); })
                .parent()
                .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "CSMF2051.btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));
        } else {
            $(".Attach").css('display', 'none');
        }

        // Disabled control
        $(".AddressSend").addClass('asf-disabled-li');
        $(".ContactorSend").addClass('asf-disabled-li');
        $(".TelSend").addClass('asf-disabled-li');
        $(".EmailSend").addClass('asf-disabled-li');
        $(".SoldToSend").addClass('asf-disabled-li');
        $(".ShipToSend").addClass('asf-disabled-li');

        $(".AddressReceive").addClass('asf-disabled-li');
        $(".ContactorReceive").addClass('asf-disabled-li');
        $(".TelReceive").addClass('asf-disabled-li');
        $(".EmailReceive").addClass('asf-disabled-li');
        $(".SoldToReceive").addClass('asf-disabled-li');
        $(".ShipToReceive").addClass('asf-disabled-li');
    }

    /**  
    * Add event for control
    * 
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.AddEvent = function () {
        $("#btnDispatchSendName").bind('click', CSMF2051.btnObject_Click);
        $("#btnStoreSendName").bind('click', CSMF2051.btnObject_Click);
        $("#btnDispatchReceiveName").bind('click', CSMF2051.btnObject_Click);
        $("#btnStoreReceiveName").bind('click', CSMF2051.btnObject_Click);
        $("#btnSendUnitName").bind('click', CSMF2051.btnUnit_click);

        $("#btnDeleteSendUnitName").bind('click', CSMF2051.btnDeleteUnit_Click);
        $("#btnDeleteDispatchSendName").bind('click', CSMF2051.btnDeleteObject_Click);
        $("#btnDeleteStoreSendName").bind('click', CSMF2051.btnDeleteObject_Click);
        $("#btnDeleteDispatchReceiveName").bind('click', CSMF2051.btnDeleteObject_Click);
        $("#btnDeleteStoreReceiveName").bind('click', CSMF2051.btnDeleteObject_Click);

        if ($('#isUpdate').val() != "True") {
            CSMF2051.LoadAddNew();
        }
    }

    /**  
    * Test Input
    *
    * [Kim Vu] Create New [30/01/218]
    **/
    this.CheckInput = function () {
        ASOFT.form.clearMessageBox();

        if ($("#SendUnitID").val() == "") {
            CSMF2051.inputError("SendUnitName");
            var msg = ASOFT.helper.getMessage("00ML000039");
            ASOFT.form.displayError("#CSMF2051", kendo.format(msg, ASOFT.helper.getLanguageString("CSMF2051.SendUnitName", "CSMF2051", "CSM")));
            return true;
        }

        if ($("#DispatchSendID").val() == "") {
            CSMF2051.inputError("DispatchSendName");
            var msg = ASOFT.helper.getMessage("00ML000039");
            ASOFT.form.displayError("#CSMF2051", kendo.format(msg, ASOFT.helper.getLanguageString("CSMF2051.DispatchSendName", "CSMF2051", "CSM")));
            return true;
        }

        if ($("#DispatchReceiveID").val() == "") {
            CSMF2051.inputError("DispatchReceiveName");
            var msg = ASOFT.helper.getMessage("00ML000039");
            ASOFT.form.displayError("#CSMF2051", kendo.format(msg, ASOFT.helper.getLanguageString("CSMF2051.DispatchReceiveName", "CSMF2051", "CSM")));
            return true;
        }

        if ($("#isUpdate").val() != "True") {
            var checkUniqueVoucherNo = false;
            var url = "/CSM/CSMF2050/CheckUniqueVoucherNo/";
            ASOFT.helper.postTypeJson(url, { voucherNo: $("#VoucherNo").val() }, function (result) {
                if (result) {
                    checkUniqueVoucherNo = true;
                }
            });

            // Trung so chung tu
            if (checkUniqueVoucherNo) {
                CSMF2051.inputError("VoucherNo");
                var msg = ASOFT.helper.getMessage("CSFML000003");
                ASOFT.form.displayError("#CSMF2051", kendo.format(msg, ASOFT.helper.getLanguageString("CSMF2051.VoucherNo", "CSMF2051", "CSM")));
                return true;
            }

            var checkUniqueAWBNo = false;
            var url = "/CSM/CSMF2050/CheckUniqueAWBNo/";
            ASOFT.helper.postTypeJson(url, { AWBNo: $("#AWBNo").val() }, function (result) {
                if (result) {
                    checkUniqueAWBNo = true;
                }
            });

            // Trung so AWB
            if (checkUniqueAWBNo) {
                CSMF2051.inputError("AWBNo");
                var msg = ASOFT.helper.getMessage("CSFML000003");
                ASOFT.form.displayError("#CSMF2051", kendo.format(msg, ASOFT.helper.getLanguageString("CSMF2051.AWBNo", "CSMF2051", "CSM")));
                return true;
            }
        }

        var checkdispatchSendID = false;
        var url = "/CSM/CSMF2050/CheckDataDispatchSendID/";
        ASOFT.helper.postTypeJson(url, { dispatchSendID: $("#DispatchSendID").val() }, function (result) {
            if (result) {
                checkdispatchSendID = true;
            }
        });

        // Check dispatchID send
        if (checkdispatchSendID) {
            CSMF2051.inputError("StoreSendName");
            var msg = ASOFT.helper.getMessage("00ML000039");
            ASOFT.form.displayError("#CSMF2051", kendo.format(msg, ASOFT.helper.getLanguageString("CSMF2051.StoreSendName", "CSMF2051", "CSM")));
            return true;
        }

        var checkdispatchReceiveID = false;
        var url = "/CSM/CSMF2050/CheckDataDispatchReceiveID/";
        ASOFT.helper.postTypeJson(url, { dispatchReceiveID: $("#DispatchReceiveID").val() }, function (result) {
            if (result) {
                checkdispatchReceiveID = true;
            }
        });

        // Check dispatchID Receive
        if (checkdispatchReceiveID) {
            CSMF2051.inputError("StoreReceiveName");
            var msg = ASOFT.helper.getMessage("00ML000039");
            ASOFT.form.displayError("#CSMF2051", kendo.format(msg, ASOFT.helper.getLanguageString("CSMF2051.StoreReceiveName", "CSMF2051", "CSM")));
            return true;
        }
    }

    /**  
    * Add class error
    *
    * [Kim Vu] Create New [26/01/2018]
    **/
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
    * Get relate object id
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.GetRelateObjectID = function (id) {
        switch (id) {
            case "btnDeleteDispatchSendName":
                return $("#DispatchSendID").val();
            case "btnDeleteDispatchReceiveName":
                return $("#DispatchReceiveID").val();
            default:
                return "";
        }
    }

    /**  
    * Load AddNew
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.LoadAddNew = function () {
        $("#VoucherDate").data('kendoDatePicker').value(new Date());
        CSMF2051.LoadVoucherNo();
        var url = "/CSM/CSMF2050/GetDefaultObjectSendAndReceive";
        ASOFT.helper.postTypeJson(url, {}, function (result) {
            if (result.length > 0) {
                $("#DispatchReceiveName").val(result[0].DispatchID);
                $("#DispatchReceiveID").val(result[0].DispatchName);
                $("#StoreReceiveID").val(result[0].StoreID);
                $("#StoreReceiveName").val(result[0].StoreName);
                $("#SoldToReceive").val(result[0].SoldTo1);
                $("#ShipToReceive").val(result[0].ShipTo1);
                $("#ContactorReceive").val(result[0].Contactor1);
                $("#TelReceive").val(result[0].Tel1);
                $("#EmailReceive").val(result[0].Email1);
                $("#AddressReceive").val(result[0].Address1);

                $("#DispatchSendID").val(result[0].ObjectID);
                $("#DispatchSendName").val(result[0].ObjectName);
                $("#SoldToSend").val(result[0].SoldTo);
                $("#ShipToSend").val(result[0].ShipTo);
                $("#ContactorSend").val(result[0].Contactor);
                $("#TelSend").val(result[0].Tel);
                $("#EmailSend").val(result[0].Email);
                $("#AddressSend").val(result[0].Address);
            }
        });

        // Bind event change voucherDate
        $("#VoucherDate").bind('change', CSMF2051.LoadVoucherNo);
    }

    /**  
    * Load VoucherNo
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.LoadVoucherNo = function () {
        VoucherDate = $("#VoucherDate").data('kendoDatePicker').value();
        var url = "/CSM/CSMF2050/GetVoucherNoText";
        ASOFT.helper.postTypeJson(url, { voucherDate: VoucherDate }, function (result) {
            $("#VoucherNo").val(result.newKey);
            VoucherNo = result.newKey;
            LastKey = result.lastkey;
        });
    }

    // #region --- Attach ---

    this.btnUpload_click = function (e) {
        var urlPopup3 = "/AttachFile?Type=5";
        ASOFT.asoftPopup.showIframe(urlPopup3, {});
        currentChoose = "Attach";
    }

    this.btnDeleteUpload_click = function (e) {
        $(".templeteAll").remove();
        $("#Attach").val("").trigger("change");
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

            $attach = $("#Attach"),

            $result = $attach.val().split(','),

            $resultAfterDelete = CSMF2051.getResultAfterDelete($result, $apkDelete);

        $attach.val(JSON.stringify($resultAfterDelete));

        $parentXClose.remove();

        typeof $templeteAll !== "undefined"
            ? ($templeteAll.find(".file-templete").length == 0
                ? ($templeteAll.remove(), $attach.val("").trigger("change"))
                : false)
            : false;
    }

    // #endregion --- Attach ---

    this.ListChoose = {
        "Attach": function (result) {

            var $templeteParent = $(".templeteAll"),

                templeteAll = result.map(function (obj) {

                    var objFileName = obj.AttachName,

                        objFileID = obj.APK;

                    return new CSMF2051.templateAttachFile(objFileName, "file-templete", objFileID).getTemplate;
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
                CSMF2051.deleteFile($(this));
            });
        },
        "btnDispatchSendName": function (result) {
            $("#DispatchSendID").val(result.ObjectID);
            $("#DispatchSendName").val(result.ObjectName);
            $("#StoreSendID").val('');
            $("#StoreSendName").val('');
        },
        "btnStoreSendName": function (result) {
            $("#StoreSendID").val(result.ObjectID);
            $("#StoreSendName").val(result.ObjectName);
            CSMF2051.LoadDefaultDispatchID(true, result.ObjectID);
        },
        "btnDispatchReceiveName": function (result) {
            $("#DispatchReceiveName").val(result.ObjectName);
            $("#DispatchReceiveID").val(result.ObjectID);
            $("#StoreReceiveID").val('');
            $("#StoreReceiveName").val('');
        },
        "btnStoreReceiveName": function (result) {
            $("#StoreReceiveID").val(result.ObjectID);
            $("#StoreReceiveName").val(result.ObjectName);
            CSMF2051.LoadDefaultDispatchID(false, result.ObjectID);
        },
        "btnSendUnitName": function (result) {
            $("#SendUnitName").val(result.ObjectName);
            $("#SendUnitID").val(result.ObjectID);
        }
    }

    /**  
    * Load DispatchID
    *
    * [Kim Vu] Create New [01/02/2018]
    **/
    this.LoadDefaultDispatchID = function (send, storeID) {
        var url = "/CSM/CSMF2050/GetDataDispatchID";
        ASOFT.helper.postTypeJson(url, { dispatchID: storeID }, function (result) {
            if (send) {
                $("#DispatchSendName").val(result.ObjectID);
                $("#DispatchSendID").val(result.ObjectName);
            } else {
                $("#DispatchReceiveName").val(result.ObjectID);
                $("#DispatchReceiveID").val(result.ObjectName);
            }
        });

    }

    // #region --- Event Handle --

    /**  
    * Choose Unit
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.btnUnit_click = function (e) {
        var url = "/PopupSelectData/Index/CSM/CSMF2006?ScreenID=CSMF2051";
        ASOFT.asoftPopup.showIframe(url, {});
        currentChoose = e.currentTarget.id;
    }

    /**  
    * Delete Unit
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.btnDeleteUnit_Click = function (e) {
        $("#SendUnitName").val('');
        $("#SendUnitID").val('');
    }

    /**  
    * Object lick show CSMF2004
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.btnObject_Click = function (e) {
        var RelationObjectID = CSMF2051.GetRelateObjectID(e.currentTarget.id);
        var type = 0;
        if (e.currentTarget.id == "btnStoreSendName" || e.currentTarget.id == "btnStoreReceiveName")
            type = 1;
        var url = "/PopupSelectData/Index/CSM/CSMF2004?RelationObjectID=" + RelationObjectID + "&ScreenID=CSMF2051&Type1=" + type;
        ASOFT.asoftPopup.showIframe(url, {});
        currentChoose = e.currentTarget.id;
    }

    /**  
    * Delete Object click
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.btnDeleteObject_Click = function (e) {
        switch (e.target.id) {
            case "btnDeleteDispatchSendName":
                $("#DispatchSendID").val('');
                $("#DispatchSendName").val('');
                break;
            case "btnDeleteStoreSendName":
                $("#StoreSendID").val('');
                $("#StoreSendName").val('');
                break;
            case "btnDeleteDispatchReceiveName":
                $("#DispatchReceiveID").val('');
                $("#DispatchReceiveName").val('');
                break;
            case "btnDeleteStoreReceiveName":
                $("#StoreReceiveID").val('');
                $("#StoreReceiveName").val('');
                break;
        }
    }

    // #endregion --- Event Handle --
}

/**  
* receive Result
*
* [Kim Vu] Create New [01/02/2018]
**/
function receiveResultVersion2(result) {
    this[CSMF2051.ListChoose[currentChoose](result)];
    if (currentChoose == "btnDispatchReceiveName" || currentChoose == "btnStoreReceiveName") {
        $("#SoldToReceive").val(result.SoldTo);
        $("#ShipToReceive").val(result.ShipTo);
        $("#ContactorReceive").val(result.Contactor);
        $("#TelReceive").val(result.Tel);
        $("#EmailReceive").val(result.Email);
        $("#AddressReceive").val(result.Address);
    } else if (currentChoose == "btnDispatchSendName" || currentChoose == "btnStoreSendName") {
        $("#SoldToSend").val(result.SoldTo);
        $("#ShipToSend").val(result.ShipTo);
        $("#ContactorSend").val(result.Contactor);
        $("#TelSend").val(result.Tel);
        $("#EmailSend").val(result.Email);
        $("#AddressSend").val(result.Address);
    }
};

/**  
* receive Result
*
* [Kim Vu] Create New [01/02/2018]
**/
function receiveResult(result) {
    this[CSMF2051.ListChoose[currentChoose](result)];
}

/**  
* Xu li sau khi chay insert thanh cong
*
* [Kim Vu] Create New [01/02/2018]
**/
function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && $("#isUpdate").val() != "True") {
        $("#VoucherDate").data('kendoDatePicker').value(VoucherDate)
        var url = "/CSM/CSMF2050/UpdateVoucherNo";
        ASOFT.helper.postTypeJson(url, { VoucherNo: VoucherNo, tableID: "CSMT2050", VoucherDate: VoucherDate }, null);
        CSMF2051.LoadVoucherNo();
    }
}

/**  
* Customer Check
*
* [Kim Vu] Create New [01/02/2018]
**/
function CustomerCheck() {
    return CSMF2051.CheckInput();
}