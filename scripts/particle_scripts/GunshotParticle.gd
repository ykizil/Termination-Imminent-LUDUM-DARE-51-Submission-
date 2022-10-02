extends Particles2D

onready var tracer = $Tracer

func _ready():
	one_shot = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tracer.modulate.a *= 0.8

func set_tracer_start_point(pos):
	tracer.points[0] = pos - global_position
