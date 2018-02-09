var currentChoose = "";

$(document).ready(function () {
    CSMF2001.Layout();
    CSMF2001.autocode();
    CSMF2001.btnDispatchReceiveName_click();
    CSMF2001.btnDispatchSendName_click();
    CSMF2001.btnStoreReceiveName_click();
    CSMF2001.btnStoreSendName_click();
    CSMF2001.TransferUnitName_click();
    CSMF2001.btnDeleteDispatchReceiveName();
    CSMF2001.btnDeleteDispatchSendName();
    CSMF2001.btnDeleteStoreReceiveName();
    CSMF2001.btnDeleteStoreSendName();
    CSMF2001.btnDeleteTransferUnitName();
    CSMF2001.LoadDataDefault();

});

var CSMF2001 = new function () {

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
        var text = ASOFT.helper.getLanguageString("CSMF2001.Group2", "CSMF2001", "CSM");
        var divTranferUnitName = $(".TransferTime").parent();
        divTranferUnitName.prepend($(".TransferUnitName"));
        $(".TransferUnitID").css("display", "none");

        // disabled control
        $("#AddressSend").attr("readonly", "readonly");
        $("#ContractNameSend").attr("readonly", "readonly");
        $("#PhoneNumberSend").attr("readonly", "readonly");
        $("#EmailSend").attr("readonly", "readonly");
        $("#SlodToSend").attr("readonly", "readonly");
        $("#ShipToSend").attr("readonly", "readonly");
        $("#AddressReceive").attr("readonly", "readonly");
        $("#ContactNameReceive").attr("readonly", "readonly");
        $("#PhoneNumberReceive").attr("readonly", "readonly");
        $("#EmailReceive").attr("readonly", "readonly");
        $("#SoldToReceive").attr("readonly", "readonly");
        $("#ShipToReceive").attr("readonly", "readonly");


        // Add Block right thông tin bên giao
        $(divNotes).after(kendo.format(this.block, "grid_6 omega float_right", "Group2", text));

        // Nạp control vào group2
        $("#Group2").append($(".DispatchReceiveName"),
            $(".StoreReceiveName"),
            $(".AddressReceive"),
            $(".ContactNameReceive"),
            $(".PhoneNumberReceive"),
            $(".EmailReceive"),
            $(".SoldToReceive"),
            $(".ShipToReceive"))

        // Add Block left thông tin bên giao
        text = ASOFT.helper.getLanguageString("CSMF2001.Group1", "CSMF2001", "CSM");
        $(divNotes).after(kendo.format(this.block, "grid_6_1 alpha float_left", "Group1", text));
        // Nạp control vào group1
        $("#Group1").append($(".DispatchSendName"),
            $(".StoreSendName"),
            $(".AddressSend"),
            $(".ContractNameSend"),
            $(".PhoneNumberSend"),
            $(".EmailSend"),
            $(".SlodToSend"),
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
                .change(function () { CSMF2001.setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), CSMF2001.btnDeleteUpload_click); })
                .parent()
                .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "CSMF2001.btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));
        } else {
            $(".Attach").css('display', 'none');
        }
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

            $resultAfterDelete = CSMF2001.getResultAfterDelete($result, $apkDelete);

        $attach.val(JSON.stringify($resultAfterDelete));

        $parentXClose.remove();

        typeof $templeteAll !== "undefined"
            ? ($templeteAll.find(".file-templete").length == 0
                ? ($templeteAll.remove(), $attach.val("").trigger("change"))
                : false)
            : false;
    }

    // #endregion --- Attach ---

    // #region --- Auto Code ---

    this.autocode = function () {
        var url = '/CSM/CSMF2000/GetVoucher';
        if ($("#isUpdate").val() != "True") {
            ASOFT.helper.postTypeJson(url, {}, function (result) {
                if (result) {
                    $("#VoucherNo").val(result);
                    oldVoucherNo = result;
                }
            })
        }
    }

    // #endregion --- Auto Code ---

    // #region --- Chọn đại lý bên giao ---

    this.btnDispatchSendName_click = function () {
        $("#btnDispatchSendName").on("click", function () {
            ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CSM/CSMF2004?ScreenID=CSMF2001&Type1=0&RelationObjectID=", {});
            currentChoose = "ChooseDispatchSendName";
        });
    }
    this.btnDeleteDispatchSendName = function () {
        $("#btnDeleteDispatchSendName").on("click", function () {
            $("#DispatchSendName").val("");
            $("#DispatchSendID").val("");
        });
    }
    // #endregion --- Chọn đại lý bên giao ---

    // #region --- Chọn đại lý bên nhận ---

    this.btnDispatchReceiveName_click = function () {
        $("#btnDispatchReceiveName").on("click", function () {
            ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CSM/CSMF2004?ScreenID=CSMF2001&Type1=0&RelationObjectID=", {});
            currentChoose = "ChooseDispatchReceiveName";
        });
    }
    this.btnDeleteStoreSendName = function () {
        $("#btnDeleteStoreSendName").on("click", function () {
            $("#StoreSendName").val("");
            $("#StoreSendID").val("");
        });
    }

    // #endregion --- Chọn đại lý bên nhận ---

    // #region --- Chọn cửa hàng bên giao---

    this.btnStoreSendName_click = function () {
        $("#btnStoreSendName").on("click", function () {
            currentChoose = "ChooseStoreSendName";
            var RelationObjectID = $("#DispatchSendID").val();
            ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CSM/CSMF2004?ScreenID=CSMF2001&RelationObjectID=" + RelationObjectID+"&Type1=1", {});
        });
    }
    this.btnDeleteDispatchReceiveName = function () {
        $("#btnDeleteDispatchReceiveName").on("click", function () {
            $("#DispatchReceiveName").val("");
            $("#DispatchReceiveID").val("");
        });
    }
    // #endregion --- Chọn cửa hàng bên giao ---

    // #region --- Chọn cửa hàng bên nhận ---

    this.btnStoreReceiveName_click = function () {
        $("#btnStoreReceiveName").on("click", function () {
            var RelationObjectID = $("#DispatchReceiveID").val();
            ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CSM/CSMF2004?ScreenID=CSMF2001&RelationObjectID=" + RelationObjectID+"&Type1=1", {});
            currentChoose = "ChooseStoreReceiveName";
        });
    }
    this.btnDeleteStoreReceiveName = function () {
        $("#btnDeleteStoreReceiveName").on("click", function () {
            $("#StoreReceiveName").val("");
            $("#StoreReceiveID").val("");
        });
    }
    // #endregion --- Chọn cửa hàng bên nhận ---

    // #region --- Chọn đơn vị vận chuyển ---

    this.TransferUnitName_click = function () {
        $("#btnTransferUnitName").on("click", function () {
            ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CSM/CSMF2006?ScreenID=CSMF2001", {});
            currentChoose = "ChooseTransferUnitName";
        });
    }
    this.btnDeleteTransferUnitName = function () {
        $("#btnDeleteTransferUnitName").on("click", function () {
            $("#TranferUnitName").val("");
            $("#TranferUnitID").val("");
        });
    }

    // #endregion --- Chọn đơn vị vận chuyển ---

    // #region --- Load thông tin mặc đinh cửa hàng giao, nhận ---

    this.LoadDataDefault = function () {
        var url = "/CSM/CSMF2000/LoadDataDefault"
        ASOFT.helper.postTypeJson(url, {}, function (result) {
            $("#DispatchSendID").val(result[0]["DispatchID"]);
            $("#DispatchSendName").val(result[0]["DispatchName"]);
            $("#AddressSend").val(result[0]["Address1"]);
            $("#PhoneNumberSend").val(result[0]["Tel1"]);
            $("#EmailSend").val(result[0]["Email1"]);
            $("#SoldToSend").val(result[0]["SoldTo1"]);
            $("#ShipToSend").val(result[0]["ShipTo1"]);
            $("#DispatchReceiveID").val(result[0]["ObjectID"]);
            $("#DispatchReceiveName").val(result[0]["ObjectName"]);
            $("#ContactNameReceive").val(result[0]["Contactor"]);
            $("#AddressReceive").val(result[0]["Address"]);
            $("#PhoneNumberReceive").val(result[0]["Tel"]);
            $("#EmailReceive").val(result[0]["Email"]);
            $("#SoldToReceive").val(result[0]["SoldTo"]);
            $("#ShipToReceive").val(result[0]["ShipTo"]);
        });
    }

    // #endregion --- Load thông tin mặc đinh cửa hàng giao, nhận --- 

    this.ListChoose = {
        "Attach": function (result) {

            var $templeteParent = $(".templeteAll"),

                templeteAll = result.map(function (obj) {

                    var objFileName = obj.AttachName,

                        objFileID = obj.APK;

                    return new CSMF2001.templateAttachFile(objFileName, "file-templete", objFileID).getTemplate;
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
                CSMF2001.deleteFile($(this));
            });
        },
        "ChooseDispatchSendName": function (result) {
            $("#DispatchSendID").val(result["ObjectID"]);
            $("#DispatchSendName").val(result["ObjectName"]);
        },
        "ChooseDispatchReceiveName": function (result) {
            $("#DispatchReceiveID").val(result["ObjectID"]);
            $("#DispatchReceiveName").val(result["ObjectName"]);
        },
        "ChooseStoreSendName": function (result) {
            $("#StoreSendID").val(result["ObjectID"]);
            $("#StoreSendName").val(result["ObjectName"]);
        },
        "ChooseStoreReceiveName": function (result) {
            $("#StoreReceiveID").val(result["ObjectID"]);
            $("#StoreReceiveName").val(result["ObjectName"]);
        },
        "ChooseTransferUnitName": function (result) {
            $("#TransferUnitName").val(result["ObjectName"]);
            $("#TransferUnitID").val(result["ObjectID"]);
        }
    }

    // #region --- Check tồn tại ---

    this.checkAWBNo = function () {
        var url = "/CSM/CSMF2000/CheckAWB";
        var AWBNo = $("#AWBNo").val();
        var result1 = false;
        ASOFT.helper.postTypeJson(url, { AWBNo: AWBNo }, function (result) {
            if (result=="True") {
                result1 = true;
            }
        });
        return result1;
    }

    this.checkVoucherNo = function () {
        var url = "/CSM/CSMF2000/CheckVoucherNo";
        var VoucherNo = $("#VoucherNo").val();
        var result1 = false;
        ASOFT.helper.postTypeJson(url, { VoucherNo: VoucherNo }, function (result) {
            if (result == "True") {
                result1 =  true;
            }
        });
        return result1;
    }

    this.checkDispatchReceiveID = function () {
        var url = "/CSM/CSMF2000/CheckDispatchReceiveID";
        var DispatchReceiveID = $("#DispatchReceiveID").val();
        var result1 = false;
        ASOFT.helper.postTypeJson(url, { DispatchReceiveID: DispatchReceiveID }, function (result) {
            if (result == "True") {
                result1 = true;
            }
        });
        return result1;
    }

    this.checkDispatchSendID = function () {
        var url = "/CSM/CSMF2000/CheckDispatchSendID";
        var DispatchSendID = $("#DispatchSendID").val();
        var result1 = false;
        ASOFT.helper.postTypeJson(url, { DispatchSendID: DispatchSendID }, function (result) {
            if (result == "True") {
                result1 =  true;
            }
        });
        return result1;
    }
    // #endregion --- Check tồn tại ---
}

