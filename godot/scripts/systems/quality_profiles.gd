extends Node
## Runtime presets designed around scalable assets, not forced visual downgrades.
enum Profile { LOW, BALANCED, HIGH }
var current_profile: Profile = Profile.LOW

func apply_profile(profile: Profile) -> void:
	current_profile = profile
	Engine.max_fps = 30 if profile == Profile.LOW else 45 if profile == Profile.BALANCED else 60
	ProjectSettings.set_setting("rendering/lights_and_shadows/use_shadow_atlas", profile != Profile.LOW)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 0 if profile == Profile.LOW else 2)
	ProjectSettings.set_setting("rendering/environment/ssao/quality", 0 if profile == Profile.LOW else 1)
