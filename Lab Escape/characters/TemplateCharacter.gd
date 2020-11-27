extends KinematicBody2D

export(Curve) var acceleration
export (float) var SPEED = 20

const MAX_SPEED = 200
const INTERPOLATE = 0.3 # for when the player stops
