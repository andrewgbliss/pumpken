extends Node

signal player_spawned(player)
signal audio_volume_changed(bus_idx: int, volume: float)
signal zoom_level_changed(zoom_level: float)
signal world_changed(to_room_id: String, from_room_id: String, scene_path: String, scene_transition_name: String)
