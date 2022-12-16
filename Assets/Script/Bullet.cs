using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(CapsuleCollider))]
[RequireComponent(typeof(Rigidbody))]
[RequireComponent(typeof(TrailRenderer))]
public class Bullet : MonoBehaviour
{
    Rigidbody rb; 
    TrailRenderer Tr;

    [HideInInspector]
    public Pistol S_Pistol;

    [Header("Parameters")]
    [SerializeField] float Speed;
    [SerializeField] float LifeTime;

    Timer S_Timer;


    float T;


    private void Awake()
    {
        S_Timer = FindObjectOfType<Timer>();
        rb = GetComponent<Rigidbody>();
        Tr= GetComponent<TrailRenderer>();
    }

    private void Start()
    {
        T = LifeTime;
        rb.velocity = transform.forward * Speed;
    }

    private void Update()
    {
        rb.velocity = transform.forward * Speed;
        V_Timer();
        RaycastHit hit;

        if (Physics.Raycast(transform.position, transform.forward,out hit, Speed/2))
        {
            HitScan(hit.collider);
        }
    }

    void V_Timer()
    {
        T -= Time.deltaTime;
        if (T <= 0)
        {
            DestroyImmediate(this.gameObject);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        HitScan(other);
    }

    void HitScan(Collider other)
    {
        if (other == this || other.tag == "Pistol")
        {
            return;
        }
        if (other.tag == ("Head"))
        {
            S_Pistol.V_AddAmmo(S_Pistol.It_AmmoForBigShoot);
            S_Timer.V_TimerAdd(S_Timer.It_TimeForBigShoot);
            other.gameObject.GetComponentInParent<Ennemy>().V_BeenTouch();
            FMODUnity.RuntimeManager.PlayOneShot("event:/MOR");
            Destroy(this.gameObject);
        }
        else if (other.tag == ("Body"))
        {
            S_Pistol.V_AddAmmo(S_Pistol.It_AmmoForNormalShoot);
            S_Timer.V_TimerAdd(S_Timer.It_TimeForNormalShoot);
            other.gameObject.GetComponentInParent<Ennemy>().V_BeenTouch();
            FMODUnity.RuntimeManager.PlayOneShot("event:/MOR");
            Destroy(this.gameObject);
        }
        else
        {
            Destroy(this.gameObject);
            FMODUnity.RuntimeManager.PlayOneShot("event:/Impact");
        }
    }

}
