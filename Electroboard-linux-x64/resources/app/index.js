const electron = require('electron');
const app = electron.app;

var BrowserWindow = electron.BrowserWindow;

app.on('ready', function(){
  var mainWindow = new BrowserWindow({width: 1024, height: 600});
  mainWindow.setMenu(null);
  mainWindow.loadURL('file://' + __dirname + '/index.html');
  //mainWindow.webContents.openDevTools();
});
