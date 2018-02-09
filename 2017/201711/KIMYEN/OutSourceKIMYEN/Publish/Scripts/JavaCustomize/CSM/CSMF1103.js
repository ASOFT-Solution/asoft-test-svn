
$(document).ready(function () {
    CSMF1103.setapk;
    CSMF1103.disablecontrol;
    CSMF1103.addcontrol;
    CSMF1103.chosespopup;
    CSMF1103.setFirms;

    document.onreadystatechange = function () {
        if (document.readyState === 'complete') {
            //CSMF0002.LoadDataGrid();
            setTimeout(checkaddnewedit01(), 3000);
        }
    }
    
    
});

var CSMF1103 = new function () {
    this.setapk = new function () {
        $("#APKMaster").val($("#PKParent").val());
    }

    this.disablecontrol = new function () {
        $("#FirmID").attr("readonly", true);
        $("#FirmName").attr("readonly", true);
    }

    this.addcontrol = new function () {
        var button = '<a class="k-button k-button-icontext asf-button" id="choseID" style="" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="asf-button-text">Chọn nội dung</span></a>';
        $(".CheckListType").after(button);

    }

    this.chosespopup = new function () {
        $("#choseID").on("click", function () {
            var grid = $("#GridEditCSMT1101_1").data("kendoGrid");
            var datasource = grid.dataSource._data;
            //xóa dữ liệu lưới nếu dòng đầu tiên rỗng
            var lenght = datasource.length;
            if (lenght> 0 && (typeof (datasource[0].DataID == "undefined" || datasource[0].DataID == ""))) {
                grid.dataSource.data([]);
            }
            var datalist = "";
            var lenght = datasource.length;
            for (var i = 0; i < lenght; i++) {
                datalist += datasource[i]["DataID"] + ",";
            }
            var checklisttype = $("#CheckListType").val();
            ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CSM/CSMF1104?CheckListType=" + checklisttype + "&DataList=" + datalist + "&type=1", {});
        });
    }

    this.setFirms = new function () {
        $("#FirmID").val(window.parent.getFirmID);
        $("#FirmName").val(window.parent.getFirmName);
    }

}

function receiveResult(result) {
    var grid = $("#GridEditCSMT1101_1").data("kendoGrid");
    var datasource = grid.dataSource;
    var lenght = result.length;
    for (var i = 0; i < lenght; i++) {
        datasource.insert({ DataID: result[i]["DataID"], Description: result[i]["Description"] });
    }
    //grid.dataSource.data(result);
};

function checkaddnewedit01() {
    //$("#CheckListType").kendoComboBox({ enable: false });
    $(".CheckListType").attr("readonly", true);
    if ($("#isUpdate").val() == "True") {
        var data = {
            APK: $("#APKMaster").val(),
            checklisttype: $("#CheckListType").val(),
        };
        $.ajax({
            url: '/CSM/CSMF1103/LoadGridDetail',
            async: false,
            data: data,
            success: function (result) {
                var grid = $("#GridEditCSMT1101_1").data("kendoGrid");
                var datasource = grid.dataSource;
                var lenght = result.length;
                for (var i = 0; i < lenght; i++) {
                    datasource.insert({ DisplayOrder: result[i]["DisplayOrder"], DataID: result[i]["DataID"], Description: result[i]["Description"] });
                }
            }
        });
    }
}

