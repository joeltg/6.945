import './main.css'
import Editor from './editor'

import Renderer from './render'

var ws = new WebSocket('ws://localhost:1947')
var RENDERABLES_REGEX = /::begin-renderables::(.*)::end-renderables::/

ws.onmessage = e => {
    console.log(e.data)
    var match = RENDERABLES_REGEX.exec(e.data)
    if(match){
        console.log(match)
    }
}

var cm = Editor(document.querySelector('.codemirror-container'))

function evalcm(cm) {
    ws.send(cm.getValue())
}

cm.setOption('extraKeys', {
    "Tab": "indentMore",
    "Cmd-Enter": evalcm,
    "Ctrl-Enter": evalcm,
    "Shift-Enter": evalcm
});

ws.onopen = () => {
    ws.send('(load "prelude")')
}

// var circle = (x, y) => ({x, y, type:'circle', xmin:-Infinity, xmax:Infinity, ymin:-Infinity, ymax:Infinity})

// var renderer = new Renderer((id,x,y)=>renderer.render({[id]: circle(x,y)}))

// renderer.insertInto('.display')
// renderer.render({
//     a: {type:'circle', x:20, y:20, xmin:-Infinity, xmax:Infinity, ymin:-Infinity, ymax:Infinity}
// })