import './main.css'

import CodeMirror from 'codemirror'
import 'codemirror/lib/codemirror.css'
import 'codemirror/mode/scheme/scheme'
import 'codemirror/theme/monokai.css'
import './theme.css'

// import 'codemirror/codemirror.css'

CodeMirror(document.querySelector('.codemirror-container'), {
  value: "(+ 1 1)\n",
  mode:  "scheme",
  theme: 'monokai'
})