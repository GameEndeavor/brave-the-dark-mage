extends Node
class_name CollisionLayers

const ENVIRONMENT = 1 << 0
const CHARACTER = 1 << 5
const FRIENDLY_HAZARD = 1 << 10
const ENEMY_HAZARD = 1 << 11
const COLLECTABLE = 1 << 12
const PORTAL = 1 << 13
const DEATH_ROOM = 1 << 14

const HAZARD = FRIENDLY_HAZARD | ENEMY_HAZARD
