extends CharacterBody2D

# Tốc độ ném quả cầu
const THROW_SPEED = 1000.0

# Lấy giá trị trọng lực từ cài đặt của dự án
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Một biến để chứa scene của quả cầu dịch chuyển.
# @export cho phép chúng ta kéo-thả scene vào từ editor.
@export var teleporter_ball_scene: PackedScene

# Biến để theo dõi quả cầu đang được ném, ngăn người chơi ném nhiều quả cùng lúc.
var current_ball = null

func _physics_process(delta):
	# Luôn luôn áp dụng trọng lực
	if not is_on_floor():
		velocity.y += gravity * delta

	# Áp dụng chuyển động và xử lý va chạm với môi trường
	move_and_slide()

func _unhandled_input(event):
	# Kiểm tra nếu người chơi nhấn nút "teleport" và chưa có quả cầu nào đang bay
	if event.is_action_pressed("teleport") and current_ball == null:
		throw_ball()

func throw_ball():
	# Kiểm tra xem scene quả cầu đã được gán chưa
	if not teleporter_ball_scene:
		print("LỖI: Bạn chưa gán Teleporter Ball Scene vào Player trong Inspector!")
		return

	# 1. Tạo một thực thể (instance) của quả cầu
	var ball = teleporter_ball_scene.instantiate()

	# 2. Kết nối signal 'hit_surface' của quả cầu với một hàm trong Player
	ball.hit_surface.connect(_on_ball_hit_surface)

	# 3. Theo dõi quả cầu này
	current_ball = ball

	# 4. Thêm quả cầu vào cây scene chính để nó tồn tại trong thế giới game
	get_tree().root.add_child(ball)
	
	# 5. Đặt vị trí ban đầu và bắn nó đi
	ball.global_position = self.global_position
	var throw_direction = (get_global_mouse_position() - self.global_position).normalized()
	ball.launch(throw_direction, THROW_SPEED)

# Hàm này sẽ được gọi khi quả cầu phát ra signal "hit_surface"
func _on_ball_hit_surface(teleport_location):
	print("Dịch chuyển")
	
	# Dịch chuyển Player đến vị trí va chạm
	self.global_position = teleport_location
	
	# Reset vận tốc để Player không giữ vận tốc rơi từ trước khi dịch chuyển
	self.velocity = Vector2.ZERO
	
	# Cho phép ném quả cầu mới
	current_ball = null
