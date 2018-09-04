var electronInstaller = require('electron-winstaller');

var settings = {
    appDirectory: './built/tncSync-win32-x64',
    outputDirectory: './installer',
    authors: 'Emery Anderson',
    exe: 'tncSync.exe',
    version: '0.1.4',
    noMsi: true
};

resultPromise = electronInstaller.createWindowsInstaller(settings);

resultPromise.then(() => {
    console.log("Installer succesfully created !");
}, (e) => {
    console.log(`Build failed, you suck at this!: ${e.message}`)
});