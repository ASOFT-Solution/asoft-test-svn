// Document ready
$(document).ready(function() {
    MTF0020.MTF0010Popup = ASOFT.asoftPopup.castName("MTF0010Popup");

    if (MTF0020.MTF0010Popup) {
        MTF0020.MTF0010Popup.bind('refresh', function () {//Event popup loaded

            MTF0020.comboDivisionID = ASOFT.asoftComboBox.castName("DivisionID");
            MTF0020.comboPeriod = ASOFT.asoftComboBox.castName("Period");
        })
    }
});

var MTF0020 = new function () {
    this.MTF0010Popup = null;
    this.comboDivisionID = null;
    this.comboPeriod = null;

    //Sự kiện change cho combobo đơn vị
    this.divisionIDChanged = function (e) {
        //MTF0020.comboPeriod = ASOFT.asoftComboBox.castName("Period");
        MTF0020.comboPeriod.dataSource.read();
    }

    //Data combobo kỳ kế toán post lên server
    this.periodData = function () {
        var data = null;
        //comboDivisionID = ASOFT.asoftComboBox.castName("DivisionID");
        if (MTF0020.comboDivisionID != undefined) {
            data = { divisionID: MTF0020.comboDivisionID.value() };
        }
        return data;
    }

    this.OnPeriodChanged = function (e) {
        var dataItem = this.dataItem(e.item.index());

        if (dataItem == null) return;

        // Lấy giá trị tranmonth, tranyear
        tranMonth = dataItem.TranMonth;
        tranYear = dataItem.TranYear;
    }

    this.btnSaveSystem = function (e) {
        if (ASOFT.form.checkRequired("MTF0020")) {
            return;
        }

        //Lấy tháng và năm của kỳ kế toán từ combo kỳ kế toán
        //comboPeriod = ASOFT.asoftComboBox.castName("Period");
        dataPeriod = MTF0020.comboPeriod.dataItem(MTF0020.comboPeriod.selectedIndex);

        if (dataPeriod == undefined) {
            ASOFT.form.displayMessageBox("form#MTF0020", [ASOFT.helper.getMessage("A00ML000012")], null);
            return;
        }

        var url = $('#UrlMtf0020Update').val();
        var data = ASOFT.helper.getFormData(null, "MTF0020");
        data.push({ name: "TranMonth", value: dataPeriod.TranMonth });
        data.push({ name: "TranYear", value: dataPeriod.TranYear });
        data.push({ name: "Closing", value: dataPeriod.Closing });
        ASOFT.helper.post(url, data, MTF0020.mtf0020SaveSuccess);
    }

    this.mtf0020SaveSuccess = function (result) {
        if (result.Status == 0) {
            //alert("Lưu dữ liệu thành công!");
            window.location.reload(true);
        }
        else {
            result.Mesage = [ASOFT.helper.getMessage("A00ML000013")];
            ASOFT.helper.showErrorSever(result.Mesage, "MTF0020");
        }
    }

    //Đóng popup
    this.btnCloseSystemPopup = function () {
        MTF0020.MTF0010Popup.close();
    }
}