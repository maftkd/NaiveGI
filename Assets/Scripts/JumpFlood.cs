using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JumpFlood : MonoBehaviour
{
    public DrawingUtility drawingUtility;
    private RenderTexture _jumpFlood;
    
    public Shader jumpFloodShader;

    private Material _jumpFloodMat;
    // Start is called before the first frame update
    void Start()
    {
        _jumpFlood = new RenderTexture(drawingUtility.Scene.width, drawingUtility.Scene.height, 0, RenderTextureFormat.ARGBFloat);
        _jumpFlood.filterMode = FilterMode.Point;
        Shader.SetGlobalTexture("_JumpFlood", _jumpFlood);
    }

    // Update is called once per frame
    void Update()
    {
        if(_jumpFloodMat == null)
        {
            _jumpFloodMat = new Material(jumpFloodShader);
        }
        
        int numPasses = (int)Mathf.Log(Mathf.Max(_jumpFlood.width, _jumpFlood.height), 2);
        RenderTexture tmp = RenderTexture.GetTemporary(_jumpFlood.width, _jumpFlood.height, 0, _jumpFlood.format);
        
        //init pass
        Graphics.Blit(drawingUtility.Scene, tmp, _jumpFloodMat, 0);
        
        for(int i = 0; i < numPasses; i++)
        {
            int radius = 1 << numPasses - i - 1;
            _jumpFloodMat.SetInt("_Radius", radius);
            if (i % 2 == 0)
            {
                Graphics.Blit(tmp, _jumpFlood, _jumpFloodMat, 1);
            }
            else
            {
                Graphics.Blit(_jumpFlood, tmp, _jumpFloodMat, 1);
            }
            //Graphics.Blit(_jumpFlood, _jumpFlood, drawingUtility.jumpFloodMat, pass);
        }

        if (numPasses % 2 == 0)
        {
            Graphics.Blit(tmp, _jumpFlood);
        }
        //Graphics.Blit(tmp, _jumpFlood);
        
        RenderTexture.ReleaseTemporary(tmp);
    }
}
