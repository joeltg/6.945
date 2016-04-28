import hu from '../lib/hu'
import {makeDraggable, clamp} from '../utils'

class element {
    render(renderable, renderables){
        this.el.attr(renderable.attributes)
        this.renderEl(renderable, renderables)
    }
}

class draggable extends element{

    constructor(id, ctx, desire){
        super()
        this.createEl(ctx)
        this.el.id = id
        makeDraggable(
            this.el,
            this.startPos.bind(this),
            (x, y) => desire(id, x, y)
        )
    }
}

export class circle extends draggable {

    createEl(ctx){
        this.el = hu('<circle>', ctx).attr({r:5, fill:'#000'})
    }

    startPos(){
        return [Number(this.el.attr('cx')), Number(this.el.attr('cy'))]
    }

    renderEl(c){
        this.el.attr({
            cx:clamp(c.x, c.xmin, c.xmax),
            cy:clamp(c.y, c.ymin, c.ymax)
        })
    }
}

export class line extends element {

    constructor(id, ctx){
        super()
        this.el = hu('<line>', ctx).attr({stroke: '#000'})
        this.el.id = id
    }

    renderEl(c, renderables) {

        var d1 = renderables[c.d1]
        var d2 = renderables[c.d2]

        this.el.attr({
            x1:clamp(d1.x, d1.xmin, d1.xmax),
            y1:clamp(d1.y, d1.ymin, d1.ymax),
            x2:clamp(d2.x, d2.xmin, d2.xmax),
            y2:clamp(d2.y, d2.ymin, d2.ymax),
        })
    }
}

export class text extends draggable {

    createEl(ctx){
        this.el = hu('<text>', ctx)
    }

    startPos(){
        return [Number(this.el.attr('x')),Number(this.el.attr('y'))]
    }

    renderEl(c) {
        this.el.attr({
            x:clamp(c.x, c.xmin, c.xmax),
            y:clamp(c.y, c.ymin, c.ymax),
        }).text(c.text)
    }
}

export class image extends draggable {
    createEl(ctx){
        this.el = hu('<image>', ctx)
    }

    startPos(){
        return [Number(this.el.attr('x')),Number(this.el.attr('y'))]
    }

    renderEl(c) {
        this.el.n.setAttributeNS("http://www.w3.org/1999/xlink",'href', c.href)

        this.el.attr({
            x:clamp(c.x, c.xmin, c.xmax),
            y:clamp(c.y, c.ymin, c.ymax),
            width:c.width,
            height:c.height,
        })
    }
}