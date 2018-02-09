//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     04/09/2014      Đức Quý         Tạo mới
//####################################################################

DRF0020 = new function () {

    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.btnClose_Click = function () {
        ASOFT.asoftPopup.hideIframe(true);
    };

    //Sự kiện change cho combobo đơn vị
    this.divisionIDChanged = function (e) {
        //DRF0020.comboPeriod = ASOFT.asoftComboBox.castName("Period");
        DRF0020.comboPeriod.dataSource.read();
    }

    //Data combobo kỳ kế toán post lên server
    this.periodData = function () {
        var data = null;
        //comboDivisionID = ASOFT.asoftComboBox.castName("DivisionID");
        if (DRF0020.comboDivisionID != undefined) {
            data = { divisionID: DRF0020.comboDivisionID.value() };
        }
        return data;
    }


    this.btnConfig_Click = function (e) {
        if (ASOFT.form.checkRequired("DRF0020")) {
            return;
        }

        //Lấy tháng và năm của kỳ kế toán từ combo kỳ kế toán
        //comboPeriod = ASOFT.asoftComboBox.castName("Period");
        dataPeriod = DRF0020.comboPeriod.dataItem(DRF0020.comboPeriod.selectedIndex);

        if (dataPeriod == undefined) {
            ASOFT.form.displayMessageBox("form#DRF0020", [ASOFT.helper.getMessage("A00ML000012")], null);
            return;
        }

        var url = window.parent.$('#UrlDRF0020Update').val();
        var data = ASOFT.helper.getFormData(null, "DRF0020");
        data.push({ name: "TranMonth", value: dataPeriod.TranMonth });
        data.push({ name: "TranYear", value: dataPeriod.TranYear });
        data.push({ name: "Closing", value: dataPeriod.Closing });
        ASOFT.helper.post(url, data, DRF0020.drf0020SaveSuccess);
    }

    this.drf0020SaveSuccess = function (result) {
        if (result.Status == 0) {
            //alert("Lưu dữ liệu thành công!");
            window.parent.location.reload(true);
        }
        else {
            result.Mesage = [ASOFT.helper.getMessage("A00ML000013")];
            ASOFT.helper.showErrorSever(result.MesageID, "DRF0020");
        }
    }
}

$(document).ready(function () {
    DRF0020.comboDivisionID = ASOFT.asoftComboBox.castName("DivisionID");
    DRF0020.comboPeriod = ASOFT.asoftComboBox.castName("Period");
});