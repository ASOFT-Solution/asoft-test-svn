
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     19/06/2014     Chánh Thi        tạo mới
//####################################################################

$(document).ready(function () {
    var posGrid = $('#POSF0039Grid').data('kendoGrid');
   while (posGrid.dataSource.data().length > 0) {
       posGrid.dataSource.remove(posGrid.dataSource.at(0));
   }
   var firstDataBound = true;
   //posGrid.dataSource.bind('dataBound', function () {
       if (firstDataBound) {
           firstDataBound = false;
           if (window.parent.TableID == 'P03') {
               for (var i = 0; i < window.parent.CancelP03.length; i++) {
                   posGrid.dataSource.add(window.parent.CancelP03[i]);
               }
           } else if (window.parent.TableID == 'P06') {
               for (var i = 0; i < window.parent.CancelP06.length; i++) {
                   posGrid.dataSource.add(window.parent.CancelP06[i]);
               }
           }
       }
   //});
});

function posf00201SaveNew_Click() {
}

// Xử lý sự kiện khi click nút Lưu và sao chép
function posf00201SaveCopy_Click() {
}

function SendDataMaster() {
    var data = {};
    data.CurrentTableID = window.parent.TableID;
    return data;
}
