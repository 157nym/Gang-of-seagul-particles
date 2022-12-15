using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Rendering;

public class Pistol : MonoBehaviour
{
    [Header("Parameters")]
    [SerializeField] int It_AmmoStart;
    public int It_AmmoForBigShoot;
    public int It_AmmoForNormalShoot;
    
    [Header("Prefab")]
    [SerializeField] GameObject O_Ammo;
    [SerializeField] Transform Tf_SpawnPoint;

    [HideInInspector]
    public int It_Ammo;

    UnityEvent Et_NoAmmo;


    private void Awake()
    {
       if (O_Ammo== null) 
       {
            Debug.LogWarning("Manque le Prefab des ammo");
       }

    }

    public void V_Shoot() // La fucntion qui se lance au shoot 
    {
        if (It_Ammo > 0)
        {
            FMODUnity.RuntimeManager.PlayOneShot("event:/PIOUPIOU");
            var bullet = Instantiate(O_Ammo, Tf_SpawnPoint);
            bullet.GetComponent<Bullet>().S_Pistol = this;
            bullet.tag = "Bullet";
            It_Ammo -= 1;

        }
        else
        {
            It_Ammo = 0;
        }

        if (It_Ammo == 0)
        {
            Et_NoAmmo.Invoke();
        }
    }

    public bool V_AddAmmo(int value )
    {
        It_Ammo += value;
        return true;
    }

    public bool V_SubAmmo(int value)
    { 
        It_Ammo -= value;
        return true; 
    }

}
