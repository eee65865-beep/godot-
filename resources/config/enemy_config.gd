extends Resource
class_name EnemyConfig

enum EnemyType {
	BASIC,
	SHELLED,
	FAST_SMALL,
	BOMBER,
}

@export_group("基础信息")
# 用于标记敌人的大类，便于后续在编辑器中区分不同变种。
@export var enemy_type: EnemyType = EnemyType.BASIC
# 显示名称，方便在调试信息或编辑器中识别资源用途。
@export var display_name: String = "基础敌人"


@export_group("基础数值")
# 最大生命值，敌人生成时可用它初始化当前生命值。
@export_range(1, 999, 1, "or_greater") var max_health: int = 3
# 移动速度，单位通常为像素/秒。
@export_range(0.0, 1000.0, 1.0, "or_greater") var move_speed: float = 60.0
# 圆形碰撞区域半径，可用于不同体型敌人的碰撞大小配置。
@export_range(1.0, 256.0, 0.5, "or_greater") var collision_radius: float = 8


@export_group("动画资源")
# 敌人本体使用的 SpriteFrames 资源。
# 建议在同一个资源中同时配置移动、待机、死亡等动画。
@export var enemy_frames: SpriteFrames
# 敌人正常移动时默认播放的动画名。
@export var move_animation_name: StringName = &"move"
# 敌人死亡时默认播放的动画名。
@export var death_animation_name: StringName = &"death"
# 爆炸特效默认播放的动画名。
@export var explosion_animation_name: StringName = &"explode"


@export_group("死亡效果")
# 是否在死亡时触发自爆。
@export var explode_on_death: bool = false
# 自爆伤害，只有 explode_on_death 为 true 时才有意义。
@export_range(0, 999, 1, "or_greater") var explosion_damage: int = 0
# 自爆半径，只有 explode_on_death 为 true 时才有意义。
@export_range(0.0, 512.0, 1.0, "or_greater") var explosion_radius: float = 0


@export_group("掉落")
# 敌人死亡后尝试掉落道具的概率。
@export_range(0.0, 1.0, 0.01) var pickup_drop_chance: float = 0.3
# 当前敌人允许掉落的道具配置列表；为空时表示该敌人不会掉落道具。
@export var pickup_drop_configs: Array[PickupConfig] = [
	preload("res://resources/config/pickup_speed.tres"),
	preload("res://resources/config/pickup_rapid.tres"),
	preload("res://resources/config/pickup_spiral.tres"),
]
