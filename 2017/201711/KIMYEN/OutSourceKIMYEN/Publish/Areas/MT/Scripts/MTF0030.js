// Document ready
$(document).ready(function() {
    // Resize horizontal line between left and right panel
    resizeHorzLine();
});

// Resize Horizontal Line
function resizeHorzLine() {
    var leftHeight = $("div.main-container-left-block").first().height();
    var rightHeight = $("div.main-container-right-block").first().height();
    var middleHeight = 0;
    if (leftHeight > rightHeight) {
        middleHeight = leftHeight;
    } else {
        middleHeight = rightHeight;
    }

    $("div.horz-line").first().height(middleHeight);
}


function OnPeriodChanged(e) {
    var dataItem = this.dataItem(e.item.index());

    if (dataItem == null) return;

    // Lấy giá trị tranmonth, tranyear
    tranMonth = dataItem.TranMonth;
    tranYear = dataItem.TranYear;
}

function btnSave_Click(e) {
    //if (asoft.CheckRequired("MTF0030")) {
    //    return;
    //}

    var urlMtf0030UpDate = $('#UrlMTF0030Update').val();
    //Lấy dữ liệu từ form post lên
    var data = ASOFT.helper.getFormData(null, "MTF0030");
    data.unshift({ name: "TranMonth", value: tranMonth });
    data.unshift({ name: "TranYear", value: tranYear });

    ASOFT.helper.post(urlMtf0030UpDate, data, MTF0030_Save_Success);
}


function MTF0030_Save_Success(result) {
    if (result.success) {
        //alert("Lưu dữ liệu thành công!");
        window.location.href = "MTF0010";
    }
    else {
        alert("Lưu dữ liệu không thành công!");
    }
}