local Layout = {}

function Layout.getDimensions()
  return love.graphics.getWidth(), love.graphics.getHeight()
end

function Layout.rel(xPercent, yPercent)
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()
  return w * xPercent, h * yPercent
end

return Layout
