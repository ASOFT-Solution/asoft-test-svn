var dataPeriod = null;
var divisionID = null;

$(document).ready(function () {
    $("#choosePeriod").click(period);

    //Khai báo popup và các control
    PeriodPopup = window.parent.ASOFT.asoftPopup.castName("PeriodPopup");
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

});

// Show popup
function showPopup(popup, url, data) {
    ASOFT.asoftPopup.show(popup, url, data);
}

//Sự kiện change cho combobo đơn vị
function divisionIDChanged(e) {
    comboPeriod.dataSource.read();
}

//Sự kiện selected cho combobo kỳ kế toán
function periodSelected(e) {
    dataPeriod = this.dataItem(e.item.index());

    if (dataPeriod == null) return;

    var data = {
        DivisionID: comboDivisionID.value(),
        TranMonth: dataPeriod.TranMonth,
        TranYear: dataPeriod.TranYear
    }

    getBeginEndDate(data);
}

//Data combobo kỳ kế toán post lên server
function periodData() {
    var data = null;
    if (comboDivisionID != undefined) {
        data = { divisionID: comboDivisionID.value() };
    }
    return data;
}

function periodDataBound(e) {
    var data = {};
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
    ASOFT.helper.post($("#UrlBeginEndDate").val(), data, function (result) {
        beginDate.value(result.BeginDate);
        endDate.value(result.EndDate);
    });
}

//Chọn kỳ kế toán
function period() {
    url = $('#UrlPeriod').val();
    data = {};
    showPopup(PeriodPopup, url, data);
}

function btnPeriodClick() {
    if (ASOFT.form.checkRequired("Periods")) {
        return;
    }

    //Lấy tháng và năm của kỳ kế toán từ combo kỳ kế toán
    dataPeriod = comboPeriod.dataItem(comboPeriod.selectedIndex);

    if (dataPeriod == undefined) {
        ASOFT.form.displayMessageBox("form#Periods", [ASOFT.helper.getMessage('00ML000069' /*"A00ML000012"*/)], null);
        return;
    }

    var url = $("#UrlUpdatePeriod").val();
    var data = ASOFT.helper.getFormData(null, "Periods");
    data.push({ name: "TranMonth", value: dataPeriod.TranMonth });
    data.push({ name: "TranYear", value: dataPeriod.TranYear });
    data.push({ name: "Closing", value: dataPeriod.Closing });
    ASOFT.helper.post(url, data, periodSuccess);
}

function periodSuccess(result) {
    if (result) {
        parent.location.href = parent.location.href;
        PeriodPopup.close();
        //parent.location.reload(true);
    }
    else {
        ASOFT.dialog.messageDialog('Chọn kỳ kế toán không thành công');
    }
}

function btnClosePeriodClick() {
    PeriodPopup.close();
}

