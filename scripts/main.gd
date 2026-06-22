class_name ShelterMain
extends Control


func _ready() -> void:
    var project_name := str(ProjectSettings.get_setting("application/config/name", "Shelter"))
    get_window().title = project_name
