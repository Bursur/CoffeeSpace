using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    public float speed = 10.0f;
    public float rotationSpeed = 10.0f;

    public Player target;
    public Weapon weapon;

    public int maxHealth = 100;
    public int maxShields = 100;

    private int _health;
    private int _shields = 0;

	// Use this for initialization
	void Start ()
    {
        _health = maxHealth;
        _shields = 0;
	}
	
	// Update is called once per frame
	void Update ()
    {
	}

    private void FixedUpdate()
    {
        if (target != null)
            updateTargetTracking();
    }

    void updateTargetTracking()
    {
        Vector3 pos = transform.position;
        Vector3 dest = target.transform.position;

        Vector3 dir = dest - pos;
        dir.Normalize();

        float newRot = Mathf.Atan2(dir.y, dir.x);
        transform.rotation.Set(0, 0, newRot, 0);

    }
}
