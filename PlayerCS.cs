using Godot;
using System;

public class PlayerCS : KinematicBody2D
{
	GDScript movementGd;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		movementGd = GD.Load<GDScript>("res://Movement.gd");
	}

	public override void _Process(float delta)
	{
		movementGd.Call("_process", this);
	}

	public override void _PhysicsProcess(float delta)
	{
		movementGd.Call("_physics_process", this);
	}
}
