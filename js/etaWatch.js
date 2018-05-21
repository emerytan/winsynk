const bootstrap = require('bootstrap')
const $ = jQuery = require('jquery')
const EventEmitter = require('events')
const fs = require('fs')
const path = require('path')
const spawn = require('child_process').spawn
const {
    StringDecoder
} = require('string_decoder')
const decoder = new StringDecoder('utf8')
const {
    remote
} = require('electron')
const {
    dialog
} = remote
const ipc = require('electron').ipcRenderer
const schedule = require('node-schedule')

/// locals
var safetyFirst = '//10.34.140.250/panama/VFX/Users/Emery'
var autoAssetsState = false
var autoShotsState = false
var cronAss
var cronShots
var appDir = process.cwd()



/// view
window.onload = function () {
    ipc.send('view loaded')

    let buttons = document.getElementsByTagName('button')
    for (var index = 0; index < buttons.length; index++) {
        buttons[index].addEventListener('click', (event) => {
            var element = this.event.target.id
            var commandOptions = this.event.target.dataset
            if (commandOptions.action !== 'clear') {
                Promise.all([
                        isPanama(safetyFirst), checkPath(commandOptions.source), checkPath(commandOptions.destination)
                    ])
                    .then((accept) => {
                        switch (commandOptions.action) {
                            case 'syncAss':
                                runAssets(commandOptions.source, commandOptions.destination, 'exclude: mdl* setref*')
                                break;
                            case 'shotsSync':
                                runShots(commandOptions.source, commandOptions.destination, 'exlude: from file list')
                                break;
                            case 'autoAss':
                                scheduleAssets(commandOptions.source, commandOptions.destination, 'exclude: mdl* setref*')
                                break;
                            case 'autoShots':
                                scheduleShots(commandOptions.source, commandOptions.destination, 'exlude: from file list')
                                break;
                            default:
                                clearPage()
                                break;
                        }
                    })
                    .catch((reason) => {
                        document.getElementById('debugMessages').innerHTML = 'Promise rejected' + reason
                    })

            } else {
                clearPage('assetsOutput')
                clearPage('shotsOutput')
            }
        })
    }

    ipc.on('init view', (event, message) => {
        document.getElementById('isPanama').innerHTML = message
        $('#shotsAutoState').text('shots auto off').css('color', 'yellow')
        $('#assetsAutoState').text('assets auto off').css('color', 'yellow')        
              
    })
}


function isPanama(arg) {
    return new Promise((resolve, reject) => {
        fs.access(arg, (err) => {
            if (err) {
                document.getElementById('pre').innerHTML = err
                reject(err)
            } else {
                document.getElementById('isPanama').innerHTML = 'panama resolved'
                resolve(true)
            }
        })
    })
}

function checkPath(testPath) {
    return new Promise((resolve, reject) => {
        fs.access(testPath, (err) => {
            if (err) {
                reject(err)
            } else {
                resolve(testPath)
            }
        })
    })
}

function disableButtons(state) {
    let buttons = document.getElementsByTagName('button')
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].disabled = state
    }
}


function runAssets(source, destination, ...args) {
    clearPage('assetsOutput')
    document.getElementById('assetsSource').innerHTML = source
    document.getElementById('assetsDest').innerHTML = destination
    document.getElementById('assetsSafetyFirst').innerHTML = args
    document.getElementById('assetsState').innerHTML = 'syncing'

    let pinToBottom = document.getElementById('assetsOutput')
    document.getElementById('syncAssets').disabled = true

    let shits = path.resolve('./bin/roboAss.ps1')
    const assets = spawn('powershell', [shits])

    assets.stdout.on('data', (data) => {
        $('#assetsOutput').append(decoder.write(data))
        pinToBottom.scrollTop = pinToBottom.scrollHeight
    })

    assets.stderr.on('data', (data) => {
        $('#assetsOutput').append(decoder.write(data))
        pinToBottom.scrollTop = pinToBottom.scrollHeight
    })

    assets.on('close', (code) => {
        pinToBottom.scrollTop = pinToBottom.scrollHeight
        document.getElementById('assetsMessages').innerHTML = `assets exit code: ${code.toString()}`
        if (autoAssetsState === false) {
            document.getElementById('syncAssets').disabled = false
        }
    })

    assets.on('exit', (data) => {
        let finish = getTime()
        document.getElementById('assetsState').innerHTML = `last sync at: ${finish}`
    })
}

