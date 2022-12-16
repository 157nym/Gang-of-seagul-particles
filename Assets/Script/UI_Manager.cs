using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class UI_Manager : MonoBehaviour
{

    [SerializeField] TMP_Text Txt_Score;
    [SerializeField] TMP_Text Txt_Time;


    [HideInInspector]
    public int It_Score, It_HighScore;

    [HideInInspector]
    public float Ft_Time;

    private void Update()
    {
        int minutes = Mathf.FloorToInt(Ft_Time / 60F);
        int seconds = Mathf.FloorToInt(Ft_Time - minutes * 60);
        Txt_Time.text = string.Format("{0:0}:{1:00}", minutes, seconds);
        //Txt_Score.text = It_Score.ToString();
    }

    public void V_EndOfTheGame()
    {
        It_Score = It_HighScore;
    }





}
