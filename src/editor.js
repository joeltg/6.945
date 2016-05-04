import 'lodash'

import CodeMirror from 'codemirror'
import 'codemirror/lib/codemirror.css'
import 'codemirror/theme/monokai.css'
import './theme.css'

import 'codemirror/mode/scheme/scheme'

import 'codemirror/keymap/sublime'

import 'codemirror/addon/edit/closebrackets'
import 'codemirror/addon/edit/matchbrackets'
import 'codemirror/addon/comment/comment'

const initialVal = require('./scm/defaultProgram.scm')

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


export default function Editor(element){
  return CodeMirror(element, cmoptions)
}