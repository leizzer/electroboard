class FileManager {
  constructor() {
    this.remote = require('electron').remote;
    this.dialog = this.remote.dialog;
    this.fs = require('fs');
  }

  openSaveFile(content) {
    var fs = this.fs;

    this.dialog.showSaveDialog(function (fileName) {
      if (fileName === undefined){
        console.log("You didn't save the file");
        return;
      }

      // fileName is a string that contains the path and filename created in the save file dialog.
      fs.writeFile(fileName, content, function (err) {
        if(err){
          alert("An error ocurred creating the file "+ err.message)
        }

        alert("The file has been succesfully saved");
      });
    });
  }

  loadFile() {
    var fs = this.fs;

    this.dialog.showOpenDialog(function(fileName) {
      if (fileName === undefined){
        console.log("You didn't selacted a file");
        return;
      }

      var firmware = Opal.Firmware.$instance()
      var result = fs.readFileSync(fileName[0], 'utf8');

      firmware.$load(result);
    });
  }
}
