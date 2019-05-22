var bench = require('./bench.js');
var Elm = bench.Elm.Console.init();

Elm.ports.progress.subscribe(function(msg) {
    console.log(msg);
});
