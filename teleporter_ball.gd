extends RigidBody2D

# Signal này sẽ được phát ra khi quả cầu chạm vào thứ gì đó.
# Nó sẽ mang theo thông tin về vị trí va chạm.
signal hit_surface(teleport_location)

# Hàm này sẽ được gọi từ Player để "bắn" quả cầu đi.
func launch(direction, speed):
	# Đặt vận tốc ban đầu cho quả cầu
	self.linear_velocity = direction * speed
	# Ngăn không cho nó xoay tròn lung tung
	self.angular_velocity = 0

# Godot sẽ tự động gọi hàm này khi RigidBody2D va chạm với một body khác.
func _on_body_entered(_body):
	print("vào hàm va chạm")
	# Khi va chạm, phát ra signal "hit_surface" cùng với vị trí hiện tại của quả cầu.
	emit_signal("hit_surface", self.global_position)
	# Tự hủy sau khi đã hoàn thành nhiệm vụ.
	queue_free()
