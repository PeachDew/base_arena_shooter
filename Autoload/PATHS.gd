extends Node

## UI ##
const LOADING_PS := "res://UIScenes/loading_scene.tscn"
const CHAR_BUTTON_PS := "res://UIScenes/character_button.tscn"
const CHAR_SELECT_PS := "res://UIScenes/start_scene.tscn"

const SMALL_XP_ORB_PS := "res://Objects/Misc/XP_Orbs/xp_orb_small.tscn"
const COMMON_LOOTBAG_PS := "res://Objects/Misc/Lootbags/common_loot_bag.tscn"
const RANGED_PLOOTY_PS := "res://Objects/Enemies/BasicRangedEnemy.tscn"
const EMBERLIGHT := "res://emberlight.tscn"


## PROJECTILES ##
const PROJ_PS_DIR := "res://Objects/Projectiles/ProjectilePackedScenes/"
const ABILITIES_PROJ_PS_DIR := PROJ_PS_DIR + "abilities/"
const ENEMY_PROJ_PS_DIR := PROJ_PS_DIR + "enemy/"

const PROJ_P0 := PROJ_PS_DIR + "prototype_projectile.tscn"
const PROJ_F0 := PROJ_PS_DIR + "firestaff_projectile.tscn"
const PROJ_TRAINEEBOW := PROJ_PS_DIR + "projectile_traineearrow.tscn"
const PROJ_TRAINEESTAFF := PROJ_PS_DIR + "projectile_traineebolt.tscn"
const PROJ_T2STAFF := PROJ_PS_DIR + "projectile_t2staff.tscn"
const PROJ_TRAINEEBLADE := PROJ_PS_DIR + "projectile_traineeslash.tscn"
const PROJ_BWZERO := PROJ_PS_DIR + "projectile_basicweapon.tscn"

### abilities ###
const PROJ_A01 := ABILITIES_PROJ_PS_DIR + "flash_bolt_projectile.tscn"

### enemy projectiles ###
const PROJ_ETZERO := ENEMY_PROJ_PS_DIR + "plooty_projectile.tscn"

### ultimates ###
const PROJ_METEOR_STRIKE := PROJ_PS_DIR +  "projectile_meteor_strike.tscn"

