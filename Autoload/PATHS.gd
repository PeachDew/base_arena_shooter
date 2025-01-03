extends Node

## UI ##
const LOADING_PS : String = "res://UIScenes/loading_scene.tscn"
const CHAR_BUTTON_PS : String = "res://UIScenes/character_button.tscn"
const CHAR_SELECT_PS : String = "res://UIScenes/start_scene.tscn"

## MATERIALS ##
const SMALL_XP_ORB_PS : String = "res://Objects/Misc/XP_Orbs/xp_orb_small.tscn"
const COMMON_LOOTBAG_PS : String = "res://Objects/Misc/Lootbags/common_loot_bag.tscn"
const COIN_PS : String = "res://Objects/Misc/Coins/coin.tscn"

## ENEMIES
const ENEMY_DIR : String = "res://Objects/Enemies/"
const RANGED_PLOOTY_PS : String = ENEMY_DIR+"BasicRangedEnemy.tscn"
const CHARGE_PLOOTY_PS : String = ENEMY_DIR+"charging_plooty.tscn"
const DOCOCO_PS : String = ENEMY_DIR+"dococo.tscn"

## WORLDS
const EMBERLIGHT : String = "res://emberlight.tscn"

## CLASSES ##
const CLASS_PS_DIR : String = "res://Classes/"
const CLASS_MAGE : String = CLASS_PS_DIR + "mage.tscn"
const CLASS_ARCHER : String = CLASS_PS_DIR + "archer.tscn"
const CLASS_WARRIOR : String = CLASS_PS_DIR + "warrior.tscn"
const CLASS_PRIEST : String = CLASS_PS_DIR + "priest.tscn"
const CLASS_WINDWALKER : String = CLASS_PS_DIR + "windwalker.tscn"
const CLASS_BLADEDANCER : String = CLASS_PS_DIR + "bladedancer.tscn"

## PROJECTILES ##
const PROJ_PS_DIR : String = "res://Objects/Projectiles/ProjectilePackedScenes/"
const ABILITIES_PROJ_PS_DIR : String = PROJ_PS_DIR + "abilities/"
const ENEMY_PROJ_PS_DIR : String = PROJ_PS_DIR + "enemy/"

const PROJ_P0 : String = PROJ_PS_DIR + "prototype_projectile.tscn"
const PROJ_F0 : String = PROJ_PS_DIR + "firestaff_projectile.tscn"
const PROJ_TRAINEEBOW : String = PROJ_PS_DIR + "projectile_traineearrow.tscn"
const PROJ_TRAINEESTAFF : String = PROJ_PS_DIR + "projectile_traineebolt.tscn"
const PROJ_TRAINEEBLADE : String = PROJ_PS_DIR + "projectile_traineeslash.tscn"
const PROJ_BWZERO : String = PROJ_PS_DIR + "projectile_basicweapon.tscn"
const PROJ_B01 : String = PROJ_PS_DIR + "projectile_curve_arrow.tscn"

const MAGIC_PROJ_PS_DIR : String = "res://Objects/Projectiles/ProjectilePackedScenes/magic/"
const PROJ_T0STAFF : String = MAGIC_PROJ_PS_DIR + "staff_t0_projectile.tscn"
const PROJ_T1STAFF : String = MAGIC_PROJ_PS_DIR + "staff_t1_projectile.tscn"
const PROJ_T2STAFF : String = MAGIC_PROJ_PS_DIR + "staff_t2_projectile.tscn"
const PROJ_T3STAFF : String = MAGIC_PROJ_PS_DIR + "staff_t3_projectile.tscn"
const PROJ_T4STAFF : String = MAGIC_PROJ_PS_DIR + "staff_t4_projectile.tscn"
const PROJ_T5STAFF : String = MAGIC_PROJ_PS_DIR + "staff_t5_projectile.tscn"

const MELEE_PROJ_PS_DIR : String = "res://Objects/Projectiles/ProjectilePackedScenes/melee/"
const PROJ_T0SWORD : String = MELEE_PROJ_PS_DIR + "sword_t0_projectile.tscn"
const PROJ_T1SWORD : String = MELEE_PROJ_PS_DIR + "sword_t1_projectile.tscn"
const PROJ_T2SWORD : String = MELEE_PROJ_PS_DIR + "sword_t2_projectile.tscn"
const PROJ_T3SWORD : String = MELEE_PROJ_PS_DIR + "sword_t3_projectile.tscn"
const PROJ_T4SWORD : String = MELEE_PROJ_PS_DIR + "sword_t4_projectile.tscn"
const PROJ_T5SWORD : String = MELEE_PROJ_PS_DIR + "sword_t5_projectile.tscn"

const RANGED_PROJ_PS_DIR : String = "res://Objects/Projectiles/ProjectilePackedScenes/ranged/"
const PROJ_T0BOW : String = RANGED_PROJ_PS_DIR + "bow_t0_projectile.tscn"
const PROJ_T1BOW : String = RANGED_PROJ_PS_DIR + "bow_t1_projectile.tscn"
const PROJ_T2BOW : String = RANGED_PROJ_PS_DIR + "bow_t2_projectile.tscn"
const PROJ_T3BOW : String = RANGED_PROJ_PS_DIR + "bow_t3_projectile.tscn"
const PROJ_T4BOW : String = RANGED_PROJ_PS_DIR + "bow_t4_projectile.tscn"
const PROJ_T5BOW : String = RANGED_PROJ_PS_DIR + "bow_t5_projectile.tscn"

## EXPLOSIONS ##
const PROJ_EXPLOSIONS_PS_DIR : String = "res://Objects/Projectiles/ProjectileExplosionPackedScenes/"
const EXPLOSION_TEST : String = PROJ_EXPLOSIONS_PS_DIR+"test_projectile_explosion.tscn"

const AOE_DIR : String = "res://Objects/AOEAttacks/"
const BEAM_01 : String = "res://Projectile/aoe_attack.tscn"
const BEAM_PRIEST : String = AOE_DIR + "priest_beam.tscn"

### abilities ###
const PROJ_A01 : String = ABILITIES_PROJ_PS_DIR + "flash_bolt_projectile.tscn"

### enemy projectiles ###
const PROJ_ETZERO : String = ENEMY_PROJ_PS_DIR + "plooty_projectile.tscn"
const PROJ_BOOSH : String = ENEMY_PROJ_PS_DIR + "boosh_projectile.tscn"
const PROJ_DOCOCO : String = ENEMY_PROJ_PS_DIR + "dococo_coconut_proj.tscn"

### ultimates ###
const PROJ_METEOR_STRIKE : String = PROJ_PS_DIR +  "projectile_meteor_strike.tscn"
const PROJ_DECASHOT : String = PROJ_PS_DIR + "projectile_decashot.tscn"
const PROJ_MAGE_ULT : String = PROJ_PS_DIR + "ultimates/" + "homing_bolt_mage_ult.tscn"
const PROJ_BLADEDANCE_ULT : String = PROJ_PS_DIR + "ultimates/" + "projectile_sword_slash_experiment.tscn"

### particles ###
const PARTICLES_PS_DIR : String = "res://Particles/"
const PARTICLES_SPARKLES_WHITE2GREEN : String = PARTICLES_PS_DIR + "particles_white2green_sparkles.tscn"
const PARTICLES_CONVERGINGSTRIPS_WHITE2RED : String = PARTICLES_PS_DIR + "particles_warrior_buff.tscn"
const PARTICLES_PROJECTILE_TRAIL_ORANGE2RED : String = PARTICLES_PS_DIR + "warrior_ult_shot_particles.tscn"
