local initiative = Initiative:by_id(param.get("initiative_id"))
local video_url = param.get("link", atom.string)

local initiator = Initiator:by_pk(initiative.id, app.session.member.id)
if not initiator or not initiator.accepted then
    slot.put_into("error", _"You must be an initiatior to update the video url.")
else
		local resource = Resource:all_resources_by_type(initiative.id, "video")
		resource.url = video_url
		resource:save()
		slot.put_into("notice", _"Video url changed")
end
