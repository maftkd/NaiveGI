using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MyRenderer : MonoBehaviour
{
    public Shader shader;

    private Material _mat;
    // Start is called before the first frame update
    void Start()
    {
        Application.targetFrameRate = 60;
        
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (_mat == null)
        {
            _mat = new Material(shader);
        }
        
        Graphics.Blit(src, dest, _mat);
    }
}
