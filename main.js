var menubar = require("menubar");
var path = require("path");
var fileUrl = require("file-url");
var jenkins = require("jenkins-api");
const { BrowserWindow, app } = require("electron");

const DEBUG = true;

app.on("ready", function() {
  // showOAuth();
  showMenubar();
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

function fetchProjects(callback) {
  var user = "avh4";
  var token = "843ea8d4c4ac796abb7a53aaf491052d";
  var ci = jenkins.init(
    "https://" + user + ":" + token + "@jenkins.noredink.com"
  );

  console.log("Fetching projects from Jenkins...");

  ci.all_jobs(function(err, data) {
    // TODO: error checking
    console.log("Got projects from Jenkins");
    callback(data);
  });
}

function showMenubar() {
  var mb = menubar({
    // dir: __dirname,
    index: fileUrl(path.join(__dirname, "index.html")),
    icon: path.join(__dirname, "icon.png"),
    width: DEBUG ? 1000 : null,
    height: DEBUG ? 800 : null
  });

  mb.on("ready", function ready() {
    // TODO: why doesn't this run?
    console.log("app is ready");
    console.log(mb.getOption("index"));

    // mb.tray.setImage(path.join(__dirname, "icon.png"));
    //
  });

  mb.on("after-create-window", function() {
    if (DEBUG) {
      mb.window.openDevTools();
    }
  });
  const { ipcMain } = require("electron");
  ipcMain.on("jenkins-projects", (event, arg) => {
    fetchProjects(data => {
      event.sender.send("jenkins-projects-reply", data);
    });
  });
}
