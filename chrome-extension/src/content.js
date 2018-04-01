chrome.runtime.onMessage.addListener(async function(request, sender, sendResponse) {
  if (request.type === 'get_video') {
    const pageUrl = String(window.location);
    const isYoutube = /^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$/.test(pageUrl);
    let videoData = null;
    if (isYoutube) {
      const videoId = getParameterByName('v');
      videoData = await getYoutubeVideoData(videoId);
    } else {
      videoData = getDefaultVideoData();
    }

    if (videoData) {
      openUrl(videoData);
      sendResponse({url: pageUrl,
                    success: true});
    } else {
      sendResponse({url: pageUrl,
                    success: false});
    }

  }

});