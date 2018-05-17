const watchr = require('watchr'),
    fs = require('fs'),
    path = require('path'),
    os = require('os');

var stalker
var watchDir



module.exports = {
    setup: (srcDir, cb) => {
        watchDir = srcDir
        return new Promise((resolve, reject) => {
            if (srcDir) {
                resolve(watchDir)
            } else {
                resolve('error')
            }
        });
    },
    watch: (action, cb) => {
        
        function listener(changeType, fullPath, currentStat, previousStat) {
            console.log('listener');
            cb({ changeType, fullPath })
        }

        function next(error) {
            if (!error) {
                cb(stalker.watcher);
            } else {
                cb(error)
            }
        }

        function stopRunning() {
            stalker.close()
        }

        if (action === 'stop') {              
            console.log('action stop');
            stopRunning()
            cb({ action: 'stop'})
        }


        stalker = watchr.create(watchDir)                
        stalker.watch(next)
        stalker.on('change', listener)
        stalker.on('log', console.log)
        
        // setTimeout(() => {
        //     stalker.close()
        // }, 20000)
         
    }
}


// function 
//         function next(err, cb) {
//             if (err) {
//                 return err
//             }
//             console.log(`watching ${srcDir}`);
//         }
//         var stalker = watchr.open(srcDir, listener, next)