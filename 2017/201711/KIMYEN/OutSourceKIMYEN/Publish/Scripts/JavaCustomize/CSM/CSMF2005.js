
$(document).ready(function () {
    CSMF2005.choosTranferUnitName();
    CSMF2005.CustomSave();
   // CustomSavePopupLayout();
});

var CSMF2005 = new function () {
    this.choosTranferUnitName = function () {
        $("#btnTransferUnitName").on("click", function () {
            ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CSM/CSMF2006?ScreenID=CSMF2005", {});
        });
    }
    this.CustomSave = function () {
        $("#Save").unbind("click");
        $("#Save").bind("click", function () {
            //var url1 = "/CSM/CSMF2000/CheckInsertUpdate";
            var url = new URL(window.location);
            var apk = url.searchParams.get("PK");
            //var data = {
            //    APK: $("#APK").val(),
            //    Status: $("#Status").val(),
            //    TransferUnitID: $("#TransferUnitID").val(),
            //    TransferTypeID: $("#TransferTypeID").val(),
            //    TimeReceive: $("#TimeReceive").val(),
            //    AWBNo: $("#AWBNo").val(),
            //    Quantity: $("#Quantity").val(),
            //    Weight: $("#Weight").val(),
            //    Package: $("#Package").val(),
            //    Notes: $("#Notes").val(),
            //};
            var data1 = {
                APK:apk,
                Status: $("#Status").val(),
                TransferUnitID: $("#ActTransferUnitID").val(),
                TransferTypeID: $("#ActTransferTypeID").val(),
                TimeReceive: $("#TimeReceive").val(),
                AWBNo: $("#ActAWBNo").val(),
                Quantity: $("#ActQuantity").val(),
                Weight: $("#ActWeight").val(),
                Package: $("#ActPackage").val(),
                Notes: $("#ActNotes").val(),
            };
            //CheckrequiredAndInlist
            var data = ASOFT.helper.dataFormToJSON(id);
            var CheckInList = [];
            if (data["CheckInList"] != undefined) {
                if (jQuery.type(data["CheckInList"]) === "string") {
                    CheckInList.push(data["CheckInList"]);
                }
                else {
                    CheckInList = data["CheckInList"];
                }
            }
            if (ASOFT.form.checkRequiredAndInList(id, CheckInList)) {
                return;
            }
            var url2 = "/CSM/CSMF2000/UpdateCSMF2005";
            ASOFT.helper.postTypeJson(url2, data1, function (result) {
                if (result == "True") {
                    ASOFT.form.displayInfo('#' + $('#sysScreenID').val(), ASOFT.helper.getMessage("00ML000015"));
                    window.parent.location.reload();
                } else {
                    ASOFT.form.displayInfo('#' + $('#sysScreenID').val(), ASOFT.helper.getMessage("00ML000062"));
                }

            });
            ////Check Insert: Update
            //ASOFT.helper.postTypeJson(url1, { APK: apk }, function (result) {
            //    if (result == "False") {
            //        var url2 = "/CSM/CSMF2000/UpdateCSMF2005";
            //        ASOFT.helper.postTypeJson(url2, data, function (result) {
            //                ASOFT.form.displayInfo('#' + $('#sysScreenID').val(), ASOFT.helper.getMessage("00ML000015"));
            //                window.parent.location.reload();
            //        });
            //    } else {
            //        var url3 = "/CSM/CSMF2000/InsertCSMF2005";
            //        ASOFT.helper.postTypeJson(url3, data1, function (result) {
            //            if (result == "True") {
            //                ASOFT.form.displayInfo('#' + $('#sysScreenID').val(), ASOFT.helper.getMessage("00ML000015"));
            //                window.parent.location.reload();
            //            }
            //            else {
            //                ASOFT.form.displayInfo('#' + $('#sysScreenID').val(), ASOFT.helper.getMessage("00ML000062"));
            //            }
            //        });
            //    }
            //});
        });
    };
}

function receiveResult(result) {
    $("#TransferUnitName").val(result["ObjectName"]);
    $("#ActTransferUnitID").val(result["ObjectID"]);
}


