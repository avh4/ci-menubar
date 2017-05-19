var menubar = require('menubar')
var path = require('path');
var fileUrl = require('file-url');

var mb = menubar({
  // dir: __dirname,
  index: fileUrl(path.join(__dirname, "index.html")),
  icon: path.join(__dirname, "icon.png"),
});

mb.on('ready', function ready () {
  console.log('app is ready')
  console.log(mb.getOption('index'));

  // mb.tray.setImage(path.join(__dirname, "icon.png"));
})

