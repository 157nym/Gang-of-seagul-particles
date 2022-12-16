using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Rendering;
using UnityEngine.UI;

public class Pistol : MonoBehaviour
{
    [Header("Parameters")]
    [SerializeField] int It_AmmoStart;
    public int It_AmmoForBigShoot;
    public int It_AmmoForNormalShoot;
    
    [Header("Prefab")]
    [SerializeField] GameObject O_Ammo;
    [SerializeField] Transform Tf_SpawnPoint;
    [SerializeField] TMP_Text Txt_Ammo;

    [HideInInspector]
    public static int It_Ammo;

    UnityEvent Et_NoAmmo = new UnityEvent();

    XRIDefaultInputActions map;


    private void Awake()
    {
       It_Ammo = It_AmmoStart;
       if (O_Ammo== null) 
       {
            Debug.LogWarning("Manque le Prefab des ammo");
       }
       map = new XRIDefaultInputActions();
       map.Enable();

       if (transform.parent.tag == "Left")
       {
            map.XRILeftHandInteraction.Shoot.performed += V_Shoot;
       }
       else if (transform.parent.tag == "Right")
       {
            map.XRIRightHandInteraction.Shoot.performed += V_Shoot;
       }

    }
    private void Update()
    {
        Txt_Ammo.text = It_Ammo.ToString();
    }

    public void V_Shoot(UnityEngine.InputSystem.InputAction.CallbackContext cxt) // La fucntion qui se lance au shoot 
    {
        if (It_Ammo > 0)
        {
            FMODUnity.RuntimeManager.PlayOneShot("event:/PIOUPIOU");
            var bullet = Instantiate(O_Ammo, Tf_SpawnPoint.position, Tf_SpawnPoint.rotation );
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
