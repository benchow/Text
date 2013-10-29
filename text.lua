local Text = {}
--[[------------------------------------------------------------
-- Text.draw
----------------------------------------------------------------
-- returns a proxy object that allows you to change text
OPTIONS:
text            => text to draw
font            => font name
fontSize 
shadow          => boolean turns on/off dropshadow (default true)
stroke          => boolean turns on/off stroke this default false
color           => {r,g,b,alpha}
stroke_color    => {r,g,b,alpha}
shadow_color    => {r,g,b,alpha}
group           => parent display group
x,y
stroke_width
shadow_offset
width
height
--------------------------------------------------------------]]
function Text.draw(t)
  local obj,mt={},{} -- metatable
  local options = {}
  local text
  local is_shadow = true
  local is_stroke = false
  local parent = t.group or display.currentStage  --!IMPORTANT: may want a better default than scene.foreground
  local x,y = t.x or 0,t.y or 0
  local rotate = t.rotate or 0
  local color = t.color or {255,255,240,255}
  local ref = t.ref or display.CenterReferencePoint
  if t.shadow ~= nil then is_shadow = t.shadow end
  if t.stroke ~= nil then is_stroke = t.stroke end
  options.text, options.font,options.fontSize,options.align,options.parent = t.text or '', t.font or 'AllerDisplay',t.fontSize or '14', t.align or 'center', parent
  options.width,options.height = t.width or nil, t.height or nil
  options.x,options.y = 0,0
  
  if is_stroke or is_shadow then
    options.parent = display.newGroup()
    parent:insert(options.parent)
    obj.g = options.parent
    obj.group = {}
  end

  if is_stroke then
    local stroke_options = table.copy(options)
    local stroke_color = t.stroke_color or t.shadow_color or {0,0,0,100}
    local offset = t.stroke_width or 1
    stroke_options.x,stroke_options.y = options.x + offset, options.y + offset
    text = display.newText(stroke_options)
    text.x = stroke_options.x
    text.y = stroke_options.y
    text:setReferencePoint(ref)
    text:setTextColor(unpack(stroke_color))
    text:rotate(rotate)   
    table.insert(obj.group,text)

    stroke_options.x,stroke_options.y = options.x - offset, options.y - offset
    text = display.newText(stroke_options)
    text.x = stroke_options.x
    text.y = stroke_options.y
    text:setReferencePoint(ref)
    text:setTextColor(unpack(stroke_color))
    text:rotate(rotate)   
    table.insert(obj.group,text)
    
    stroke_options.x,stroke_options.y = options.x + offset, options.y - offset
    text = display.newText(stroke_options)
    text.x = stroke_options.x
    text.y = stroke_options.y
    text:setReferencePoint(ref)
    text:setTextColor(unpack(stroke_color))
    text:rotate(rotate)   
    table.insert(obj.group,text)

    stroke_options.x,stroke_options.y = options.x - offset, options.y + offset
    text = display.newText(stroke_options)
    text.x = stroke_options.x
    text.y = stroke_options.y
    text:setReferencePoint(ref)
    text:setTextColor(unpack(stroke_color))
    text:rotate(rotate)   
    table.insert(obj.group,text)

    stroke_options.x,stroke_options.y = options.x, options.y + offset
    text = display.newText(stroke_options)
    text.x = stroke_options.x
    text.y = stroke_options.y
    text:setReferencePoint(ref)
    text:setTextColor(unpack(stroke_color))
    text:rotate(rotate)   
    table.insert(obj.group,text)

    stroke_options.x,stroke_options.y = options.x, options.y - offset
    text = display.newText(stroke_options)
    text.x = stroke_options.x
    text.y = stroke_options.y
    text:setReferencePoint(ref)
    text:setTextColor(unpack(stroke_color))
    text:rotate(rotate)   
    table.insert(obj.group,text)

    stroke_options.x,stroke_options.y = options.x - offset, options.y 
    text = display.newText(stroke_options)
    text.x = stroke_options.x
    text.y = stroke_options.y
    text:setReferencePoint(ref)
    text:setTextColor(unpack(stroke_color))
    text:rotate(rotate)   
    table.insert(obj.group,text)

    stroke_options.x,stroke_options.y = options.x + offset, options.y 
    text = display.newText(stroke_options)
    text.x = stroke_options.x
    text.y = stroke_options.y
    text:setReferencePoint(ref)
    text:setTextColor(unpack(stroke_color))
    text:rotate(rotate)   
    table.insert(obj.group,text)
  end
  if is_shadow then
    local shadow_options = table.copy(options)
    local shadow_color = t.shadow_color or t.stroke_color or {0,0,0,100}
    local offset = t.shadow_offset or 2
    shadow_options.x,shadow_options.y = shadow_options.x + offset, shadow_options.y + offset
    shadow_options.fontSize = t.shadow_size or options.fontSize
    text = display.newText(shadow_options)
    text.x = shadow_options.x
    text.y = shadow_options.y
    text:setReferencePoint(ref)
    text:setTextColor(unpack(shadow_color))
    text:rotate(rotate)   
    table.insert(obj.group,text)
  end

  if is_stroke or is_shadow then
    options.x, options.y = 0,0
    text = display.newText(options)
    text:setReferencePoint(ref)
    text:setTextColor(unpack(color))
    text:rotate(rotate)
    obj.group.text = text
    obj.g:setReferencePoint(ref)
    obj.g.x, obj.g.y = x,y
    mt.__index=function(t,k)
      local obj = t.g
      local v = obj[k]
      if type(v) == 'function' then
        return function(self,...)
          return v(obj,...)
        end
      elseif v == nil and t.group[k] ~= nil and t.group[k][k] ~= nil then
        return t.group[k][k]  -- !HACK !FIXME:  this is really for the use case where there is no text key for group so we pass it on to obj text.text
      else
        return v
      end
    end
    mt.__newindex=function(t,k,v)
      local obj = t.g
      if obj[k] ~= nil then 
        obj[k] = v
      else
        for key,val in pairs(t.group) do if val[k] ~= nil then val[k] = v end end
      end
    end
    setmetatable(obj,mt)
    text = obj
  else
    options.x, options.y = x,y
    text = display.newText(options)
    text.x = options.x
    text.y = options.y
    text:setReferencePoint(ref)
    text:setTextColor(unpack(color))
    text:rotate(rotate)
  end
  return text
end

return Text