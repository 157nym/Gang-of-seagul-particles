using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spheretrigger : MonoBehaviour
{

    [SerializeField] Timer S_Timer;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag != "Bullet" && other.tag != "Pistol")
        {
            S_Timer.Ft_T -= 5;
        }
    }

}
