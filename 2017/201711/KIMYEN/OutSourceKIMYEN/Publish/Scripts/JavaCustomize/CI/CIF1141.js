$(document).ready(function () {
    $(".WareHouseID").parent().parent().parent().removeClass('grid_6_1');
    $(".WareHouseID").parent().parent().parent().addClass('grid_12');
    var div = "<div class='asf-checkbox-25'>{0}</div>";
    $(".grid_6").addClass("form-content");
    $(".grid_6").removeClass();
    $("#GridEditCIT1140").removeAttr("style", "height");
    $(".k-grid-content").removeAttr("style", "height");
    $("#GridEditCIT1140").after("<div id='footer' style='width:100%; margin-top:10px'></div>");
    $("#footer").append(kendo.format(div, $($(".IsCS td")[1]).context.innerHTML));
    $("#footer").append(kendo.format(div, $($(".IsCommon td")[1]).context.innerHTML));
    $("#footer").append(kendo.format(div, $($(".IsTemp td")[1]).context.innerHTML));
    $(".IsTemp").remove();
    $(".IsCommon").remove();
    $(".IsCS").remove();

    if ($("#isUpdate").val() == "False") {
        $(".Disabled").after("<input type='text' hidden=true value='0' id='Disabled' Name='Disabled'/>");
        $("#GridEditCIT1140").hide();
        $("#IsManagerLocationID").change(function () {
            if ($("#IsManagerLocationID").is(':checked')) {
                $("#GridEditCIT1140").css("display", "block");
                LoadDataSQL_001();
            } else {
                $("#GridEditCIT1140").css("display", "none");
            }
        });
    }
    if ($("#isUpdate").val() == "True") {
        CheckUsingCommon();
        if ($("#IsManagerLocationID").is(':checked')) {
            $("#GridEditCIT1140").css("display","block");
            LoadDataSQL_004();
        } else {
            $("#GridEditCIT1140").css("display","none");
        }
    }
    //$("#GridEditCIT1140").after("<div id='footer' style='width:100%; margin-top:10px'></div>");
    //$("#footer").append(kendo.format(div, $($(".IsCS td")[1]).context.innerHTML));
    //$("#footer").append(kendo.format(div, $($(".IsCommon td")[1]).context.innerHTML));
    //$("#footer").append(kendo.format(div, $($(".IsTemp td")[1]).context.innerHTML));
    //$(".IsTemp").remove();
    //$(".IsCommon").remove();
    //$(".IsCS").remove();
  
});

function CheckUsingCommon() {
    var data = [];
    data.push($("#WareHouseID").val());
    ASOFT.helper.postTypeJson("/CI/CIF1140/CheckUsingCommon", data, function (result) {
        if (result == 1) {
            $(".IsCommon").hide();
        }
        else {
            $("#WareHouseID").removeAttr("readonly");
        }
    });
}


function onAfterInsertSuccess(result, action) {
    if (action == 3 && result.Status == 0) {
        var url = parent.GetUrlContentMaster();
        var listSp = url.split('&');
        var division = listSp[listSp.length - 1];
        if ($("#IsCommon").is(':checked')) {
            url = url.replace(division, "DivisionID=" + "@@@");
        }
        else {
            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
        }
        window.parent.parent.location = url;
        parent.setReload();
    }
}

function LoadDataSQL_001() {
    var data = {
        DivisionID: $('#EnvironmentDivisionID').val(),
    };
    $.ajax({
        url: '/CI/CIF1141/LoadDataSQL_001',
        async: false,
        data: data,
        success: function(result) {
            var a = JSON.parse(result);
            var grid = $("#GridEditCIT1140").data("kendoGrid");
            var datasource = grid.dataSource;
            grid.dataSource.data([]);
            for (i = 0; i < a.length; i++) {
                datasource.insert({
                    LevelName: a[i]["LevelName"],
                    SystemName: a[i]["SystemName"],
                    UserName: a[i]["UserName"],
                    IsUsed: a[i]["IsUsed"],
                    LevelID: a[i]["LevelID"]
                });
            };
        }
    });
}

function LoadDataSQL_004() {
    var data = {
        DivisionID: $('#EnvironmentDivisionID').val(),
        WareHouseID: $('#WareHouseID').val(),
        UserID: $('#EnvironmentUserID').val()
    };
    $.ajax({
        url: '/CI/CIF1141/LoadDataSQL_004',
        async: false,
        data: data,
        success: function(result) {
            var a = JSON.parse(result);
            var grid = $("#GridEditCIT1140").data("kendoGrid");
            var datasource = grid.dataSource;
            grid.dataSource.data([]);
            for (i = 0; i < a.length; i++) {
                datasource.insert({
                    LevelName: a[i]["LevelName"],
                    SystemName: a[i]["SystemName"],
                    UserName: a[i]["UserName"],
                    IsUsed: a[i]["IsUsed"],
                    LevelID: a[i]["LevelID"]
                });
            };
        }
    });
}