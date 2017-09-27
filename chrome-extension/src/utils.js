function getParameterByName(name, url) {
  if (!url) url = window.location.href;
  name = name.replace(/[\[\]]/g, "\\$&");
  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
  results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return '';
  return decodeURIComponent(results[2].replace(/\+/g, " "));
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

function openUrl(videoData) {
  if (!videoData) return;

  var d = (window.parent)?window.parent.document:window.document
  var f = d.getElementById('customUrlLink')
  if (f ) {f.parentNode.removeChild(f);}
  var a = d.createElement('a');
  a.href =  'betterpip://open?url=' + encodeURIComponent(videoData.url) + '&time=' + encodeURIComponent(videoData.time);
  alert(a.href);
  a.innerHTML = "Link"                                    
  a.setAttribute('id','customUrlLink');
  a.setAttribute("style", "display:none; "); 
  d.body.appendChild(a); 
  submitRequest("customUrlLink");
}

function getDefaultVideoData() {
  const video = document.querySelector('video');
  if (!video) return;
  
  const videoSource = video.querySelector('source[type=video\\/mp4]');

  video.pause();

  return videoSource && videoSource.src
    ? { url: videoSource.src, time: video.currentTime || 0.0 }
    : null;
}