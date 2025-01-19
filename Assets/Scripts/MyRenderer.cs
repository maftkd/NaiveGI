using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MyRenderer : MonoBehaviour
{
    public Shader shader;

    private Material _mat;

    private RenderTexture _history;
    // Start is called before the first frame update
    void Start()
    {
        Application.targetFrameRate = 60;
        
        _history = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGBHalf);
        _history.filterMode = FilterMode.Point;
        _history.wrapMode = TextureWrapMode.Clamp;
        Shader.SetGlobalTexture("_History", _history);
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (_mat == null)
        {
            _mat = new Material(shader);
        }
        
        RenderTexture tmp = RenderTexture.GetTemporary(src.width, src.height, 0, _history.format);
        Graphics.Blit(src, tmp, _mat);
        Graphics.Blit(tmp, _history);
        //Graphics.Blit(src, dest, _mat);
        Graphics.Blit(_history, dest);
    }
}
