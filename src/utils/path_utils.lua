local PathUtils = {}

PathUtils.sep = (package.config:sub(1, 1) == "\\") and "\\" or "/"

function PathUtils.normalize(path)
  if not path then return "" end
  if PathUtils.sep == "\\" then
    return path:gsub("/", "\\")
  else
    return path:gsub("\\", "/")
  end
end

function PathUtils.getFileName(path)
  local norm = PathUtils.normalize(path)
  return norm:match("^.*[" .. PathUtils.sep .. "]([^" .. PathUtils.sep .. "]+)$") or norm
end

return PathUtils
