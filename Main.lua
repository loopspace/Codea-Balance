-- In the Balance

function setup()
    supportedOrientations(LANDSCAPE_ANY)
    displayMode(FULLSCREEN)
    cmodule "In the Balance"
    cmodule.path("Base", "Maths", "Graphics", "Utilities", "UI")
    cimport "VecExt"
    cimport "MathsUtilities"
    touches = cimport "Touch"()
    ui = cimport "UI"(touches)
    blocks = {}
    balance = Balance(vec2(WIDTH/2,HEIGHT/4))
    touches:pushHandler(balance)    
    local b
    local n = 13
    local p = KnuthShuffle(n,true)
    for k=1,n do
        b = Block(vec2(50+p[k]*60,3*HEIGHT/4),balance)
        table.insert(blocks,b)
        touches:pushHandler(b)
    end
    p = KnuthShuffle(#blocks,true)
    for k,v in ipairs(blocks) do
        v.weight = p[k]
    end
    table.sort(blocks, function(a,b) return a.weight < b.weight end)
    local fn = function()
        for k=2,#blocks do
            if blocks[k].pos.x >= blocks[k-1].pos.x then
                message = "Not in order"
                tween.delay(2,function() message = "" end)
                return
            end
        end
        message = "Congratulations!"
        tween.delay(2,function() message = "" end)
    end
    btn = Button(vec2(50,3*HEIGHT/4),"Cargo Bot:Command Right", fn)
    touches:pushHandler(btn)
    message = ""
end

function draw()
    touches:draw()
    background(40, 40, 50)
    btn:draw()
    for k,v in ipairs(blocks) do
        v:draw()
    end
    balance:draw()
    pushStyle()
    textMode(CORNER)
    fill(227, 189, 109, 255)
    local w,h = textSize(message)
    text(message,WIDTH - w - 20,20)
    popStyle()
    ui:draw()
end

function touched(t)
    touches:addTouch(t)
end

