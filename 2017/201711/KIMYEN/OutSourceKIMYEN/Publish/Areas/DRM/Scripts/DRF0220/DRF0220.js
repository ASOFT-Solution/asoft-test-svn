DRF0220 = new function () {
    this.rowNum = 0;
    this.DRF0220Grid = null;

    //Event button config
    this.btnConfig_Click = function () {
        if (ASOFT.form.checkRequired("DRF0220")) {
            return;
        }

        var data = ASOFT.helper.dataFormToJSON('DRF0220', 'List', DRF0220.DRF0220Grid);
        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, DRF0220.drf0220SaveSuccess);
    };

    this.drf0220SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF0220', function () {
            DRF0220.btnClose_Click();
        }, null, null, true);
    }

    this.deleteAddress = function (tag) {
        row = $(tag).parent();
        if (DRF0220.DRF0220Grid.dataSource.data().length == 1) {//Xét rỗng dòng hiện tại nếu lưới còn 1 dòng
            var data = DRF0220.DRF0220Grid.dataSource.data();
            var row = DRF0220.DRF0220Grid.dataSource.data()[0];
            row.set('FromPercent', null);
            row.set('ToPercent', null);
            row.set('TeamPercent', null);
            return;
        }
        ASOFT.asoftGrid.removeEditRow(row, DRF0220.DRF0220Grid, null);
    }

    this.rowNumber = function () {
        return ++DRF0220.rowNum;
    }

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
        DRF0220.rowNum = 0;
    };
}

$(document).ready(function () {
    DRF0220.DRF0220Grid = ASOFT.asoftGrid.castName('DRF0220Grid');
    DRF0220.DRF0220Grid.bind('dataBound', function () {
        DRF0220.rowNum = 0;
    });
})