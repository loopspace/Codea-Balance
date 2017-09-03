Balance = class()

local FULCRUM = 0
local LEFTPAN = -1
local RIGHTPAN = 1

function Balance:init(p)
    self.pos = p
    self.bar = 5
    self.pan = 1
    self.angle = 0
    self.lpos = self.pos + vec2(-self.bar*26-10,52)
    self.rpos = self.pos + vec2(self.bar*26+10,52)
    self.lpan = {}
    self.rpan = {}
    self.top = self.pos.y+52
    self.weighings = 0
end

function Balance:draw()
    pushMatrix()
    pushStyle()
    translate(self.pos)
    stroke(0, 255, 223, 255)
    strokeWidth(20)

    sprite("Cargo Bot:Claw Arm",0,-26)
    sprite("Cargo Bot:Claw Base",0,-52)
    local d = vec2(26,0)
    pushMatrix()
    rotate(self.angle)
    if self.touched == FULCRUM then
        line(-self.bar*d,self.bar*d)
    end
    for k=-self.bar,self.bar do
        sprite("Cargo Bot:Claw Middle",k*d)
    end
    popMatrix()
    d = d:rotate(self.angle*math.pi/180)
    sprite("Cargo Bot:Claw Arm",-self.bar*d+vec2(-10,26))
    sprite("Cargo Bot:Claw Arm",self.bar*d+vec2(10,26))
    for i=-1,1,2 do
        pushMatrix()
        translate(i*self.bar*d+vec2(i*10,52))
        if self.touched == i then
            line(-self.pan*26,0,self.pan*26,0)
        end
        for k=-self.pan,self.pan do
            sprite("Cargo Bot:Claw Middle",k*26,0)
        end
        sprite("Cargo Bot:Claw Left",-self.pan*26-10,0)
        sprite("Cargo Bot:Claw Right",self.pan*26+10,0)
        popMatrix()
    end
    popStyle()
    popMatrix()
    for k,v in ipairs(self.lpan) do
        v.pos = self.pos -self.bar*d+vec2(-10,26) + vec2(0,k*v.size)
    end
    for k,v in ipairs(self.rpan) do
        v.pos = self.pos +self.bar*d+vec2(10,26) + vec2(0,k*v.size)
    end
    pushStyle()
    textMode(CORNER)
    fill(227, 189, 109, 255)
    text("Weighings: " .. self.weighings,20,20)
    popStyle()
end

function Balance:isTouchedBy(t)
    local tpt = vec2(t.x,t.y)
    if tpt:dist(self.pos) < 50 then
        if self.touched == FULCRUM then
            tween(1,self,{angle = 0})
            self.touched = nil
        else
            self.touched = FULCRUM
            self:weigh()
        end
        return true
    end
    if self.angle ~= 0 then
        return false
    end
    if tpt:dist(self.lpos) < 50 then
        self.touched = LEFTPAN
        return true
    end
    if tpt:dist(self.rpos) < 50 then
        self.touched = RIGHTPAN
        return true
    end
    return false
end

function Balance:processTouches(g)
    g:noted()
end

function Balance:panTouched()
    if self.touched == LEFTPAN then
        local lp = 0
        for k,v in ipairs(self.lpan) do
            lp = lp + v.size 
        end
        return self.lpos + vec2(0,lp)
    end
    if self.touched == RIGHTPAN then
        local lp = 0
        for k,v in ipairs(self.rpan) do
            lp = lp + v.size 
        end
        return self.rpos + vec2(0,lp)
    end
    return false
end

function Balance:addToPan(b)
    if self.touched == LEFTPAN then
        table.insert(self.lpan,b)
    end
    if self.touched == RIGHTPAN then
        table.insert(self.rpan,b)
    end
    self.touched = nil
end

function Balance:weigh()
    self.weighings = self.weighings + 1
    local lw,rw = 0,0
    for k,v in ipairs(self.lpan) do
        lw = lw + v.weight 
    end
    for k,v in ipairs(self.rpan) do
        rw = rw + v.weight 
    end
    if lw > rw then
        tween(1,self,{angle = 10},tween.easing.quad,function() self:empty() end)
        return
    end
    if lw < rw then
        tween(1,self,{angle = -10},tween.easing.quad,function() self:empty() end)
        return
    end
end

function Balance:empty()
    for k,v in ipairs(self.lpan) do
        tween(1,v,{pos = v.pos + vec2(0,50)})
    end
    for k,v in ipairs(self.rpan) do
        tween(1,v,{pos = v.pos + vec2(0,50)})
    end
    self.lpan = {}
    self.rpan = {}
end
