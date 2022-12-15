using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Timer : MonoBehaviour
{
    [Header("Parameters")]
    [SerializeField] float Ft_TimerValue;
    public int It_TimeForBigShoot;
    public int It_TimeForNormalShoot;

    [Header("ScriptToRef")]
    [SerializeField] UI_Manager S_Ui_Manager;

    [Header("Event")]
    UnityEvent Et_EndofTimer;
    float Ft_T;


    private void Start()
    {
        Ft_T = Ft_TimerValue;
    }


    private void Update()
    {
        if (Ft_TimerValue > 0)
        {
            Ft_T-= Time.deltaTime;
        }
        else
        {
            Ft_T = 0;
        }

        if (Ft_T <= 0)
        {
            V_TimerEnd();
        }
        S_Ui_Manager.Ft_Time = Ft_T;
    }

    void V_TimerEnd()
    {
        Et_EndofTimer.Invoke();
    }

    public void V_TimerAdd(float Value)
    {
        Ft_T += Value;
    }

    public void V_TimerSub(float Value)
    {
        Ft_T -= Value;
    }

}
