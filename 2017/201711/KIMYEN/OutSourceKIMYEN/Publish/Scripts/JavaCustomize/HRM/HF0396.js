
//Hàm: khởi tạo các đối tượng trong javascript
$(document).ready(function () {
    $("#Disabled_HF0396").data("kendoComboBox").select(1);
})

function onShowEditorFrame() {
    var data = {
        FormStatus: 1
    };
    var url = '/HRM/HF0398/Index';
    urladd = ASOFT.helper.renderUrl(url, data); //showPopup(url, data);
}

// show popup
function showPopup(url, data) {
    // [1] Format url with object data
    var postUrl = ASOFT.helper.renderUrl(url, data);

    // [2] Render iframe
    ASOFT.asoftPopup.showIframe(postUrl, {});
}
