Block = class()

local crates = {
    "Documents:Title Large Crate 1",
    "Documents:Title Large Crate 2",
    "Documents:Title Large Crate 3"
}

local tints = {
    color(255,0,0,255),
    color(255,255,0,255),
    color(0,255,0,255),
    color(0,255,255,255),
    color(0,0,255,255),
    color(255,0,255,255)
}

local ncycle = 0


function Block:init(p,b)
    self.pos = p
    self.size = 50
    self.sprite = crates[ncycle%3+1]
    self.tint = tints[(ncycle+math.floor(ncycle/6))%6+1]
    ncycle = ncycle + 1
    self.weight = 1
    self.balance = b
end

function Block:draw()
    pushStyle()
    tint(self.tint)
    sprite(self.sprite,self.pos,self.size)
    popStyle()
end

function Block:isTouchedBy(t)
    local tpt = vec2(t.x,t.y) - self.pos
    local x = math.abs(tpt.x)*2
    local y = math.abs(tpt.y)*2
    if x < self.size and y < self.size then
        if self.balance:panTouched() then
            tween(1,self,{pos = self.balance:panTouched()+vec2(0,self.size/2)},tween.easing.quad,function()
            self.balance:addToPan(self) end)
        else
            self.tpt = tpt
        end
        return true
    end
    return false
end

function Block:processTouches(g)
    if self.tpt then
        local t = g.touchesArr[1].touch
        local tpt = vec2(t.x,t.y)
        self.pos = tpt - self.tpt
        if self.pos.y < 20 + self.size/2 then
            self.pos.y = 20 + self.size/2
        end
    end
    g:noted()
    if g.type.ended then
        self.tpt = nil
        g:reset()
    end
end
