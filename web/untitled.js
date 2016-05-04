import 'lodash'
import numeric from 'numeric'
import {Data2Renderables} from './populators'
import Renderer from './renderers/abstract'

global.g9 = function g9(initialData, populateRenderables, onChange) {

    var curData = initialData
    var renderables
    var data2renderables = Data2Renderables(populateRenderables)

    function desire(id, x, y){

        var renderable = renderables[id]

        var keys = _.keys(curData)
        var vals = keys.map(k => curData[k])

        var optvals = numeric.uncmin( v => {
            var tmpdata = _.clone(curData)
            
            keys.forEach( (k, i) => {
                tmpdata[k] = v[i]
            })

            var points = data2renderables(tmpdata)
            var c1 = points[id]

            var dx = c1.x - x
            var dy = c1.y - y
            var d = dx*dx + dy*dy

            return d

        }, vals).solution

        keys.forEach(function(k, i){
            curData[k] = optvals[i]
        })

        render()
    }


    function render(){
        renderables = data2renderables(curData)
        onChange(curData, renderables)
    }

    render()

    return desire
}