// Get an mp4 stream url for a given youtube video ID.
async function getYoutubeVideoData(videoId) {
  const response = await fetch(`https://www.youtube.com/get_video_info?video_id=${videoId}`);
  const body = await response.text();
  const videoData = decodeUrlEncodedString(body);

  if (videoData.status === 'fail')
    return null;

  const videoSources = parseStreamMapUrls(videoData.url_encoded_fmt_stream_map);
  const source = videoSources['hd720'] || videoSources['medium'];

  const videoElement = document.querySelector('video');

  if (videoElement)
    videoElement.pause();
  
  return {
    url: source,
    time: videoElement
      ? videoElement.currentTime
      : 0.0
  };
}

// Decodes a url-like encoded data string (key1=val&key2=val)
function decodeUrlEncodedString(queryString) {
  const entities = queryString.split('&');
  let data = {};
  
  for (const pair of entities) {
    const split = pair.split('=');
    const key = decodeURIComponent(split[0]);
    const value = decodeURIComponent(split[1]);

    data[key] = value;
  }

  return data;
}

// Gets mp4 videos from stream map data
function parseStreamMapUrls(streamMap) {
  let urls = {};

  const streams = streamMap.split(',');
  for (const encodedStream of streams) {
    const stream = decodeUrlEncodedString(encodedStream);
    if (stream.type.includes('video/mp4')) {
      urls[stream.quality] = stream.url;
    }
  }

  return urls;
}