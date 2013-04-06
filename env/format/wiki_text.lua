function format.wiki_text(wiki_text, formatting_engine)
  local formatting_engine = formatting_engine or "rocketwiki"
  local html, errmsg, exitcode = assert(
    extos.pfilter(wiki_text, config.formatting_engine_executeables[formatting_engine])
  )
  if exitcode > 0 then
    error("Wiki parser process returned with error code " .. tostring(exitcode))
  elseif exitcode < 0 then
    error("Wiki parser process was terminated by signal " .. tostring(-exitcode))
  end
  return html
end
