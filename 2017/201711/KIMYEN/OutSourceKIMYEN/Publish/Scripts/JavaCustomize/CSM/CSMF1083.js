
$(document).ready(function () {
    CSMF1083.setmodelid();
    CSMF1083.setchecklisttype();
    CSMF1083.chosespopup();
});

var CSMF1083 = new function () {
    this.setmodelid = function () {
        $("#ModelID").val(window.parent.CSMF1082.getmodelID);
    }

    this.disablecontrol = new function () {
        $("#ModelID").attr("readonly", true);
        $("#CheckListType").attr("readonly", true);
    }

    this.addcontrol = new function () {
        var button = '<a class="k-button k-button-icontext asf-button" id="choseID" style="" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="asf-button-text">Chọn nội dung</span></a>';
        $(".CheckListType").after(button);

    }
    this.setchecklisttype = function () {
        $.ajax({
            url: '/CSM/CSMF1083/GetCheckListType',
            async: false,
            success: function (result) {
                $("#CheckListType").val();
            }
        });
    }

    this.chosespopup = function () {
        $("#choseID").on("click", function () {
            var grid = $("#GridEditCSMT1081_1").data("kendoGrid");
            var datasource = grid.dataSource._data;
            var lenght = datasource.length;
            //xóa dữ liệu lưới nếu dòng đầu tiên rỗng
            if (lenght > 0 && (typeof (datasource[0].CheckListID == "undefined" || datasource[0].CheckListID == ""))) {
                grid.dataSource.data([]);
            }
            var datalist = "";
            var checklisttype = $("#CheckListType").val();
            ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CSM/CSMF1104?CheckListType=" + checklisttype + "&DataList=" + datalist + "&type=1", {});
        });
    }
}

function receiveResult(result) {
    var grid = $("#GridEditCSMT1081_1").data("kendoGrid");
    var datasource = grid.dataSource;
    var lenght = result.length;
    for (var i = 0; i < lenght; i++) {
        datasource.insert({ CheckListID: result[i]["DataID"], CheckListName: result[i]["Description"] });
    }
    //grid.dataSource.data(result);
};

