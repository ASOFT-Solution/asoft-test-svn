var GridEditOOT2091 = null;
$(document).ready(function () {
    GridEditOOT2091 = $("#GridEditOOT2091").data("kendoGrid")
    GridEditOOT2091.hideColumn(0);
    GridEditOOT2091.hideColumn(1);
    GridEditOOT2091.bind('dataBound', function (e) {
         
            //   var data = GridEditOOT2091.data("kendoGrid").view();
            var classCheckItem = $("input[isCheckChild='true']");
            var classList = [];
            for (var k = 0; k < classCheckItem.length; k++)
            {               
                var cls = $(classCheckItem[k]).attr("class");
                if (classList.indexOf(cls) == -1)
                {
                    classList.push(cls);
                }
            }
            for (var j = 0; j < classList.length; j++) {
                var isCheck = false;
                var CheckItem = $("." + classList[j]);
                for (var i = 0; i < CheckItem.length; i++) {
                    if ($(CheckItem[i]).is(":checked")) {
                        isCheck = true;
                        break;
                    }
                }
                var checkParent = CheckItem.attr("checkParent");
                $("input[group='" + checkParent + "']").prop("checked", isCheck);
            }      
    })
          
});

function process_Click(e) {
    var group = $(e).attr("group");
    var classCheck = group.split(' - ')[0];
    
    if (classCheck) {
        $("." + classCheck).prop("checked", $(e).is(":checked"));       
    }
    //var step = $("." + classCheck).is(":checked").val;
    //if (step = null) {
    //    $(e).removeAttr("checked");
    //}
    
}
function Step_Click(e) {
    var classCheck = $(e).attr("class"); // lấy được class chung các checkItem
    var eClassCheck = $("." + classCheck);// các checkItem có cùng class
    var isCheck = false;
    for (var i = 0 ; i < eClassCheck.length; i++)// vòng lặp kiểm tra nếu có 1 checkItem đã được check thì check ngoài
    {
        if ($(eClassCheck[i]).is(":checked"))
        {
            isCheck = true;
            break;
        }
    }

    var checkParent = $(e).attr("checkParent"); // attr
    $("input[group='" + checkParent + "']").prop("checked", isCheck);
    GridEditOOT2091.bind("databound");
}

function getDetailCustom(tb) {
    var valueGid = [];
    Grid = $('#GridEdit' + tb).data('kendoGrid');
    var eCheckChild = $("input[isCheckChild='true']");
    for (var i = 0 ; i < eCheckChild.length; i++) {
        if ($(eCheckChild[i]).is(":checked"))
        {
            var tr = $(eCheckChild[i]).closest('tr');
            var row = Grid.dataItem(tr);
            valueGid.push(row);
        }
    }
    return valueGid;
}

function getListDetailCustom(tb) {
    var data = [];
    var dt = getDetailCustom(tb);
    var Grid = $('#GridEdit' + tb).data('kendoGrid');
    if (Grid) {
        for (i = 0; i < dt.length; i++) {
            if ($("#isUpdate").val() == "True") {
                if (dt[i].dirty && dt[i][$("#PKChild" + tb).val()] != null && dt[i][$("#PKChild" + tb).val()] != "")
                    dt[i].HistoryChange = 1;
                else {
                    if (dt[i][$("#PKChild" + tb).val()] == null || dt[i][$("#PKChild" + tb).val()] == "")
                        dt[i].HistoryChange = 0;
                    else
                        dt[i].HistoryChange = 2;
                }

            }
            data.push(dt[i]);
        }
        return data;
    }
    return dt;
}


function CustomInsertPopupDetail(datagrid) {
    datagrid.push(getListDetailCustom("OOT2091"));
    return datagrid;
}