function receiveResult(result) {
    this[CSMF2001.ListChoose[currentChoose](result)];
};

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && ($("#isUpdate").val() != "True")) {
        var url = "/CSM/CSMF2000/UpdateVoucherNo"
        ASOFT.helper.postTypeJson(url, { VoucherNo: oldVoucherNo }, null);
        autocode();
    }
}

function CustomerCheck() {
    var invalidTextBox = [];
    var message_array = [];
        if (CSMF2001.checkAWBNo()) {
            invalidTextBox.push("AWBNo");
            message_array.push(ASOFT.helper.getLabelText("AWBNo", "CSFML000003"));
        }
        if (CSMF2001.checkVoucherNo()) {
            invalidTextBox.push("VoucherNo");
            message_array.push(ASOFT.helper.getLabelText("VoucherNo", "CSFML000003"));
        }
        if (CSMF2001.checkDispatchReceiveID()) {
            invalidTextBox.push("StoreReceiveName");
            message_array.push(ASOFT.helper.getLabelText("StoreReceiveName", "00ML000039"));
        }
        if (CSMF2001.checkDispatchSendID()) {
            invalidTextBox.push("StoreSendName");
            message_array.push(ASOFT.helper.getLabelText("StoreSendName", "00ML000039"));
        }
        if (message_array.length == 0) {
            return false;
        }
        else {
            ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), message_array);
            return true;
        }         
}