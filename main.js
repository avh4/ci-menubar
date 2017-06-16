var menubar = require("menubar");
var path = require("path");
var fileUrl = require("file-url");
var jenkins = require("jenkins-api");
const { BrowserWindow, app } = require("electron");

// var mb = menubar({
//   // dir: __dirname,
//   index: fileUrl(path.join(__dirname, "index.html")),
//   icon: path.join(__dirname, "icon.png"),
// });
//
//

app.on("ready", function() {
  showOAuth();
});

function showOAuth() {
  var authWindow = new BrowserWindow({
    width: 800,
    height: 600,
    titleBarStyle: "hiddenInset",
    show: false,
    "node-integration": false
  });
  var authUrl = "https://jenkins.noredink.com";
  authWindow.loadURL(authUrl);
  authWindow.show();

  function handleCallback(url) {
    console.log(url);
    if (url === "https://jenkins.noredink.com/") {
      authWindow.destroy();
    }
  }

  authWindow.webContents.on("will-navigate", function(event, url) {
    handleCallback(url);
  });

  authWindow.webContents.on("did-get-redirect-request", function(
    event,
    oldUrl,
    newUrl
  ) {
    handleCallback(newUrl);
  });

  // Reset the authWindow on close
  authWindow.on(
    "close",
    function() {
      authWindow = null;
      console.log("authWindow closed");
    },
    false
  );
}

//
// var ci = jenkins.init("https://jenkins.noredink.com");
//
// ci.all_jobs(function(err, data) {
//   console.log(err, data);
// });
//
// mb.on('ready', function ready () {
//   console.log('app is ready')
//   console.log(mb.getOption('index'));
//
//   // mb.tray.setImage(path.join(__dirname, "icon.png"));
//   //
// })
