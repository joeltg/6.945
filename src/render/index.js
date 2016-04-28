import hu from '../lib/hu'
import * as elementCreators from './elements'

export default class Renderer {
    
    elements = {};
    ctx = hu('<svg>');

    constructor(desire){
        this.desire = desire
    }

    render(renderables){
        var {elements, desire, ctx} = this
        _.forIn(renderables, (renderable, id) => {

            if(!elements[id]){
                elements[id] = new elementCreators[renderable.type](id, ctx, desire)
            }

            elements[id].render(renderable, renderables)
        })

        _.forIn(elements, (element, id) => {
            if(!(id in renderables)){
                element.el.remove()
                delete elements[id]
            }
        })
    }

    insertInto(selector){
        hu(this.ctx, selector)
    }
}