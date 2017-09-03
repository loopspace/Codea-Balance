Button = class()

function Button:init(p,i,f)
    self.pos = p
    self.img = i
    self.invoke = f
end

function Button:draw()
    sprite(self.img,self.pos)
end

function Button:isTouchedBy(t)
    local tpt = vec2(t.x,t.y) - self.pos
    local w,h = spriteSize(self.img)
    local x = math.abs(tpt.x)*2
    local y = math.abs(tpt.y)*2
    if x < w and y < h then
        self:invoke()
        return true
    end
end

function Button:processTouches(g)
    g:noted()
end
