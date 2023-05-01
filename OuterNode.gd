extends Node2D

var drag_start = Vector2.ZERO
var drag_end = Vector2.ZERO
var pressed = null
var selected_objects = []

# Called when the node enters the scene tree for the first time.
func _ready():
    set_process_input(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == 2 and event.pressed:
            for obj in selected_objects:
                var task = Player_Task.new()
                task.type = "move"
                task.position = event.position
                obj.call("add_to_task_list",task)
                updateLabel()
        if event.button_index == 1 and event.pressed:
#            selection.remove_selected_object(self)
            drag_start = event.position
            pressed = true
        if event.button_index == 1 and  not event.pressed:
            drag_end = event.position
            pressed = false
            selected_objects = find_objects_in_rect(Rect2(drag_start, drag_end-drag_start))
            updateLabel()
            highlight(selected_objects)
            drag_start = Vector2.ZERO
            drag_end = Vector2.ZERO
            queue_redraw()
    elif event is InputEventMouseMotion and pressed == true:
        drag_end = event.position
        queue_redraw()
        
func _draw():
    draw_rect(Rect2(drag_start, drag_end - drag_start), Color(1, 1, 1, 0.5))

func updateLabel():
    var text = "Selected objects:\n"
    for object in selected_objects:
        text += object.name + "\n"
        for task in object.call("get_task_list"):
            text += "    " + str(task.position) + "\n"
    get_node("Label").text = text

func highlight(selected_objects):
    var no_highlight_texture = load("res://textures/red_square.png")
    for node in get_tree().get_nodes_in_group("players"):
        node.texture = no_highlight_texture 
    var highlight_texture = load("res://textures/red_square_highlighted.png")
    for obj in selected_objects:
        obj.texture = highlight_texture

func is_between(pos, pos1, pos2):
    return min(pos1.x, pos2.x) <= pos.x and pos.x <= max(pos1.x, pos2.x) and \
           min(pos1.y, pos2.y) <= pos.y and pos.y <= max(pos1.y, pos2.y)

func find_objects_in_rect(rect: Rect2) -> Array:
    var objects = []
    for node in get_tree().get_nodes_in_group("players"):
        if(is_between(node.position, rect.position, rect.end)):
            objects.append(node) 
    return objects
