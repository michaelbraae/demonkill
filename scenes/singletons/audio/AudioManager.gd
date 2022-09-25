extends Node2D

enum {
	UI_ACCEPT
	HEARTBEAT,
}

onready var ui_accept = $UIAudio/AcceptAudioStreamPlayer
onready var heartbeat = $AtmosphereAudio/HeartbeatAudioStreamPlayer

func play_audio(audio: int) -> void:
	match audio:
		UI_ACCEPT:
			ui_accept.playing = true
		HEARTBEAT:
			heartbeat.playing = true

func stop_audio(audio: int) -> void:
	match audio:
		UI_ACCEPT:
			ui_accept.playing = false
		HEARTBEAT:
			heartbeat.playing = false
