import './main.css'

import CodeMirror from 'codemirror'
import 'codemirror/lib/codemirror.css'
import 'codemirror/theme/monokai.css'
import './theme.css'

import 'codemirror/mode/scheme/scheme'

import 'codemirror/keymap/sublime'

import 'codemirror/addon/edit/closebrackets'
import 'codemirror/addon/edit/matchbrackets'

import 'codemirror/addon/comment/comment'

import test from './test.scm';
EVAL(test)

const initialVal = `(define demo (g9
    (('a 7) ('b 8) ('c 1))
    (lambda (a b c draw)
        (draw 'circle a (+ b a) 'circle1)
        (draw 'circle (+ a c) (+ c b) 'circle2))
    (lambda (renderables desire)
        (map (jsrender desire) renderables))))`

const cmoptions = {
    value: initialVal,
    mode:  "scheme",
    theme: 'monokai',
    indentUnit: 4,
    indentWithTabs: false,
    keyMap: 'sublime',
    autoCloseBrackets: true,
    matchBrackets: true,
}

function evalcm(cm) {
  var res = EVAL(cm.getValue())
  console.log(res)
  document.querySelector('.display').innerText = res
}

var cm = CodeMirror(document.querySelector('.codemirror-container'), cmoptions)

cm.setOption('extraKeys', {
    "Tab": "indentMore",
    "Cmd-Enter": evalcm,
    "Ctrl-Enter": evalcm
});