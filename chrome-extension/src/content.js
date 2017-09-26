chrome.runtime.onMessage.addListener(async function(request, sender, sendResponse) {
  if (request.type === 'get_video') {
    const pageUrl = String(window.location);
    const isYoutube = /^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$/.test(pageUrl);

    if (isYoutube) {
      const videoId = getParameterByName('v');
      const url = await getYoutubeVideoSource(videoId);
      openUrl(url);
    } else {
      const url = getDefaultUrl();
      openUrl(url);
    }
  }
});