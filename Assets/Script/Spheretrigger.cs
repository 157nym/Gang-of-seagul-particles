using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spheretrigger : MonoBehaviour
{

    [SerializeField] Timer S_Timer;
    bool flag = false;

    private void OnTriggerEnter(Collider other)
    {
        if (flag) return;
        if (other.tag != "Bullet" && other.tag != "Pistol")
        {
            flag = true;
            StartCoroutine(WaitXSecond());
            S_Timer.Ft_T -= 2;
            FMODUnity.RuntimeManager.PlayOneShot("event:/MBOUFH");
        }
    }

    IEnumerator WaitXSecond()
    {
        yield return new WaitForSeconds(1);
        flag = false;
    }

}
