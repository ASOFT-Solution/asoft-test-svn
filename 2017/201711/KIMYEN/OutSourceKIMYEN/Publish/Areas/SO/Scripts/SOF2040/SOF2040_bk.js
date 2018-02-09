var markers = [];
var map;
var infoWindow;
var iconUser = "/Areas/So/Content/images/user.png";
var iconUserActive = "/Areas/So/Content/images/user-active.png";
var iconPlace = "/Areas/So/Content/images/point.png";
var strokeColor = '#36abd6';
var geocoder;
var address = "Không lấy được địa chỉ cho vị trí này";
var locationcenter = { lat: 10.776755, lng: 106.703265 };
var description;

var servername = window.location.protocol;
var salemandates = [];
var histories = [];
var infiniteLoop;
var userid;

jQuery(document).ready(function ($) {

    $('#uhistories ul').height($(window).innerHeight() - 403);
    
	if (window.location.hash != '') {
		clearInterval(infiniteLoop);
		mapDefault();
		userid = window.location.hash.substring(1);
		$('#salemandates').empty();
		$('<li style="background-color:#fff"><center><img src="/Areas/So/Content/images/loading.gif" width="30px" /></center></li>').appendTo('#salemandates');
        renderWorkdate(userid, "", "");

        $('#users').animate({ left: "-1000px" }, 1000);
        $('#uhistories').animate({ left: "0px" }, 1000);
        $('#user').val($(this).text());
        $('#uid').val(userid);
        $('#xuserid').text(userid);
	}

    if (salemans.length > 0) {
        //List user
        for (var i = 0; i < salemans.length; i++) {
            $('<li><a data-uid="' + salemans[i]["user_id"] + '" href="#' + salemans[i]["user_id"] + '">' + salemans[i]["user_name"] + " - " + salemans[i]["user_id"] + '</a></li>').appendTo('#users ul.nav');
        }
    } else {
        $('<li style="background-color:#fff"><center>Không có nội dung nào.</center></li>').appendTo('#users ul.nav');
    }

    var mheight = $(window).innerHeight() - 110;
    $('#map').height(mheight);
    $('#maploading').height(mheight);

    $('#uhistories #btn-back').on('click', function () {
    	window.location.hash = '';
    	mapDefault();
        $('#users').animate({ left: "0px" }, 1000);
        $('#uhistories').animate({ left: "-1000px" }, 1000);
    });

    $("#searchworkdate").submit(function (event) {
        event.preventDefault();
        $('#salemandates').empty();
        $('<li style="background-color:#fff"><center><img src="/Areas/So/Content/images/loading.gif" width="30px" /></center></li>').appendTo('#salemandates');
        userid = window.location.hash.substring(1);
        var from_date = $("#searchworkdate #from_date").val();
        var to_date = $("#searchworkdate #to_date").val();

        renderWorkdate(userid, from_date, to_date);
    });

    $('#users ul li a').on('click', function () {
    	clearInterval(infiniteLoop);
    	mapDefault();
    	$('#from_date').val('');
    	$('#to_date').val('');
        $('#salemandates').empty();
        $('<li style="background-color:#fff"><center><img src="/Areas/So/Content/images/loading.gif" width="30px" /></center></li>').appendTo('#salemandates');
        renderWorkdate($(this).data('uid'), "", "");

        $('#users').animate({ left: "-1000px" }, 1000);
        $('#uhistories').animate({ left: "0px" }, 1000);
        $('#user').val($(this).text());
        $('#uid').val($(this).data('uid'));
        $('#xuserid').text($(this).data('uid'));
        $('#from_date').val($('#ufrom_date').val());
        $('#to_date').val($('#uto_date').val());
    });

    $(document).on('click', 'ul#salemandates li', function () {
		if(!$(this).hasClass( "selected" )){
			$("ul#salemandates li").removeClass("selected");
			$(this).addClass("selected");
			clearInterval(infiniteLoop);
			$('#maploading').fadeIn('slow');
			$.get('/SO/SOF2040/SalemanDetail?userid=' + $(this).data('uid') + '&date=' + $(this).data('date'), function (data) {
				histories = null;
				histories = $.parseJSON(data);
				//sortOn(histories, 'Datetime', false, true);
				drawline(histories);
			});
		}
    });
});

$('#btnminibar').on('click', function(e) {
	setTimeout(function(){ 
		mapDefault();
	}, 500);
});

