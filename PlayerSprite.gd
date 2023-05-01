extends Sprite2D

var task_list = []
const MOVE_SPEED = 100

# Called when the node enters the scene tree for the first time.
func _ready():
    self.add_to_group("players")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if task_list.size() > 0:
        var current_task = task_list[0]
        if current_task.type == "move":
            var waypoint = current_task.position
            # Calculate the direction and distance to the waypoint
            var direction = (waypoint - position).normalized()
            var distance = (waypoint - position).length()

            # Move the PlayerSprite towards the waypoint
            if distance > 0:
                var move_amount = min(distance, MOVE_SPEED * delta)
                position += direction * move_amount
            else:
                task_list.pop_front()

func add_to_task_list(task):
    task_list.append(task)

func get_task_list():
    return task_list
