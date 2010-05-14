twttr.geo={LOCATION_CACHE_INTERVAL:30000,FIREFOX_GEO_BANNER_APPEAR_DELAY:500,FIREFOX_GEO_BANNER_DISAPPEAR_INTERVAL:100,PLACE_SEARCH_AUTOCOMPLETE_DELAY:350,MAX_NEARBY_PLACES:10,MAX_PLACE_SEARCH_RESULTS:5,GENERIC_PLACE_TYPES:{city:null,neighborhood:null,admin:null,country:null},TARGET_POI_NAME_LENGTH:40,TARGET_PLACE_NAME_LENGTH:50,templates:{dropdownItem:'<li id="place_{{id}}"><span class="place_item_icon">&nbsp;</span>{{{content}}}</li>',searchResultItem:'<li id="place_{{id}}"><a href="#">{{{content}}}</a></li>',autocompleteItem:'<li id="place_{{id}}" tabindex="-1">{{{content}}}</li>',placeContent:"{{formatted_name}}",pointContent:'<span class="place_icon">&nbsp;</span> {{formatted_name}} <span class="place_details">{{details}}</span>'}};twttr.geo.getPlaceDetails=function(A){if(A.street_address){return A.street_address}var B="";A.contained_within.every(function(C){B=C;return C.place_type!="city"});return B.name};twttr.geo.formatPlaceName=function(A,B){if(A.length<=B){return A}A=A.replace(/ [(].*[)]/g,"");if(A.length<=B){return A}var C="...";return A.substr(0,B-C.length)+C};twttr.geo.renderPlace=function(B,A){var C;if(A.place_type in twttr.geo.GENERIC_PLACE_TYPES){C=twttr.geo.templates.placeContent;A.formatted_name=twttr.geo.formatPlaceName(A.full_name,twttr.geo.TARGET_PLACE_NAME_LENGTH)}else{C=twttr.geo.templates.pointContent;A.formatted_name=twttr.geo.formatPlaceName(A.name,twttr.geo.TARGET_POI_NAME_LENGTH);A.details=twttr.geo.getPlaceDetails(A)}A.content=Mustache.to_html(C,A);return $(Mustache.to_html(B,A))};twttr.geo.Exceptions={GeoSupportException:function(){this.msg=_("This browser does not support GeoLocation")}};twttr.geo.Errors={UnknownError:function(){this.allowRetry=true;this.fatal=true;this.msg=_("We're sorry. Something went wrong.")},PermissionDeniedError:function(){this.allowRetry=false;this.fatal=true;this.msg=_("Please grant your web browser permission to tell Twitter where you are.")},LocationAvailabilityError:function(){this.allowRetry=true;this.fatal=false;this.msg=_("We were unable to lookup your location.")},TimeoutError:function(){this.allowRetry=true;this.fatal=true;this.msg=_("The location service is currently unavailable. Try again later.")}};twttr.geo.greatCircleDistanceInKm=function(H,F,G,E){var C=Math.PI/180;var A=Math.sin((G-H)*C*0.5);var B=Math.sin((E-F)*C*0.5);var D=A*A+Math.cos(H*C)*Math.cos(G*C)*B*B;return 12742*Math.atan2(Math.sqrt(D),Math.sqrt(1-D))};twttr.geo.mapsUI={constants:{PIN_OFFSET:26},templates:{map:'<div id="geo_modal" class="hoverer">            <div class="hovercard-divot"></div>            <div class="hoverer-inner">              <div class="map_container">                <div id="map_canvas"></div>              </div>              <a href="#" class="map_close">&times;</a>            </div>          </div>'},initialize:function(){if(typeof google=="undefined"||typeof google.maps=="undefined"){return }this.defaultOptions={mapTypeId:google.maps.MapTypeId.ROADMAP,disableDefaultUI:true,scrollwheel:false,navigationControl:true,navigationControlOptions:{position:google.maps.ControlPosition.TOP_LEFT,style:google.maps.NavigationControlStyle.SMALL}};var A=this;$(".geo-pin, a.geocoded_google_link").live("click",function(C){C.preventDefault();var B=$(this).closest("span.entry-meta");A.openMapModal(B.meta(),B.find("a.geocoded_google_link"))})},closeMapModal:function(){$(".geo-pin.selected").removeClass("selected");$("#geo_modal").remove();this.map=null},openMapModal:function(G,D){this.closeMapModal();$(D).after(this.templates.map);var C=$("#map_canvas").get(0);this.map=new google.maps.Map(C,this.defaultOptions);var F=this.map;var E=this;$(".map_close").click(function(H){H.preventDefault();E.closeMapModal()});this.bounds=null;var A=false;function B(){if(!A&&G.latlng){E.addPoint(G.latlng.slice().reverse(),G.avatar_url)}E.showMap(D)}if(G.place_id){twttr.api.getPlaceDetails({place_id:G.place_id,success:function(I,K){if(F!=E.map){return }var H;var J=I.geometry.coordinates;if(I.geometry.type=="Polygon"){E.addPlacePolygon(J)}else{if(I.geometry.type=="MultiPolygon"){J.forEach(function(L){E.addPlacePolygon(L)})}else{if(I.geometry.type=="Point"){E.addPoint(J,G.avatar_url);A=true}}}B()}})}else{B()}},extendBounds:function(A){if(!this.bounds){this.bounds=new google.maps.LatLngBounds()}this.bounds.extend(A)},addPoint:function(A,D){var G=new google.maps.LatLng(A[1],A[0]);this.extendBounds(G);var F=new google.maps.MarkerImage("http://s.twimg.com/a/1273536095/images/pin.png",new google.maps.Size(43,32),null,new google.maps.Point(14,33));var B=new google.maps.Marker({flat:true,icon:F,map:this.map,position:G,zIndex:1});var C=new google.maps.MarkerImage(D,null,null,new google.maps.Point(13,32));var E=new google.maps.Marker({flat:true,icon:C,map:this.map,position:G,zIndex:2})},addPlacePolygon:function(B){if(B[0][0] instanceof Array){B=B[0]}var D=[];for(var C=0;C<B.length;C++){var A=new google.maps.LatLng(B[C][1],B[C][0]);D.push(A);this.extendBounds(A)}var E=new google.maps.Polygon({path:D,strokeColor:"#FF0000",strokeOpacity:0.5,strokeWeight:0.5,fillColor:"#FF0000",fillOpacity:0.2});E.setMap(this.map)},showMap:function(B){if(!this.bounds){return }var I=this.bounds.getSouthWest();var C=this.bounds.getNorthEast();if(C.equals(I)){this.map.setZoom(13);this.map.setCenter(C)}else{var G=this.bounds.getCenter();var E=0.7;function A(K,J){return K*E+J*(1-E)}this.map.fitBounds(new google.maps.LatLngBounds(new google.maps.LatLng(A(I.lat(),G.lat()),A(I.lng(),G.lng())),new google.maps.LatLng(A(C.lat(),G.lat()),A(C.lng(),G.lng()))))}var H=$("#geo_modal");H.visible(false);var F=$(B);F.addClass("selected");twttr.SimplePositioner.setPosition(H,F,{itemHeight:180,offsets:{above:{top:-10,left:-40},below:{top:10,left:-40}},direction:"prefer below",hasContainer:true});$("#geo_modal").click(function(J){J.stopPropagation()});var D=this;$("html").one("click",function(J){D.closeMapModal()});H.visible(true)}};$(function(){twttr.geo.mapsUI.initialize()});twttr.klass("twttr.geo.placesDropdown",function(A){this.init(A)}).augmentProto({PLACE_OVERRIDES_COOKIE:"place_overrides",MAX_PLACE_OVERRIDES:8,RADIUS_OF_STICKY_PLACE_IN_KM:0.1}).method("overrideCloseToDefault",function(B){var A=this.default_opts;if(B.lat!==undefined&&B.lon!==undefined&&A.lat!==undefined&&A.lon!==undefined&&twttr.geo.greatCircleDistanceInKm(B.lat,B.lon,A.lat,A.lon)<this.RADIUS_OF_STICKY_PLACE_IN_KM){return true}return A.ip&&A.ip==B.ip}).method("initSelectedPlace",function(A){this.default_opts={};if(A.lat!==undefined&&A.lon!==undefined){this.default_opts.lat=parseFloat(A.lat).toFixed(4);this.default_opts.lon=parseFloat(A.lon).toFixed(4)}if(A.ip!==undefined){this.default_opts.ip=A.ip}this.places=A.places;this.resetSelectedPlace()}).method("resetSelectedPlace",function(){var A=this;var B={};this.detected_place=this.places[0];this.places.forEach(function(C){if(!(A.detected_place.place_type in twttr.geo.GENERIC_PLACE_TYPES)){A.detected_place=C}B[C.id]=C});this.selected_place=this.detected_place;this.getOverrides().every(function(D){var C=B[D.id];if(C&&A.overrideCloseToDefault(D)){A.selected_place=C;return false}return true});this.saveSelectedPlace();this.showSelectedPlace()}).method("getOverrides",function(){return($.cookie(this.PLACE_OVERRIDES_COOKIE)||"").split(",").filter(function(A){return A!=""}).map(function(A){return twttr.unparam(A)})}).method("setOverrides",function(A){if(A!=this.getOverrides()){if(A.length>0){$.cookie(this.PLACE_OVERRIDES_COOKIE,A.map(function(B){return $.param(B)}).join(","),{expires:3650})}else{$.cookie(this.PLACE_OVERRIDES_COOKIE,null)}}}).method("saveSelectedPlace",function(){if(this.selected_place.place_type in twttr.geo.GENERIC_PLACE_TYPES){var A=this;var B=this.getOverrides().filter(function(C){return !A.overrideCloseToDefault(C)});if(this.selected_place.id!=this.detected_place.id){this.default_opts.id=this.selected_place.id;B.unshift(this.default_opts)}this.setOverrides(B.slice(0,this.MAX_PLACE_OVERRIDES))}}).method("showSelectedPlace",function(){var A=this.selected_place;var B;if(A.place_type in twttr.geo.GENERIC_PLACE_TYPES){B=_("in {{full_name}}")}else{B='<span class="place_icon">&nbsp;</span>'+_("at {{full_name}}")}$("#place_id").val(A.id);$("#place_name").html(Mustache.to_html(B,A));$("#places_dropdown li.selected").removeClass("selected");$("#place_"+A.id).addClass("selected")}).method("appendMorePlaces",function(){if(this.opts.more_places){this.places_list.append('<li class="geo_more_places last"><span class="place_item_icon more_places">&nbsp;</span>'+_("Search places...")+"</li>")}else{this.places_list.find("li:last").addClass("last")}}).method("rebuildPlacesDropdown",function(){this.places_list=$('<ul class="round places_list"></ul>');if(this.appendPoiPlaces(this.opts.places)){this.appendMorePlaces();this.appendNonPoiPlaces(this.opts.places)}else{this.appendNonPoiPlaces(this.opts.places);this.appendMorePlaces()}this.places_list.find("li:last").addClass("last");this.places_list.append($('<li class="geo_enable_webclient"><span class="place_item_icon refresh">&nbsp;</span>'+_("Refresh location")+'</li><li class="geo_disable_webclient"><span class="place_item_icon clear">&nbsp;</span>'+_("Clear location")+"</li>"));var A=this;$("#places_dropdown").empty().append(this.places_list);$(".geo_more_places").click(function(B){new twttr.geo.PlaceSearchDialog(A.opts,function(C){A.selectPlace(C)});B.preventDefault()})}).method("init",function(C){this.opts=C;var B=this;var A="<a id='place_link' href='#'><span id='place_name'></span> ▾</a><div id='places_dropdown'></div>";$("#place_content").html(A).bind("tweet",function(){B.resetSelectedPlace()});this.rebuildPlacesDropdown();this.initSelectedPlace(this.opts);$("#place_link").click(function(D){D.preventDefault();if($("#places_dropdown:visible").length>0){B.closeMenu()}else{B.openMenu();D.stopPropagation()}})}).method("openMenu",function(){var B=this;var A=$("#place_link");var C=$("#place_link").position();$("#places_dropdown").css({left:C.left,top:C.top+A.outerHeight()}).show();$("html").one("click",function(){B.closeMenu()})}).method("closeMenu",function(){$("#places_dropdown").hide()}).method("appendPoiPlaces",function(A){var B=false;A.forEach(function(C){if(C.place_type=="poi"){this.places_list.append(this.createPlaceItem(C));B=true}},this);return B}).method("appendNonPoiPlaces",function(A){A.forEach(function(B){if(B.place_type!="poi"){this.places_list.append(this.createPlaceItem(B))}},this)}).method("createPlaceItem",function(A){var C=this;var B=twttr.geo.renderPlace(twttr.geo.templates.dropdownItem,A);B.click(function(D){D.preventDefault();C.selectPlace(A)});return B}).method("selectPlace",function(A){if(this.selected_place.id!=A.id){var C=this;var B=this.places.every(function(D){if(D.id==A.id){C.selected_place=D;C.showSelectedPlace();C.saveSelectedPlace();return false}return true});if(B){this.places.unshift(A);this.selected_place=A;this.rebuildPlacesDropdown();this.showSelectedPlace()}}this.closeMenu()});twttr.augmentString("twttr.geo.defaultOptions",{refresh:false,onSuccess:function(A){},onFailure:function(A){},onComplete:function(){}});twttr.geo.geocoder={MAX_PLACES_PER_TYPE:{city:5,neighborhood:5,"default":10},parseResults:function(D,B,G){var A=D.result["places"];var H=[];var I=0;for(var E=0;E<A.length;E++){var C=A[E].place_type||"default";var F=this.MAX_PLACES_PER_TYPE[C]||this.MAX_PLACES_PER_TYPE["default"];if(I<F){H.push(A[E])}I++;if(E==A.length-1||C!=A[E+1].place_type){I=0}}if(H.length>0){G.call(this,H)}else{throw new twttr.geo.Errors.LocationAvailabilityError}},lookupNearbyPlaces:function(E,D,B){var C=this;var A={data:E,success:function(F,G){C.parseResults(F,G,D)},error:B};twttr.api.lookupNearbyPlaces(A)}};twttr.klass("twttr.geo.PlaceSearchDialog",function(C,K){this.onPlaceChange=K;this.params=C;var H=_("Type the name of a place");var I='<div id="place_search_dialog"><form id="place_search_form"><input id="place_search_query" type="text" autocomplete="off" name="place_search_query" class="place_search_query help-focusable round-left" title="'+H+'"/><span class="place_search_submit round-right" title="'+_("Search")+'">&nbsp;</span><div id="place_search_dropdown"></div></form><div id="place_search_results"></div></div>';$(".place_search_dialog").remove();var A=$(I).appendTo("body");this.autoCompleteCache={};this.dialog=new twttr.dialog({content:A,heading:$("<h2/>").text(_("Where Are You?")),footer:null,cssClass:"place_search_dialog",closeButton:true,renderInline:true,modal:true});var B=$("#place_search_query").helpText().focus();var G=this;this.searchParams={max_results:twttr.geo.MAX_PLACE_SEARCH_RESULTS,granularity:C.granularity};["lat","lon","ip","accuracy"].forEach(function(L){if(C[L]!==undefined){G.searchParams[L]=C[L]}});var F=$("#place_search_form");var J=$("#place_search_results");F.submit(function(M){M.preventDefault();$("#place_search_dropdown").hide();var L=G.getPlaceSearchQuery();if(L===""){J.text(_("Please enter a search query."));return }G.lastAutocompleteQuery=L;G.setWaitCursor(true);J.html(Mustache.to_html(_('Searching for "{{query}}"...'),{query:L}));twttr.api.lookupNearbyPlaces({data:twttr.merge({},G.searchParams,{query:L}),success:function(N,O){G.setWaitCursor(false);G.displayResults(N,O)},error:function(N,P,O){G.setWaitCursor(false);G.displaySearchError(N,P,O)}})});$(".place_search_submit").click(function(){F.submit()});B.keydown(function(L){if(L.keyCode==40){G.firstKeyPress=true;$("#place_search_dropdown").show().find("ul").addClass("nohover").find("li:first").focus();L.preventDefault()}else{if(L.keyCode==27){if($("#place_search_dropdown:visible").hide().length==1){$("#place_search_query").focus();L.stopPropagation()}}else{G.updateAutocomplete()}}}).keypress(function(L){G.updateAutocomplete()}).change(function(){G.updateAutocomplete()});J.append("<ul/>");for(var E=0,D=J.find("ul");E<twttr.geo.MAX_PLACE_SEARCH_RESULTS;E++){D.append("<li>&nbsp;</li>")}this.dialog.open();J.empty()}).method("setWaitCursor",function(A){$(".place_search_submit").toggleClass("loading",A)}).method("displayResults",function(D,F){var B=D.result.places;var A=$("#place_search_results").empty();if(B.length==0){A.html(Mustache.to_html(_('We couldn\'t find "{{query}}"!'),{query:$("#place_search_query").val()}))}var E=$("<ul/>").appendTo(A);var C=this;B.forEach(function(G){var H=twttr.geo.renderPlace(twttr.geo.templates.searchResultItem,G);H.find("a").click(function(I){I.preventDefault();C.dialog.close();C.onPlaceChange(G)});E.append(H)})}).method("displaySearchError",function(A,C,B){$("#place_search_results").text(_("Sorry, search is temporarily unavailable, please try again later."))}).method("updateAutocomplete",function(){var A=this;clearTimeout(this.timerId);this.timerId=setTimeout(function(){var B=A.getPlaceSearchQuery();A.displayAutocompleteDropdown();if(B===""||A.autoCompleteCache[B]!==undefined){return }A.autoCompleteCache[B]=null;twttr.api.lookupNearbyPlaces({data:twttr.merge({},A.searchParams,{query:B,autocomplete:"true"}),success:function(C,D){A.autoCompleteCache[B]=C.result.places;A.displayAutocompleteDropdown()},error:function(){A.autoCompleteCache[B]=undefined;A.displayAutocompleteDropdown()}})},twttr.geo.PLACE_SEARCH_AUTOCOMPLETE_DELAY)}).method("getPlaceSearchQuery",function(){var A=$("#place_search_query");return A.isBlankOrHelp()?"":$.trim(A.val())}).method("createAutocompletePlaceItem",function(A){var B=this;return twttr.geo.renderPlace(twttr.geo.templates.autocompleteItem,A).click(function(C){B.dialog.close();B.onPlaceChange(A)}).keydown(function(C){switch(C.keyCode){case 38:$(this).prev().focus();break;case 40:$(this).next().focus();break;case 13:$(this).click();break;case 27:$("#place_search_dropdown").hide();$("#place_search_query").focus();break;default:return }B.firstKeyPress=true;C.stopPropagation();C.preventDefault()}).keypress(function(C){switch(C.keyCode){case 38:if(!B.firstKeyPress){$(this).prev().focus()}break;case 40:if(!B.firstKeyPress){$(this).next().focus()}break;default:return }B.firstKeyPress=false;C.preventDefault()}).hover(function(C){if($("#place_search_dropdown ul").hasClass("nohover")){$(this).focus()}},function(){})}).method("displayAutocompleteDropdown",function(){var D=this.getPlaceSearchQuery();var A=this.autoCompleteCache[D];var C=$("#place_search_dropdown");if(!A||A.length==0){C.hide();return }if(this.lastAutocompleteQuery!=D){C.html('<ul class="round places_list"/>').hide();var E=C.find("ul");var B=this;A.forEach(function(F){E.append(B.createAutocompletePlaceItem(F))});this.lastAutocompleteQuery=D;C.show()}});twttr.klass("twttr.geo.Position",function(C,A,B){this.latitude=C;this.longitude=A;this.accuracy=B;this.timestamp=(new Date()).getTime()});twttr.klass("twttr.geo.Locator",function(A){this.position=null;this.locator=null;this.ff_geo=false;if(A&&A.lat!==undefined&&A.lon!==undefined){this.locator={getCurrentPosition:function(B){B({coords:{latitude:A.lat,longitude:A.lon,accuracy:A.accuracy||200}})}}}else{if(navigator&&navigator.geolocation){this.locator=navigator.geolocation;this.ff_geo=true}else{if(typeof google!="undefined"&&typeof google.gears!="undefined"){this.locator=google.gears.factory.create("beta.geolocation")}}}}).method("_getPositionSuccessCallback",function(C,B){var A=this;var D=function(E){if(D._calls==0){A._setGeoFirefoxBannerSeen();A.position=new twttr.geo.Position(E.coords.latitude,E.coords.longitude,E.coords.accuracy);B.call(A);C.call(A,A.position)}D._calls++};D._calls=0;return D}).method("_getPositionErrorCallback",function(B,C){var A=this;var D=function(F){A._setGeoFirefoxBannerSeen();var E;switch(F.code){case F.PERMISSION_DENIED:E=new twttr.geo.Errors.PermissionDeniedError();break;case F.POSITION_UNAVAILABLE:E=new twttr.geo.Errors.LocationAvailabilityError();break;case F.TIMEOUT:E=new twttr.geo.Errors.TimeoutError();break;default:E=new twttr.geo.Errors.UnknownError();break}if(E.fatal){var G=new ShortNotification();G.setMessage(E.msg);G.show()}C.call(A);B.call(A,E)};return D}).method("_getLocation",function(A){if(!this.isLocatable()){throw new twttr.geo.Exceptions.GeoSupportException()}else{this.locator.getCurrentPosition(this._getPositionSuccessCallback(A.onSuccess,A.onComplete),this._getPositionErrorCallback(A.onFailure,A.onComplete))}}).method("hasCachedLocation",function(){return !!this.position}).method("isStaleLocation",function(){var A=((new Date()).getTime()-this.position.timestamp);return A>twttr.geo.LOCATION_CACHE_INTERVAL}).method("isLocatable",function(){return !!(this.locator)}).method("getLocation",function(A){var B=$.extend({},twttr.geo.defaultOptions,A);if(this.hasCachedLocation()&&!this.isStaleLocation()&&!B.refresh){B.onComplete();B.onSuccess.call(this,this.position)}else{if(!this._getGeoFirefoxBannerSeen()){this._detectFirefoxGeoBanner()}this._getLocation(B)}}).method("_getWindowHeight",function(){return $(window).height()}).method("_getGeoFirefoxBannerSeen",function(){return $.cookie("geo_ff_banner_seen")}).method("_setGeoFirefoxBannerSeen",function(){if(this.ff_geo){this._clearDetectFirefoxGeoBanner();if(!this._getGeoFirefoxBannerSeen()){$.cookie("geo_ff_banner_seen","1",{expires:3650})}}}).method("_showFirefoxGeoBanner",function(){$('<div id="ff_geo_banner">         <div>'+_("Before Twitter can get your location...")+'</div>         <div><img src="images/ff_geo_banner1.png" />'+_('Check "Remember for this site"')+'</div>         <div><img src="images/ff_geo_banner2.png" />'+_('Click "Share Location"')+"</div>       </div>").appendTo("body").show()}).method("_detectFirefoxGeoBanner",function(){if(this.ff_geo){var B=this._getWindowHeight();var A=this;this.ff_geo_timer=setTimeout(function(){if(A._getWindowHeight()<B){A._showFirefoxGeoBanner();A.ff_geo_interval=setInterval(function(){if(A._getWindowHeight()==B){A._clearDetectFirefoxGeoBanner()}},twttr.geo.FIREFOX_GEO_BANNER_DISAPPEAR_INTERVAL)}},twttr.geo.FIREFOX_GEO_BANNER_APPEAR_DELAY)}}).method("_clearDetectFirefoxGeoBanner",function(){clearTimeout(this.ff_geo_timer);clearInterval(this.ff_geo_interval);$("#ff_geo_banner").remove()});twttr.klass("twttr.geo.updateUi",function(B){this.opts=twttr.merge({geo_enabled:false,has_dismissed_geo_promo:false,current_user_path:null,granularity:"neighborhood",more_places:false,autocomplete:false,queryParams:window.location.search.substr(1)},B);this.locator=new twttr.geo.Locator(twttr.unparam(this.opts.queryParams));if(!this.locator.isLocatable()){return }var A=this;$(".geo_enable_webclient").live("click",function(C){C.preventDefault();A.enableGeoForWebClient()});$(".geo_disable_webclient").live("click",function(C){C.preventDefault();A.disableGeoForWebClient()});if(this.opts.geo_enabled){if($.cookie("geo_webclient")){this.refreshLocation()}else{this.disableGeoForWebClient()}}else{if(!$.cookie("geo_promo_hidden")&&!$("#latest_status.first-tweet").length){this.setGeoStatus('<span class="geo_new">'+_("New!")+"</span> "+_("Add a location to your tweets.")+' <a id="show_geo_dialog" href="#">'+_("Turn it on")+'</a> - <a id="hide_geo_promo" href="#">'+_("No thanks")+"</a>");$("#hide_geo_promo").click(function(C){C.preventDefault();if(!$(this).hasClass("link-disabled")){A.hidePromoDialog();$.cookie("geo_promo_hidden","1",{expires:3650});$("#geo_status").slideUp()}});$("#show_geo_dialog").click(function(C){C.preventDefault();if(!$(this).hasClass("link-disabled")){A.showPromoDialog()}return false});if(!this.opts.has_dismissed_geo_promo&&$("#convergence_notice:visible").length==0){this.showPromoDialog()}}}}).augmentProto({templates:{disable_geo:' <a href="#" class="geo_disable_webclient"><span>&nbsp;</span></a>'}}).method("setGeoStatus",function(A){$("#geo_status").html(A)}).method("_lookupPlacesAndShowDropdown",function(E){try{var B=this;var D=function(F){B.setGeoStatus('<span id="place_content"></span>'+B.templates.disable_geo);new twttr.geo.placesDropdown({places:F,lat:E.lat,lon:E.lon,accuracy:E.accuracy,ip:E.ip,granularity:E.granularity,more_places:B.opts.more_places,autocomplete:B.opts.autocomplete})};var A=function(F,H,G){B.setGeoStatus(_("Unable to contact Twitter location service.")+' <a href="#" class="geo_enable_webclient">'+_("Try again")+"</a>"+B.templates.disable_geo)};twttr.geo.geocoder.lookupNearbyPlaces(E,D,A)}catch(C){this.setGeoStatus(_("Unable to associate your coordinates with a place.")+' <a href="#" class="geo_enable_webclient">'+_("Try again later")+"</a>"+this.templates.disable_geo)}}).method("refreshLocation",function(){$("#lat").val("");$("#lon").val("");$("#place_id").val("");this.setGeoStatus('<span class="crosshairs">&nbsp;</span><span class="geo_progress">'+_("Getting your location...")+"</span>"+this.templates.disable_geo);var A=this;this.locator.getLocation({onSuccess:function(B){$("#lat").val(B.latitude);$("#lon").val(B.longitude);A._lookupPlacesAndShowDropdown({lat:B.latitude,lon:B.longitude,accuracy:B.accuracy,granularity:A.opts.granularity,max_results:twttr.geo.MAX_NEARBY_PLACES})},onFailure:function(B){if(!B.fatal&&twttr.geo.IP){A._lookupPlacesAndShowDropdown({ip:twttr.geo.IP,accuracy:16000,granularity:"city",max_results:5})}else{if(B.allowRetry){A.setGeoStatus(_("Unable to locate you.")+' <a href="#" class="geo_enable_webclient">'+_("Try again")+"</a>"+A.templates.disable_geo)}else{A.disableGeoForWebClient()}}},options:{timeout:10000,enableHighAccuracy:true}})}).method("showPromoDialog",function(){var C=$("#show_geo_dialog");var A=$('<div class="hoverer" id="geo-promo-hoverer">         <div class="hoverer-inner">          <div class="tiny-map"><img src="http://s.twimg.com/a/1273536095/images/tiny-map.gif"></div>          <h3>'+_("Add a location to your tweets")+'</h3>          <div id="geo_dialog_descr">'+_('Ever had something you wanted to share ("fireworks!", "party!", "ice cream truck!", or "quicksand...") that would be better with a location?')+" "+_("By turning on this feature, you can include location information like neighborhood, town, or exact point when you tweet.")+"<br><br>"+_("When you tweet with a location, Twitter stores that location.")+" "+_("You can switch location on/off before each tweet and always have the option to delete your location history.")+' <a id="geo_learn_more" href="http://twitter.zendesk.com/forums/26810/entries/78525" target="_blank">'+_("Learn more")+'</a>          </div>          <div>            <button id="geo_turn_location_on" class="btn">'+_("Turn location on")+'</button>            <a href="#" id="geo_not_now" class="geo_dialog_close">'+_("Not now")+'</a>          </div>        </div>        <div class="hovercard-divot"></div>      </div>').insertAfter(C);twttr.SimplePositioner.setPosition(A,C,{direction:"below",offsets:{below:{top:10,left:-50}},hasContainer:true});$("#show_geo_dialog,#hide_geo_promo").addClass("link-disabled");var B=this;$("#geo_turn_location_on").click(function(){B.turnLocationOn()});$(".geo_dialog_close").click(function(D){D.preventDefault();B.hidePromoDialog()});$("#geo-promo-hoverer").click(function(D){D.stopPropagation()});$("html").one("click",function(){if($("#geo-promo-hoverer:visible").length>0){B.hidePromoDialog()}});A.css("visibility","visible")}).method("hidePromoDialog",function(){if(!this.opts.has_dismissed_geo_promo){this.setUserFlag("has_dismissed_geo_promo");this.opts.has_dismissed_geo_promo=true}$("#geo-promo-hoverer").remove();$("#show_geo_dialog,#hide_geo_promo").removeClass("link-disabled")}).method("turnLocationOn",function(){this.setUserFlag("geo_enabled");this.opts.geo_enabled=true;this.hidePromoDialog();this.enableGeoForWebClient()}).method("setUserFlag",function(A){data={authenticity_token:twttr.form_authenticity_token,_method:"put"};data["user["+A+"]"]="1";$.ajax({type:"POST",url:this.opts.current_user_path,data:data})}).method("enableGeoForWebClient",function(){if(!$.cookie("geo_webclient")){$.cookie("geo_webclient","1",{expires:3650})}this.refreshLocation()}).method("disableGeoForWebClient",function(){$("#lat").val("");$("#lon").val("");$("#place_id").val("");if($.cookie("geo_webclient")){$.cookie("geo_webclient",null)}this.setGeoStatus('<span class="crosshairs">&nbsp;</span><a href="#" class="geo_enable_webclient">'+_("Add your location")+"</a>")});