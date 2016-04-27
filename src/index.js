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


const cmoptions = {
    value: "(+ 1 1)\n",
    mode:  "scheme",
    theme: 'monokai',
    indentUnit: 4,
    indentWithTabs: false,
    keyMap: 'sublime',
    autoCloseBrackets: true,
    matchBrackets: true,
}


CodeMirror(document.querySelector('.codemirror-container'), cmoptions)