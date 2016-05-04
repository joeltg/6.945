import parse from 's-expression'

import './main.css'
import Editor from './editor'

import Renderer from './render'

var ws = new WebSocket('ws://localhost:1947')

var cm = Editor(document.querySelector('.codemirror-container'))

function evalcm(cm) {
    var val = cm.getValue()
    ws.send(val)
}

cm.setOption('extraKeys', {
    "Tab": "indentMore",
    "Cmd-Enter": evalcm,
    "Ctrl-Enter": evalcm,
    "Shift-Enter": evalcm
});

ws.onopen = () => {
    ws.send(require('./scm/prelude.scm'))
}

var circle = (x, y) => ({x, y, type:'circle', xmin:-Infinity, xmax:Infinity, ymin:-Infinity, ymax:Infinity})

var responded = true
var nextdesire = false
function desire(id,x,y){
    if(responded){
        responded = false
        ws.send(`(global-desire '(${id} ((x ${x}) (y ${y}))))`);
    } else {
        nextdesire = {id, x, y}
    }
}
var renderer = new Renderer(desire)

renderer.insertInto('.display')

var RENDERABLES_REGEX = /::begin-renderables::(.*)::end-renderables::/

function parse_s_exp(sexp){
    var parsed = parse(sexp)
    var ret = {}
    parsed.forEach(renderable =>{
        var [id, attrs] = renderable
        var obj = {id, xmin:-Infinity, xmax:Infinity, ymin:-Infinity, ymax:Infinity}
        attrs.forEach(attr =>{
            var [key, val] = attr
            obj[key] = val
        })
        ret[id] = obj
    })
    return ret
}

var log = document.querySelector('.console')

var shouldlog = true

log.addEventListener('click', function(){
    shouldlog = !shouldlog
})

var buffer = ''
ws.onmessage = e => {
    buffer+=e.data

    if(shouldlog){
        log.innerHTML = buffer
        var containerHeight = log.clientHeight;
        var contentHeight = log.scrollHeight;
        log.scrollTop = contentHeight - containerHeight;    
    }

    var match = RENDERABLES_REGEX.exec(buffer)
    if(match){
        responded = true
        
        if(nextdesire){
            var {id, x, y} = nextdesire
            nextdesire = false

            desire(id, x, y)
        }

        renderer.render(parse_s_exp(match[1]))
        buffer = buffer.slice(match.index + match[0].length)
    }
}