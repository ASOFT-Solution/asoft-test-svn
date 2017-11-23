
//Hàm: khởi tạo các đối tượng trong javascript
$(document).ready(function () {
	//Ẩn nút sửa xóa khi từ màn hình duyệt qua xem chi tiết
	if ($('#status').val()==1) {
		$('#ViewMaster .asf-panel-master-header ').attr("ID", "disabledbutton")
	}

	$(".VacationDay").text(formatDecimal(kendo.parseFloat($(".VacationDay").text() ? $(".VacationDay").text() : 0), 1))

	$(".asf-table-view td").attr("style", "width: auto !important;");
})

function urlEditCusTom() {
	var data = {
		FormStatus: 2,
		MethodVacationID : $('.MethodVacationID').text(),
	};

	// [1] Format url with object data
	var url = '/HRM/HF0398/Index';

	var postUrl = ASOFT.helper.renderUrl(url, data);

	// [2] Render iframe
	ASOFT.asoftPopup.showIframe(postUrl, {});
}

//Hàm: Đóng
function popupClose() {
	ASOFT.asoftPopup.hideIframe();
}

function formatDecimal(value, num) {
	var format = null;
	switch (num) {
		case 1:
			format = ASOFTEnvironment.NumberFormat.KendoHolidayDecimalsFormatString;
			break;
		case 2:
			format = ASOFTEnvironment.NumberFormat.KendoQuantityDecimalsFormatString;
			break;
	}
	return kendo.toString(value, format);

}