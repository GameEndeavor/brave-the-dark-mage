extends Node
class_name CollisionLayers

const ENVIRONMENT = 1 << 0
const CHARACTER = 1 << 5
const FRIENDLY_HAZARD = 1 << 10
const ENEMY_HAZARD = 1 << 11

const HAZARD = FRIENDLY_HAZARD | ENEMY_HAZARD
