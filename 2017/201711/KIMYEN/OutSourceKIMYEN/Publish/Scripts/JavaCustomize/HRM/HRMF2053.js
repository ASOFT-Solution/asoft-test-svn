function LoadPartialFilter() {
    $.ajax({
        url: '/HRMF2053/GetPartialSearch',
        success: function (result) {
            $(".asf-quick-search-container").before(result)
            BtnFilter_Click()
            var ip = $(":input[type='text']")
            $(ip).each(function () {
                $(this).attr("name", this.id)
            })
        }
    })
}

$(document).ready(function () {

    LoadPartialFilter()

})