function renderWorkdate(userid, from_date, to_date) {
    var xhttp = $.get('/SO/SOF2040/UserWorkDay?userid=' + userid + "&fromdate=" + from_date + "&todate=" + to_date, function (data, status) {
        $('#salemandates').empty();
        if (status == "success") {
            salemandates = $.parseJSON(data);
            if (salemandates.length > 0) {
                for (var i = 0; i < salemandates.length; i++) {
                    var salemandate = '<li data-uid="' + salemandates[i].user_id + '" data-date="' + xdatetime(salemandates[i].DateTime, 'date') + '">'
                                        + '<p><i class="fa fa-calendar"></i>' + xdatetime(salemandates[i].DateTime, 'date') + '</p>'
                                        + '<p><i class="fa fa-clock-o"></i>' + xdatetime(salemandates[i].StartDateTime, 'time') + ' - ' + xdatetime(salemandates[i].EndDateTime, 'time') + '</p>'
                                        + '<p><i class="fa fa-map-marker"></i><span>Bắt đầu</span>: ' + salemandates[i].StartAddress + '</p>'
                                        + '<p><i class="fa"></i><span>Kết thúc</span>: ' + salemandates[i].EndAddress + '</p>'
                                    + '</li>';
                    $(salemandate).appendTo('#salemandates');
                }
            } else {
                $('<li style="background-color:#fff"><center>Không có nội dung nào.</center></li>').appendTo('#salemandates');
            }
        } else {
            $('<li style="background-color:#fff"><center>Có lỗi trong quá trình kết nối hệ thống.<br/>Xin vui lòng thử lại.</center></li>').appendTo('#salemandates');
        }
    }).error(function () {
        $('#salemandates').empty();
        $('<li style="background-color:#fff"><center>Có lỗi trong quá trình kết nối hệ thống.<br/>Xin vui lòng thử lại.</center></li>').appendTo('#salemandates');
    });
}

