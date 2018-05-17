const watchr = require('watchr'),
    fs = require('fs'),
    path = require('path'),
    os = require('os'),
    net = require('net'),
    EventEmitter = require('events');


const schedule = require('node-schedule')
    
class myEmitter extends EventEmitter {}
const fileSystemEvents = new myEmitter()
exports.pubsub = fileSystemEvents
EventEmitter.defaultMaxListeners = 100000

var stalker = undefined
var sourceDirs = []
var watchPaths = []
var myStates = {}


var dailySync = schedule.scheduleJob('0 0 23 * * *', () => {
  fileSystemEvents.emit('daily sync')  
})


exports.fsActions = (pathSelection, action) => {

    function listener(changeType, fullPath, currentStat, previousStat) {
        fileSystemEvents.emit('stalker', {
            changeType,
            fullPath
        })
        fileSystemEvents.emit('runSync')
    }

    function next(error) {
        if (!error) {
            fileSystemEvents.emit('watcher', stalker.watcher)
        }
    }

    if (action === 'init') {
        stalker = watchr.open(pathSelection, listener, next)
    }

    if (action === 'close') {
        if (stalker !== undefined) {
            stalker.close()
            stalker = undefined
            fileSystemEvents.emit('stalker closed')
        }
    
    }
}


fileSystemEvents.on('runSync', () => {

})

