--[[--
request.process_forward()

This function causes a previous call of request.forward{...} to be in effect. It is called automatically when neccessary, and must not be called explicitly by any application.

--]]--

function request.process_forward()
  if request._forward then
    request._forward_processed = true
    trace.request{
      module = request.get_module(),
      view   = request.get_view()
    }
  end
end
