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
