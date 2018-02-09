var markers = [];
var map;
var default_zoom = 14;
var locationcenter = { lat: 10.776755, lng: 106.703265 };
var iconUser = "/Areas/So/Content/images/user.png";
var iconUserActive = "/Areas/So/Content/images/user-active.png";
var iconPlace = "/Areas/So/Content/images/point.png";
var iconStart = "/Areas/So/Content/images/start.png";
var iconEnd = "/Areas/So/Content/images/end.png";
var strokeColor = '#36abd6';
var address = "Không lấy được địa chỉ cho vị trí này";
var datas;
var geocoder;
var infoWindow;
var directionsDisplay;
var directionsService;
var latlngbounds;
var betw = 50;
var origin;
var destination;
var _loopDraw;
var time_loop_draw = 700;

jQuery(document).ready(function ($) {

	datas = salemansnow;

	var mheight = $(window).innerHeight() - 110;
    $('#map').height(mheight);
    $('#maploading').height(mheight);

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
			$.get('/SO/SOF2040/SalemanDetail?userid=' + $(this).data('uid') + '&date=' + $(this).data('date'), function (data) {
				histories = null;
				histories = $.parseJSON(data);
				//sortOn(histories, 'Datetime', false, true);
				drawline(histories);
			});
		}
    });

});


function initMap() {
	mapDefault();

	infoWindow = new google.maps.InfoWindow();
	geocoder = new google.maps.Geocoder;

    directionsService = new google.maps.DirectionsService;
	directionsDisplay = new google.maps.DirectionsRenderer;

	addUsersNowToMap();
}

infiniteLoop = setInterval(function () {
    addUsersNowToMap()
}, timeReload);


function addUsersNowToMap() {
	$('#maploading').fadeIn('fast');

	clearMarkers();

	if (datas.length > 0) {
		for (var i = 0; i < datas.length; i++) {
	    	addUserWithTimeout(datas[i]);
	    }
	}

    $('#maploading').fadeOut('fast');
}

