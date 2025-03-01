using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GI : MonoBehaviour
{
    public DrawingUtility drawingUtility;
    public Shader shader;

    private Material _mat;

    private RenderTexture _gi;

    [Range(4, 64)]
    public int numRays;

    [Range(1, 32)]
    public int maxSteps;

    public Texture2D blueNoise;
    private int _accumulationFrames;

    [Range(0, 10)]
    public float noiseScale;
    // Start is called before the first frame update
    void Start()
    {
        _gi = new RenderTexture(drawingUtility.Scene.width, drawingUtility.Scene.height, 0, RenderTextureFormat.ARGB32);
        _gi.filterMode = FilterMode.Point;
        _gi.wrapMode = TextureWrapMode.Clamp;
        Shader.SetGlobalTexture("_GI", _gi);
        
        Shader.SetGlobalTexture("_BlueNoise", blueNoise);
    }

    // Update is called once per frame
    void Update()
    {
        if (_mat == null)
        {
            _mat = new Material(shader);
        }
        _mat.SetInt("_NumRays", numRays);
        _mat.SetInt("_MaxSteps", maxSteps);
        _mat.SetInt("_AccumulationFrames", _accumulationFrames);
        _mat.SetFloat("_NoiseScale", noiseScale);
        
        Graphics.Blit(null, _gi, _mat);
        _accumulationFrames++;
    }
}
