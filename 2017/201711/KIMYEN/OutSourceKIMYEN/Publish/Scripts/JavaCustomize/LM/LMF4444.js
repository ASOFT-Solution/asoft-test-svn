$(document).ready(function () {
    $("#btnChoose").unbind('click');
    $("#btnChoose").bind('click', LMF4444.btnChoose_Click);
})

/**  
* Class LMF4444
*
* [Kim Vu] Create New [20/12/2017]
**/
var LMF4444 = new function () {

    this.btnChoose_Click = function () {        
        if (typeSelected == "2") {
            var checkedRadio = $('input[name=radio-check]:checked');
            if (checkedRadio.length == 0) {
                console.log('NO MEMEBER CHOOSEN');
                ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'));
            } else {
                var data = {};
                GridKendo.tbody.find('input[name=radio-check]:checked').closest('tr')
                .each(function () {
                    if (typeof GridKendo.dataItem(this) !== 'undefined') {
                        data = GridKendo.dataItem(this);
                    }
                });
                window.parent.receiveResult(data);
                ASOFT.asoftPopup.closeOnly();
            }
        }
        else {
            var records = ASOFT.asoftGrid.selectedRecords(GridKendo);

            if (records.length == 0)
                return false;
            window.parent.receiveResult(records);
            ASOFT.asoftPopup.closeOnly();
        }
    }
}