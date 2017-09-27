function onClick(tab) {
  chrome.tabs.sendMessage(tab.id, { type: 'get_video' }, function(response) {
    if (response && !response.success) {
      chrome.notifications.create(null, {
        type: "basic",
        title: "Unable to use Picture-in-Picture",
        message: "Please make sure there is an HTML5 Video on the page.",
        iconUrl: "new_icon.png"
      });
    }
  });

}

chrome.browserAction.onClicked.addListener(onClick);

if (chrome.runtime && chrome.runtime.onStartup) {
  chrome.runtime.onStartup.addListener(function() {
    console.log('Starting browser... updating icon.');
  });
} else {
  // This hack is needed because Chrome 22 does not persist browserAction icon
  // state, and also doesn't expose onStartup. So the icon always starts out in
  // wrong state. We don't actually use onStartup except as a clue that we're
  // in a version of Chrome that has this problem.
  chrome.windows.onCreated.addListener(function() {
    console.log('Window created... updating icon.');
  });
}