local policy = Policy:by_id(param.get_id()) or Policy:new()

param.update(
  policy, 
  "index", "name", "description", "active", 
  "admission_time", "discussion_time", "verification_time", "voting_time", 
  "issue_quorum_num", "issue_quorum_den", 
  "initiative_quorum_num", "initiative_quorum_den", 
  "direct_majority_num", "direct_majority_den", "direct_majority_strict", "direct_majority_positive", "direct_majority_non_negative",
  "indirect_majority_num", "indirect_majority_den", "indirect_majority_strict", "indirect_majority_positive", "indirect_majority_non_negative",
  "no_reverse_beat_path", "no_multistage_majority", "polling"
)

if policy.admission_time == "" then policy.admission_time = nil end
if policy.discussion_time == "" then policy.discussion_time = nil end
if policy.verification_time == "" then policy.verification_time = nil end
if policy.voting_time == "" then policy.voting_time = nil end

policy:save()