function initMap() {
    //Start load map
    $('#maploading').fadeIn('slow');

    //The list of points to be connected
    var datas = salemansnow;
    var latlngbounds = new google.maps.LatLngBounds();

    infoWindow = new google.maps.InfoWindow();
    geocoder = new google.maps.Geocoder;

    map = new google.maps.Map(document.getElementById("map"), {
        center: locationcenter,
        zoom: 13,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    if (datas.length > 0) {
        for (var i = 0; i < datas.length; i++) {
            var data = datas[i];

            var d = data.datetime.split(" ");
            d = d[1].split(":");

            // Make description content
            description = '<div class="description">'
                        + '<label class="title">' + data.user_name + '</label>'
                        + '<p class="time"><i class="fa fa-clock-o"></i>' + d[0] + ':' + d[1] + '</p>'
                        + '<p class="address"><i class="fa fa-map-marker"></i>' + address + '</p>'
                        + '</div>';

            var location = { position: new google.maps.LatLng(data.lat, data.long), description: description };

            // Adds a marker at the center of the map.
            addMarker(geocoder, location);
            // Add position to make center
            latlngbounds.extend(location.position);
        }

        // Make to center map
        map.setCenter(latlngbounds.getCenter());
        map.fitBounds(latlngbounds);
    }

    //End load map
    $('#maploading').fadeOut('slow');
}

infiniteLoop = setInterval(function () {
    initMap()
}, timeReload);

function mapDefault(){
	new google.maps.Map(document.getElementById("map"), {
        center: locationcenter,
        zoom: 13,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });
}

function addMarker(geocoder, location) {
    var marker = new google.maps.Marker({
        position: location.position,
        map: map,
        icon: iconUser,
        description: location.description
    });
    markers.push(marker);
    google.maps.event.addListener(marker, 'click', function () {
        var des = marker.description;
        resetMarkersIcon();
        changeActiveMarkerIcon(this);
        var latlng = { lat: parseFloat(marker.position.lat()), lng: parseFloat(marker.position.lng()) };

        geocoder.geocode({ 'location': latlng }, function (results, status) {
            if (status === google.maps.GeocoderStatus.OK) {
                if (results[0]) {
                    infoWindow.setContent(marker.description.replace(address, results[0].formatted_address));
                    infoWindow.open(map, marker);
                }
            }
        });
    });
}

function addMarkerPlace(geocoder, location) {
    var marker = new google.maps.Marker({
        position: location.position,
        map: map,
        icon: iconPlace,
        description: location.description
    });
    markers.push(marker);
    google.maps.event.addListener(marker, 'click', function () {
        var des = marker.description;
        infoWindow.setContent(marker.description);
        infoWindow.open(map, marker);
    });
}

function resetMarkersIcon() {
    for (var i = 0; i < markers.length; i++) {
        markers[i].setIcon(iconUser);
        markers[i].setMap(map);
    }
}

function changeActiveMarkerIcon(marker) {
    marker.setIcon(iconUserActive);
    marker.setMap(map);
}

function getAddress(lat, lng) {
    geocoder = new google.maps.Geocoder;
    var placeLatlng = new google.maps.LatLng(lat, lng);
    var latlng = { lat: parseFloat(placeLatlng.lat()), lng: parseFloat(placeLatlng.lng()) };

    geocoder.geocode({ 'location': latlng }, function (results, status) {
        if (status === google.maps.GeocoderStatus.OK) {
            //if (results[0]) {
            return results[0].formatted_address;
            //}
        }
    });

    return '';
}

function xdatetime(str_datetime, index) {
    var d = str_datetime.split(" ");
    if (index == 'date') {
        return d[0];
    }

    if (index == 'time') {
        d = d[1].split(":");

        return d[0] + ':' + d[1];
    }

}

function drawline(histories) {
    $('#maploading').fadeIn('slow');
    //The list of points to be connected
    var datas = histories;
    var latlngbounds = new google.maps.LatLngBounds();

    infoWindow = new google.maps.InfoWindow();
    geocoder = new google.maps.Geocoder;

    map = new google.maps.Map(document.getElementById("map"), {
        center: locationcenter,
        zoom: 13,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    var lat_lng = new Array();
	var coun = 0;
    if (datas.length > 0) {
        var local;
        for (var i = 0; i < datas.length; i++) {
			coun++;
			
			//if(lat_lng.length <= 5){
            var data = datas[i];

            if (i == 0) {
                local = { lat: data.Latitude, lng: data.Longitude };
            }

            if (i > 0) {
                var distance = google.maps.geometry.spherical.computeDistanceBetween(new google.maps.LatLng(local.lat, local.lng), new google.maps.LatLng(data.Latitude, data.Longitude));

                if ((distance < 500 || distance > 5000) && data.Name == "") {
                //if ( distance < 100 ) {
                    continue;
                } else {
					local = { lat: data.Latitude, lng: data.Longitude };
                }

            }
			console.log(local);

            var d = data.Datetime.split(" ");
            d = d[1].split(":");

            var placeLatlng = new google.maps.LatLng(data.Latitude, data.Longitude);

            lat_lng.push(placeLatlng);


            //if (data.Name != "") {
                // Make description content
                description = '<div class="description">'
                            + '<label class="title">' + data.Name + '</label>'
                            + '<p class="time"><i class="fa fa-clock-o"></i>' + d[0] + ':' + d[1] + '</p>'
                            + '<p class="address"><i class="fa fa-map-marker"></i>' + data.Address + '</p>'
                            + '<p class="address"><i class="fa"></i>Mã đơn hàng: ' + data.OrderNo + '</p>'
                            + '</div>';

                var location = { position: placeLatlng, description: description };

                // Adds a marker at the center of the map.
                addMarkerPlace(geocoder, location);

            //}

            // Add position to make center
            latlngbounds.extend(placeLatlng);
			//}
        }

        // Make to center map
        map.setCenter(latlngbounds.getCenter());
        map.fitBounds(latlngbounds);
    }

    //***********ROUTING****************//
	if(coun == datas.length){
		//Intialize the Path Array
		var path = new google.maps.MVCArray();

		//Intialize the Direction Service
		var service = new google.maps.DirectionsService();

		//Set the Path Stroke Color
		var poly = new google.maps.Polyline({ map: map, strokeColor: strokeColor });

		//Loop and Draw Path Route between the Points on MAP
		for (var i = 0; i < lat_lng.length; i++) {
			if ((i + 1) < lat_lng.length) {
				var origin = lat_lng[i];
				var destination = lat_lng[i + 1];
				//path.push(src);
				poly.setPath(path);
				service.route({
					origin: origin,
					destination: destination,
					travelMode: google.maps.DirectionsTravelMode.DRIVING
				}, function (result, status) {
					if (status == google.maps.DirectionsStatus.OK) {
						for (var j = 0, len = result.routes[0].overview_path.length; j < len; j++) {
							path.push(result.routes[0].overview_path[j]);
						}
					}
				});
			}
		}
	
	}

    $('#maploading').fadeOut('slow');
}


var sortOn = function (arr, prop, reverse, numeric) {

    // Ensure there's a property
    if (!prop || !arr) {
        return arr
    }

    // Set up sort function
    var sort_by = function (field, rev, primer) {

        // Return the required a,b function
        return function (a, b) {

            // Reset a, b to the field
            a = primer(a[field]), b = primer(b[field]);

            // Do actual sorting, reverse as needed
            return ((a < b) ? -1 : ((a > b) ? 1 : 0)) * (rev ? -1 : 1);
        }

    }

    // Distinguish between numeric and string to prevent 100's from coming before smaller
    // e.g.
    // 1
    // 20
    // 3
    // 4000
    // 50

    if (numeric) {

        // Do sort "in place" with sort_by function
        arr.sort(sort_by(prop, reverse, function (a) {

            // - Force value to a string.
            // - Replace any non numeric characters.
            // - Parse as float to allow 0.02 values.
            return parseFloat(String(a).replace(/[^0-9.-]+/g, ''));

        }));
    } else {

        // Do sort "in place" with sort_by function
        arr.sort(sort_by(prop, reverse, function (a) {

            // - Force value to string.
            return String(a).toUpperCase();

        }));
    }

}