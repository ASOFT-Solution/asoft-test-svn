//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     19/02/2013      Minh Lâm         Tạo mới
//####################################################################
var dataPeriod = null;
var divisionID = null;
//var beginDate = null;
//var endDate = null;

$(document).ready(function () {
    $("#choosePeriod").click(period);

    //Khai báo popup và các control
    PeriodPopup = ASOFT.asoftPopup.castName("PeriodPopup");

    if (PeriodPopup != undefined) {
        PeriodPopup.bind("refresh", function () {
            comboDivisionID = ASOFT.asoftComboBox.castName("DivisionID");
            comboPeriod = ASOFT.asoftComboBox.castName("Period");
            beginDate = ASOFT.asoftDateEdit.castName("BeginDate");
            endDate = ASOFT.asoftDateEdit.castName("EndDate");

            divisionID = null;
            var title = '';
            title = $("#periodTitle").val();
            PeriodPopup.title(title);
        });

        PeriodPopup.bind("close", function () {
            $("#PeriodPopup").html('');
        });
    }



    
});
//=============================================================================
// Màn hình chọn kỳ kế toán
//=============================================================================

// Show popup
function showPopup(popup, url, data) {
    ASOFT.asoftPopup.show(popup, url, data);
}

//Sự kiện change cho combobo đơn vị
function divisionIDChanged(e) {
    comboPeriod = ASOFT.asoftComboBox.castName("Period");
    comboPeriod.dataSource.read();

    var comboShopId = $("#ShopID").data("kendoComboBox");
    comboShopId.setDataSource(null);
    comboShopId.value(null);
    comboShopId.trigger("open");
}

//Sự kiện selected cho combobo kỳ kế toán
function periodChanged(e) {
    comboDivisionID = ASOFT.asoftComboBox.castName("DivisionID");
    dataPeriod = this.dataItem(this.selectedIndex);

    if (dataPeriod == null) return;

    var data = {
        DivisionID: comboDivisionID.value(),
        TranMonth: dataPeriod.TranMonth,
        TranYear: dataPeriod.TranYear
    }

    getBeginEndDate(data);
}

function comboShopIDOpen(e) {
    bindShopDataSource()
}

function bindShopDataSource() {
    var comboDivision = $("#DivisionID").data("kendoComboBox") || $("#DivisionID")
    if (comboDivision) {
        var divisionID = comboDivision.value();
        var postUrl = "/Period/GetDataShopListByDivision";
        ASOFT.helper.postTypeJson(postUrl, { divisionID: divisionID, isGetDefault: false }, function (result) {
            var comboShopID = $("#ShopID").data("kendoComboBox");
            if (result && result.length > 0) {
                if (comboShopID) {
                    comboShopID.setDataSource(result);
                }
            }
            else {
                if (comboShopID) {
                    comboShopID.setDataSource(null);
                    comboShopID.value(null);
                }
            }
        });
    }
}

//Data combobo kỳ kế toán post lên server
function periodData() {
    var data = null;
    comboDivisionID = ASOFT.asoftComboBox.castName("DivisionID");
    if (comboDivisionID != undefined) {
        data = { divisionID: comboDivisionID.value() };
    }
    return data;
}

function periodDataBound(e) {
    var data = {};
    comboDivisionID = ASOFT.asoftComboBox.castName("DivisionID");
    var dataPeriod = this.dataItem(this.selectedIndex);
    if (dataPeriod == undefined) {
        this.value(null);
    }
    else {
        data = {
            DivisionID: comboDivisionID.value(),
            TranMonth: dataPeriod.TranMonth,
            TranYear: dataPeriod.TranYear
        }
    }

    getBeginEndDate(data);
}

//Set BeginDate và EndDate theo kỳ kế toán
function getBeginEndDate(data) {
    beginDate = ASOFT.asoftDateEdit.castName("BeginDate");
    endDate = ASOFT.asoftDateEdit.castName("EndDate");

    ASOFT.helper.post($("#UrlBeginEndDate").val(), data, function (result) {
        if(result.BeginDate != null)
            beginDate.value(result.BeginDate);
        if (result.EndDate != null)
            endDate.value(result.EndDate);
    });
}

//Chọn kỳ kế toán
function period() {
    //Khai báo popup và các control
    PeriodPopup = ASOFT.asoftPopup.castName("PeriodPopup");

    if (PeriodPopup != undefined) {
        PeriodPopup.bind("refresh", function () {
            comboDivisionID = ASOFT.asoftComboBox.castName("DivisionID");
            comboPeriod = ASOFT.asoftComboBox.castName("Period");
            divisionID = null;
            var title = '';
            title = $("#periodTitle").val();
            PeriodPopup.title(title);
        });

        PeriodPopup.bind("close", function () {
            $("#PeriodPopup").html('');
        });
    }

    url = $('#UrlPeriod').val();
    data = {};
    //showPopup(PeriodPopup, url, data);
    ASOFT.asoftPopup.show(PeriodPopup, url, data);
}

function btnPeriodClick() {

    //alert($("#Periods").html());
    if (ASOFT.form.checkRequired("Periods")) {
        return;
    }

    //Lấy tháng và năm của kỳ kế toán từ combo kỳ kế toán
    comboPeriod = ASOFT.asoftComboBox.castName("Period");
    dataPeriod = comboPeriod.dataItem(comboPeriod.selectedIndex);

    //if (dataPeriod == undefined) {
    //    ASOFT.form.displayMessageBox("form#Periods", [ASOFT.helper.getMessage('00ML000069' /*"A00ML000012"*/)], null);
    //    return;
    //}

    var url = $("#UrlUpdatePeriod").val();
    var data = window.parent.ASOFT.helper.getFormData(null, "Periods");
    data.push({ name: "TranMonth", value: comboPeriod.selectedIndex == -1 ? null : dataPeriod.TranMonth });
    data.push({ name: "TranYear", value: comboPeriod.selectedIndex == -1 ? null : dataPeriod.TranYear });
    data.push({ name: "Closing", value: comboPeriod.selectedIndex == -1 ? null : dataPeriod.Closing });
    ASOFT.helper.post(url, data, periodSuccess);
}

function periodSuccess(result) {
    if (result) {
        //Khai báo popup và các control
        PeriodPopup = ASOFT.asoftPopup.castName("PeriodPopup");
        PeriodPopup.close();
        window.location.reload(true);
    }
    else {
        ASOFT.dialog.messageDialog('Chọn kỳ kế toán không thành công');
    }
}

function btnClosePeriodClick() {
    //Khai báo popup và các control
    PeriodPopup = ASOFT.asoftPopup.castName("PeriodPopup");
    PeriodPopup.close();
}

//=============================================================================
// Màn hình thiết lập thông tin cá nhân
//=============================================================================
function openSF0010(url) {
    var data = {};
    // [1] Format url with object data
    var postUrl = ASOFT.helper.renderUrl(url, data);

    // [2] Render iframe
    ASOFT.asoftPopup.showIframe(postUrl, {});
}
