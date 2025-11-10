extends Node2D

# Node references
@onready var canvas_layer = $CanvasLayer

# Variables to manage drawing
var is_drawing: bool = false
var current_line: Line2D = null
var lines = []

# Called when the node enters the scene tree for the first time
func _ready():
	pass  # Start your game or setup logic here

# Input handling for drawing
func _input(event: InputEvent):
	if event is InputEventScreenTouch:
		if event.pressed and not is_drawing:
			# Start drawing a new line
			is_drawing = true
			current_line = Line2D.new()
			current_line.width = 5
			current_line.default_color = Color(1, 0, 0)  # Line color (red)
			current_line.add_point(event.position)  # Add the first point
			canvas_layer.add_child(current_line)  # Add the line to the canvas layer
			lines.append(current_line)  # Keep track of all lines
		elif not event.pressed and is_drawing:
			# Stop drawing when the touch is released
			is_drawing = false
	elif event is InputEventScreenDrag and is_drawing:
		# Add new points as the user drags
		current_line.add_point(event.position)

# Function to clear all the lines drawn
func clear_drawing():
	for line in lines:
		line.queue_free()
	lines.clear()