function runShots(source, destination, ...args) {
    clearPage('shotsOutput')
    document.getElementById('shotsSource').innerHTML = source
    document.getElementById('shotsDest').innerHTML = destination
    document.getElementById('shotsSafetyFirst').innerHTML = args
    document.getElementById('shotsState').innerHTML = 'syncing'

    let pinToBottom = document.getElementById('shotsOutput')
    document.getElementById('syncShots').disabled = true

    let poops = path.resolve('./bin/roboShots.ps1')
    const shots = spawn('powershell', [poops])

    shots.stdout.on('data', (data) => {
        $('#shotsOutput').append(decoder.write(data))
        pinToBottom.scrollTop = pinToBottom.scrollHeight
    })

    shots.stderr.on('data', (data) => {
        $('#shotsOutput').append(decoder.write(data))
        pinToBottom.scrollTop = pinToBottom.scrollHeight
    })

    shots.on('close', (code) => {
        pinToBottom.scrollTop = pinToBottom.scrollHeight
        if (autoShotsState === false) {
            document.getElementById('syncShots').disabled = false            
        }
        document.getElementById('shotsMessages').innerHTML = `shots exit code: ${code.toString()}`
    })

    shots.on('exit', (data) => {
        let finish = getTime()
        document.getElementById('shotsState').innerHTML = `last sync at: ${finish}`
    })
}

function clearPage(ele) {
    document.getElementById(ele).innerHTML = ''
}

function getTime() {
    let hours = new Date().getHours()
    let minutes = new Date().getMinutes()
    let seconds = new Date().getSeconds()
    return `${hours}:${minutes}:${seconds}`
}

function scheduleAssets(source, destination, ...args) {
    if (autoAssetsState === false) {
        autoAssetsState = true        
        document.getElementById('assetsAutoState').innerHTML = 'Assets auto on'
        document.getElementById('autoAssets').innerText = 'Assets auto on'
        $('#autoAssets, #assetsAutoState').css('color', 'green')
        document.getElementById('syncAssets').disabled = true        
        
        cronAss = schedule.scheduleJob('0 5,20,35,50 * * * *', () => {
            isPanama(safetyFirst)
                .then(runAssets(source, destination, ...args))
                .catch((err) => {
                    console.log(err)
                })
        })

    } else {
        autoAssetsState = false
        cronAss.cancel()
        document.getElementById('autoAssets').innerText = 'Assets auto off'
        $('#autoAssets').css('color', 'black')
        $('#assetsAutoState').css('color', 'yellow')
        document.getElementById('syncAssets').disabled = false        
    }
}

function scheduleShots(source, destination, ...args) {
    if (autoShotsState === false) {
        autoShotsState = true
        document.getElementById('shotsAutoState').innerHTML = 'Shots auto on'
        document.getElementById('autoShots').innerText = 'Shots auto on'
        $('#autoShots, #shotsAutoState').css('color', 'green')
        document.getElementById('syncShots').disabled = true
        
        
        cronShots = schedule.scheduleJob('0 0,15,30,45 * * * *', () => {
            isPanama(safetyFirst)
                .then(runShots(source, destination, ...args))
                .catch((err) => {
                    console.log(err)
                })
        })

    } else {
        autoShotsState = false
        cronShots.cancel()
        document.getElementById('autoShots').innerText = 'Shots auto off' 
        document.getElementById('shotsAutoState').innerHTML = 'Shots auto off'               
        $('#autoShots').css('color', 'black')
        $('#shotsAutoState').css('color', 'yellow')
        document.getElementById('syncShots').disabled = false        
    }
}



