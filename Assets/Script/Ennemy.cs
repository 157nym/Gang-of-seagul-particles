using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Ennemy : MonoBehaviour
{
    [SerializeField] GameObject Go_Head;
    [SerializeField] GameObject Go_Body;
    SkinnedMeshRenderer Head_meshRenderer;
    MeshCollider Head_collider;
    SkinnedMeshRenderer Body_meshRenderer;
    MeshCollider Body_collider;
    bool B_Touched = false;

    private void Awake()
    {
        Head_collider = Go_Head.GetComponent<MeshCollider>();
        Head_meshRenderer = Go_Head.GetComponent<SkinnedMeshRenderer>();

        Body_collider= Go_Body.GetComponent<MeshCollider>();
        Body_meshRenderer = Go_Body.GetComponent<SkinnedMeshRenderer>();
    }
    public void V_BeenTouch()
    {
        B_Touched = true;
    }

    private void Update ()
    {
        if (B_Touched != true)
        {
            Mesh colliderMeshForHead = new Mesh();
            Mesh colliderMeshForBody= new Mesh();
            Head_meshRenderer.BakeMesh(colliderMeshForHead);
            Body_meshRenderer.BakeMesh(colliderMeshForBody);
            Head_collider.sharedMesh = null;
            Head_collider.sharedMesh = colliderMeshForHead;
            Body_collider.sharedMesh = null;
            Body_collider.sharedMesh = colliderMeshForBody;
        }
    }

}
