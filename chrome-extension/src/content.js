chrome.runtime.onMessage.addListener(async function(request, sender, sendResponse) {
	if (request.type === 'get_video') {
		const isYoutube = /^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$/.test(String(window.location));

		if (isYoutube) {
			const url = await getVideoSource(getParameterByName('v'));
			openUrl(url);
		} else {
			openUrl(getDefaultUrl())
		}
	}
});

function getDefaultUrl() {
	return document.querySelector('video').src;
}

function getYoutubeUrls(callback) {
	var scr = document.createElement('script');
	//appending text to a function to convert it's src to string only works in Chrome
	scr.textContent = '(' + function () { 
	  const videoUrls = ytplayer.config.args.adaptive_fmts
		.split(',')
		.map(item => item
			.split('&')
			.reduce((prev, curr) => (curr = curr.split('='),
				Object.assign(prev, {[curr[0]]: decodeURIComponent(curr[1])})
				), {})
			)
		.reduce((prev, curr) => Object.assign(prev, {
			[curr.quality_label || curr.type]: curr
		}), {});

	  const event = document.createEvent("CustomEvent");  
	  event.initCustomEvent("VideoUrlsDiscovered", true, true, {urls: videoUrls});
	  window.dispatchEvent(event); 
	} + ')();';
	(document.body).appendChild(scr);
	scr.parentNode.removeChild(scr);
	//now listen for the message
	window.addEventListener("VideoUrlsDiscovered", function (e) {
		callback(e.detail.urls);
	}, { once: true });
}

function submitRequest(buttonId) {
  var d = (window.parent)?window.parent.document:window.document
  if (d.getElementById(buttonId) == null || d.getElementById(buttonId) == undefined) return;
  if (d.getElementById(buttonId).dispatchEvent) {
    var e = d.createEvent("MouseEvents");
    e.initEvent("click", true, true);
    d.getElementById(buttonId).dispatchEvent(e);
  } 
  else {
    d.getElementById(buttonId).click();
  }
}

function openUrl(url, time){
	time = time || 0
  var d = (window.parent)?window.parent.document:window.document
  var f = d.getElementById('customUrlLink')
  if (f ) {f.parentNode.removeChild(f);}
  var a = d.createElement('a');
  a.href =  'betterpip://open?url=' + encodeURIComponent(url) //+ '&time=' + encodeURIComponent(time);    
  console.log(a.href);
  a.innerHTML = "Link"                                    
  a.setAttribute('id',        'customUrlLink');
  a.setAttribute("style", "display:none; "); 
  d.body.appendChild(a); 
  submitRequest("customUrlLink");
}

async function getVideoSource(id) {
	const response = await fetch(`https://www.youtube.com/get_video_info?video_id=${id}`);
	const body = await response.text();
	const videoData = decodeVideoQueryString(body);

	if (videoData.status === 'fail')
		return null;

	const videoSources = decodeVideoStreamMap(videoData.url_encoded_fmt_stream_map);
	const source = videoSources['video/mp4 hd720'] || videoSources['video/mp4 medium'];

	if (source) {
		return source.url;
	}

	return null;
}

function decodeVideoQueryString(queryString) {
	var key, keyValPair, keyValPairs, r, val, _i, _len;
    r = {};
    keyValPairs = queryString.split("&");
    for (_i = 0, _len = keyValPairs.length; _i < _len; _i++) {
      keyValPair = keyValPairs[_i];
      key = decodeURIComponent(keyValPair.split("=")[0]);
      val = decodeURIComponent(keyValPair.split("=")[1] || "");
      r[key] = val;
    }
    return r;
}

function decodeVideoStreamMap(streamMap) {
	var quality, sources, stream, type, urlEncodedStream, _i, _len, _ref;
    sources = {};
    _ref = streamMap.split(",");
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      urlEncodedStream = _ref[_i];
      stream = decodeVideoQueryString(urlEncodedStream);
      type = stream.type.split(";")[0];
      quality = stream.quality.split(",")[0];
      stream.original_url = stream.url;
      stream.url = "" + stream.url + "&signature=" + stream.sig;
      sources["" + type + " " + quality] = stream;
    }
    return sources;
}

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}