extends Area2D
class_name Bullet

const WORLD_COLLISION_MASK :=1

#子弹飞行速度，单位为像素/秒。
@export var speed:float =320.0
#子弹最大存活时间，防止未命中时永久留在场景中。
@export var max_lifetime:float =2.0

#飞弹当前的飞行方向。
var direction :Vector2=Vector2.RIGHT
#剩余存活时间，递减到0后自动销毁
var remaining_lifetime:float =0.0

#初始化寿命，并绑定Area2D碰撞信号。
func _ready() -> void:
	remaining_lifetime=max_lifetime
	area_entered.connect(_on_area_entered)


#由外部在生成子弹后调用，注入初始方向
func setup(initial_direction:Vector2)->void:
	if initial_direction != Vector2.ZERO:
		direction=initial_direction.normalized()
		
	rotation=direction.angle()
	
	
#每帧先检测飞行路径是否回撞到世界，再更新位置并处理超时回收
func _physics_process(delta: float) -> void:
	var current_position:=global_position
	var next_position:=current_position +direction * speed *delta
	
	if _will_hit_world(current_position,next_position):
		queue_free()
		return
		
	global_position=next_position
	
	#没有命中任何对象时，也要在超时后自动清理。
	remaining_lifetime-=delta
	if remaining_lifetime<=0.0:
		queue_free()


#使用射线查询检测当前这一帧的飞行路径，避免子弹穿过零厚度边界或薄墙体。
func _will_hit_world(from_position:Vector2,to_position:Vector2)->bool:
	var space_state := get_world_2d().direct_space_state
	if space_state == null:
		return false
	
	var query := PhysicsRayQueryParameters2D.create(
		from_position,
		to_position,
		WORLD_COLLISION_MASK
	)
	query.collide_with_bodies = true
	query.collide_with_areas = false
	
	var hit_result:Dictionary = space_state.intersect_ray(query)
	return not hit_result.is_empty()
	
	
	#与Area2D碰撞后销毁，同时忽略其他子弹。
func _on_area_entered(area:Area2D) -> void:
	if area is Bullet:
		
		
		return
		
	queue_free()
