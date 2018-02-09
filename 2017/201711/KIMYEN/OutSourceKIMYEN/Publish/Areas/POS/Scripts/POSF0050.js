//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     21/07/2014      Đức Quý         Tạo mới
//####################################################################
var shopID = null;
var rowNumber = 0;
function sendData() {
    //apk = window.parent.posf0010APK;
    var data = {
        divisionID: $('#divisionID').val(),
        shopID: $('#shopID').val()
    };
    return data;
}

function renderNumber () {
    return ++rowNumber;
};

function btnClose_Click() {
    //buttonConfig = $('#btnConfig').data('kendoButton');
    if (posf0050Grid.dataSource.total() <= 0 || !buttonConfig.options.enable) {
        ASOFT.asoftPopup.hideIframe(true);
        return;
    }
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('AFML000006'), btnConfig_Click, function () {
        ASOFT.asoftPopup.hideIframe(true);
    });
}

function btnConfig_Click() {
    $('#POSF0050Grid').removeClass('asf-focus-input-error');
    ASOFT.asoftGrid.editGridRemmoveValidate(posf0050Grid);
    if (ASOFT.asoftGrid.editGridValidate(posf0050Grid, ['Description'])) {
        msg = ASOFT.helper.getMessage('POSM000056');
        ASOFT.form.displayError('#POSF0050', msg);
        return;
    }

    var data = ASOFT.helper.dataFormToJSON(null, 'List', posf0050Grid);
    data.ShopID = $('#shopID').val();
    data.DivisionID = $('#divisionID').val();
    //data.APKMaster = window.parent.posf0010APK;
    var url = $('#URLInsert').val();

    ASOFT.helper.postTypeJson(url, data, configSuccess);
}

function configSuccess(result) {
    // Update status
    ASOFT.form.updateSaveStatus('POSF0050', result.Status, result.Data);
    ASOFT.helper.showErrorSeverOption(0, result, 'POSF0050', function () {
        ASOFT.asoftPopup.hideIframe(true);
    });
}

function tablePricesID_Changed(e) {
    value = this.value();
    ASOFT.asoftGrid.setValueTextbox(
        "POSF0050Grid",
        posf0050Grid,
        ASOFT.asoftGrid.currentCell,
        ASOFT.asoftGrid.currentRow
    );
}

$(document).ready(function () {
    posf0050Grid = ASOFT.asoftGrid.castName("POSF0050Grid");
    buttonConfig = $('#btnConfig').data('kendoButton');
    posf0050Grid.bind('dataBound', function () {
        if (posf0050Grid.dataSource.total() <= 0) {
            posf0050Grid.dataSource.data().remove(0);
            buttonConfig.enable(false);
        }
        rowNumber = 0;
    });

    //comboBoxPriceTable = ASOFT.asoftComboBox.castName('PriceTableID');
});
