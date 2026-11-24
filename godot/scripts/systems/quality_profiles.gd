extends Node
## Runtime graphics presets. Keep expensive screen-space features disabled on the minimum target.
enum Profile { LOW, BALANCED, HIGH }
var current_profile: Profile = Profile.LOW

func _ready() -> void:
	apply_profile(Profile.LOW)

func apply_profile(profile: Profile) -> void:
	current_profile = profile
	# A stable 30 FPS cap is more appropriate for the Celeron / UHD 610 minimum target.
	Engine.max_fps = 30 if profile != Profile.HIGH else 45
	ProjectSettings.set_setting("rendering/lights_and_shadows/use_shadow_atlas", false)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 0)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/screen_space_aa", 0)
	ProjectSettings.set_setting("rendering/environment/ssao/quality", 0)
	ProjectSettings.set_setting("rendering/environment/screen_space_reflections/roughness_limiter_enabled", false)
	match profile:
		Profile.LOW:
			ProjectSettings.set_setting("rendering/scaling_3d/scale", 0.70)
		Profile.BALANCED:
			ProjectSettings.set_setting("rendering/scaling_3d/scale", 0.85)
		Profile.HIGH:
			ProjectSettings.set_setting("rendering/scaling_3d/scale", 0.95)
