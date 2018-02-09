$(document).ready(function () {

    SwapControls();

});

function CustomizePanalSelect(tb, gridDT) {
    if (gridDT.element.context.id == 'GridHRMT2101') {
        gridDT.hideColumn(1);
        gridDT.bind('dataBound', function (e) {
            var data = gridDT.dataSource.data();
            for (var i = 0; i < data.length; i++) {
                if (data[i].InheritID && data[i].InheritID != "") {
                    gridDT.showColumn(1);
                    break;
                }
            }
        });
    }
}

function ChooseEmployeeID_Click() {
}

/**
 * Thay đổi vị trí các controls
 * @returns {} 
 * @since [Văn Tài] Created [21/11/2017]
 */
function SwapControls() {
  
    $(".FromDate").parent().before($(".TrainingCourseName").parent());
    $(".ToDate").parent().before($(".FromDate").parent());
};

/**  
* Get data Send Mail
*
* [Kim Vu] Create New [11/12/2017]
**/
function customSendMail() {
    var dataSet = {};
    var url = "/HRM/Common/GetUsersSendMail"
    ASOFT.helper.postTypeJson(url, { formID: 'HRMF2101', departmentID: '%' }, function (result) {
        dataSet.EmailToReceiver = result;
    });
    return dataSet;
}