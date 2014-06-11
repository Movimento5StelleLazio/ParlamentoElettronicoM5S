--[[--
for
  index,          -- index variable counting up from 1
  prefix          -- prefix string with index in square brackets to be used as a prefix for a key passed to param.get or param.get_list
in
  param.iterate(
    prefix        -- prefix to be followed by an index in square brackets and another key
  )
do
  ...
end

This function returns an interator function to be used in a for loop. The CGI GET/POST parameter (or internal parameter) with the name "prefix[len]" is read, where 'prefix' is the prefix passed as the argument and 'len' ist just the literal string "len". For each index from 1 to the read length the returned iterator function returns the index and a string consisting of the given prefix followed by the index in square brackets to be used as a prefix for keys passed to param.get(...) or param.get_list(...).

--]]--

function param.iterate(prefix)
  local length = param.get(prefix .. "[len]", atom.integer) or 0
  if not atom.is_integer(length) then
    error("List length is not a valid integer or nil.")
  end
  local index = 0
  return function()
    index = index + 1
    if index <= length then
      return index, prefix .. "[" .. index .. "]"
    end
  end
end
