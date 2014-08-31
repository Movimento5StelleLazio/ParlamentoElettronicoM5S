slot.set_layout("blank")
local auditors = Member:new_selector():add_field('"member_data".residence_postcode'):join('"member_data"', nil, '"member".id="member_data".id')
                        :add_where('"member".auditor')
                        :exec()
local markers = '&markers=00143'
trace.debug("dim: "..tostring(#auditors))
if #auditors>0 then
        for i,auditor in ipairs(auditors) do
                markers = markers .. "&markers=" .. auditor.residence_postcode
        end
end

slot.put('<script language="javascript">window.location.href="http://maps.googleapis.com/maps/api/staticmap?center=Rome,IT&zoom=10&size=600x300'..markers..'"</script>')
