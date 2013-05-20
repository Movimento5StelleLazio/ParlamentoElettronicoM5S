--[[--
result =      -- encoded string
encode.html(
  str         -- original string
)

This function replaces the special characters '<', '>', '&' and '"' by their HTML entities '&lt;', '&rt;', '&amp;' and '&quot;'.

NOTE: ACCELERATED FUNCTION
Do not change unless also you also update webmcp_accelerator.c

--]]--

function encode.html(text)
  -- TODO: perhaps filter evil control characters?
  return (
    string.gsub(
      text, '[<>&"]',
      function(char)
        if char == '<' then
          return "&lt;"
        elseif char == '>' then
          return "&gt;"
        elseif char == '&' then
          return "&amp;"
        elseif char == '"' then
          return "&quot;"
        end
      end
    )
  )
end
