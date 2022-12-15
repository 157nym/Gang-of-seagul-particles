using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UI_Manager : MonoBehaviour
{

    [SerializeField] Text Txt_Score;
    [SerializeField] Text Txt_Time;


    [HideInInspector]
    public int It_Score, It_HighScore;

    [HideInInspector]
    public float Ft_Time;

    private void Update()
    {
        Txt_Time.text = Ft_Time.ToString();
        Txt_Score.text = It_Score.ToString();
    }

    public void V_EndOfTheGame()
    {
        It_Score = It_HighScore;
    }





}