function addUserWithTimeout(position) {
	var d = position.datetime.split(" ");
    d = d[1].split(":");

    // Make description content
    var description = '<div class="description">'
                + '<label class="title">' + position.user_name + '</label>'
                + '<p class="time"><i class="fa fa-clock-o"></i>' + d[0] + ':' + d[1] + '</p>'
                + '<p class="address"><i class="fa fa-map-marker"></i>' + address + '</p>'
                + '</div>';


    var marker = new google.maps.Marker({
        position: new google.maps.LatLng(position.lat, position.long),
		map: map,
		icon: iconUser,
		description: description
    });
    markers.push(marker);

	google.maps.event.addListener(marker, 'click', function () {
        var des = marker.description;
        
        // Reset icon all user
        for (var i = 0; i < markers.length; i++) {
	        markers[i].setIcon(iconUser);
	        markers[i].setMap(map);
	    }

        // Change user icon on active
        marker.setIcon(iconUserActive);
	    marker.setMap(map);

	    // Get address by position
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

function clearMarkers() {
	for (var i = 0; i < markers.length; i++) {
	  markers[i].setMap(null);
	}
	markers = [];
}

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

function mapDefault(){
    map = new google.maps.Map(document.getElementById('map'), {
		zoom: default_zoom,
		center: locationcenter,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	});

    clearInterval(_loopDraw);
    origin = null;
    destination = null;
    latlngbounds = new google.maps.LatLngBounds();
    $('#maploading').fadeOut('slow');
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

    mapDefault();
    $('#maploading').fadeIn('slow');

    directionsDisplay.setMap(map);
    var i = 0;
    var localsx = _distance(histories);
    var length = localsx.length;
    if (length > 0) {

	    _loopDraw = setInterval(function(){
		    if( i == (length - 1 )){
		       clearInterval(_loopDraw);
               $('#maploading').fadeOut('slow');
		    }

		    loopDraw(localsx[i], i, length);

		    i++;

		}, time_loop_draw);

    }

}

function _distance(datas) {

    var locals = [];

    if (datas.length > 0) {
        for (var i = 0; i < datas.length; i++) {

            var local;

            if(i == 0){
                local = { lat: datas[i].Latitude, lng: datas[i].Longitude };
                locals.push(datas[i]);
            }

            if(i == 0 || i == (datas.length - 1)){
                latlngbounds.extend(new google.maps.LatLng(datas[i].Latitude, datas[i].Longitude));
            }

            if (i > 0) {
                var distance = google.maps.geometry.spherical.computeDistanceBetween(new google.maps.LatLng(local.lat, local.lng), new google.maps.LatLng(datas[i].Latitude, datas[i].Longitude));

                //if ((distance < betw || distance > 5000) && data.Name == "") {
                if ( distance > betw ||  i == (datas.length-1)) {
                    local = { lat: datas[i].Latitude, lng: datas[i].Longitude };
                    locals.push(datas[i]);
                }
            }

            if (datas[i].Name != '' && datas[i].OrderNo != '') {
                local = { lat: datas[i].Latitude, lng: datas[i].Longitude };
                locals.push(datas[i]);
            }
        }

        // Make to center map
        map.setCenter(latlngbounds.getCenter());
        map.fitBounds(latlngbounds);
    }

    return locals;
}

function drawline2(histories) {
    var datas = histories;
    directionsDisplay.setMap(map);
    var origin;
    var destination;
    if (datas.length > 0) {
    	//var locals = [];
    	for (var i = 0; i < datas.length; i++) {
    		
	    		var data = datas[i];

	    		//var local = {lat: parseFloat(data.Latitude), lng: parseFloat(data.Longitude)};
	    		var local;

	    		var d = data.Datetime.split(" ");
	            d = d[1].split(":");

	    		description = '<div class="description">'
	                        + '<label class="title">' + data.Name + '</label>'
	                        + '<p class="time"><i class="fa fa-clock-o"></i>' + d[0] + ':' + d[1] + '</p>'
	                        + '<p class="address"><i class="fa fa-map-marker"></i>' + data.Address + '</p>'
	                        + '<p class="address"><i class="fa"></i>Mã đơn hàng: ' + data.OrderNo + '</p>'
	                        + '</div>';

	            var placeLatlng = new google.maps.LatLng(data.Latitude, data.Longitude);

	            var location = { position: placeLatlng, description: description };

	            // Adds a marker at the center of the map.
	            if(i == 0 || i == (datas.length-1)){
	            	addMarkerPlace(location, iconPlace);
	            	local = { lat: data.Latitude, lng: data.Longitude };
	            }

	            if(i == 0){
	            	origin = {lat: parseFloat(datas[i].Latitude), lng: parseFloat(datas[i].Longitude)};
	            }

	            if (i > 0) {
	                var distance = google.maps.geometry.spherical.computeDistanceBetween(new google.maps.LatLng(local.lat, local.lng), new google.maps.LatLng(datas[i].Latitude, datas[i].Longitude));

	                //if ((distance < 500 || distance > 5000) && data.Name == "") {
	                if ( distance < 100 ) {
	                    continue;
	                } else {
	                	//window.setTimeout(function() {
		                	local = { lat: data.Latitude, lng: data.Longitude };
		                	if(destination){
		                		origin = destination;
		                	}

		                	destination = {lat: parseFloat(datas[i].Latitude), lng: parseFloat(datas[i].Longitude)};
		                	addMarkerPlace(location, iconPlace);
	                	//}, i * 1000);
	                		
			            	calculateAndDisplayRoute(directionsService, directionsDisplay, origin, destination);

				        

		            }

	            }

            
            
    	}

    	//console.log(locals);

    	// var poly = new google.maps.Polyline({
     //      path: locals,
     //      geodesic: true,
     //      strokeColor: '#FF0000',
     //      strokeOpacity: 1.0,
     //      strokeWeight: 2
     //    });

     //    poly.setMap(map);

        
    }

    $('#maploading').fadeOut('slow');
}

function loopDraw(data, i, length) {

	var d = data.Datetime.split(" ");
    d = d[1].split(":");

	var description = '';

    var placeLatlng = new google.maps.LatLng(data.Latitude, data.Longitude);

    if(i == 0){
        description = '<div class="description">'
                + '<label class="title">Điểm bắt đầu</label>'
                + '<p class="time"><i class="fa fa-clock-o"></i>' + d[0] + ':' + d[1] + '</p>'
                + '<p class="address"><i class="fa fa-map-marker"></i>' + data.Address + '</p>'
                + '</div>';

        location = { position: placeLatlng, description: description };
        addMarkerPlace(location, iconStart);

        origin = {lat: parseFloat(data.Latitude), lng: parseFloat(data.Longitude)};
    }else if(i == (length-1)){
        description = '<div class="description">'
                + '<label class="title">Điểm kết thúc</label>'
                + '<p class="time"><i class="fa fa-clock-o"></i>' + d[0] + ':' + d[1] + '</p>'
                + '<p class="address"><i class="fa fa-map-marker"></i>' + data.Address + '</p>'
                + '</div>';

        location = { position: placeLatlng, description: description };
        addMarkerPlace(location, iconEnd);
    }

    if (data.Name != '' && data.OrderNo != ''){
        description = '<div class="description">'
                + '<label class="title">' + data.Name + '</label>'
                + '<p class="time"><i class="fa fa-clock-o"></i>' + d[0] + ':' + d[1] + '</p>'
                + '<p class="address"><i class="fa fa-map-marker"></i>' + data.Address + '</p>'
                + '<p class="address"><i class="fa"></i>Mã đơn hàng: ' + data.OrderNo + '</p>'
                + '</div>';

        var location = { position: placeLatlng, description: description };
        addMarkerPlace(location, iconPlace);
    }

    

    if (i > 0) {

    	if(destination){
    		origin = destination;
    	}

    	destination = {lat: parseFloat(data.Latitude), lng: parseFloat(data.Longitude)};
    	//addMarkerPlace(location, iconPlace);
		
    	calculateAndDisplayRoute(directionsService, directionsDisplay, origin, destination);

    }

}

function calculateAndDisplayRoute(directionsService, directionsDisplay, origin, destination) {
	directionsService.route({
	  origin: origin,
	  destination: destination,
	  travelMode: google.maps.TravelMode.DRIVING
	}, function(response, status) {
	  if (status === google.maps.DirectionsStatus.OK) {
	    renderDirectionsPolylines(response, origin, destination);
	  } else {
	    //window.alert('Thông báo trả về bởi Google Map: ' + status);
        window.setTimeout(function(){
            calculateAndDisplayRoute(directionsService, directionsDisplay, origin, destination);
        }, 50);
	  }
	});
}


function renderDirectionsPolylines(response, start, end) {
  var legs = response.routes[0].legs;
  //var bounds = new google.maps.LatLngBounds();
  for (i = 0; i < legs.length; i++) {
    var steps = legs[i].steps;
    for (j = 0; j < steps.length; j++) {
      var nextSegment = steps[j].path;
      var stepPolyline = new google.maps.Polyline({
	      strokeColor: strokeColor,
	      strokeOpacity: 1,
	      strokeWeight: 4
	  });

      for (k = 0; k < nextSegment.length; k++) {
        stepPolyline.getPath().push(nextSegment[k]);
        //bounds.extend(nextSegment[k]);
      }
      stepPolyline.setMap(map);
    }
  }

  //map.setCenter(bounds.getCenter());
  //map.fitBounds(bounds);
}

function addMarkerPlace(location, icon) {
    var marker = new google.maps.Marker({
        position: location.position,
        map: map,
        icon: icon,
        description: location.description
    });
    markers.push(marker);
    google.maps.event.addListener(marker, 'click', function () {
        var des = marker.description;
        infoWindow.setContent(marker.description);
        infoWindow.open(map, marker);
    });
}