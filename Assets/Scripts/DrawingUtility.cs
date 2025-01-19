using UnityEngine;
using UnityEngine.UI;

public class DrawingUtility : MonoBehaviour
{
    private RenderTexture _scene;

    private Material _clearMat;

    public Shader blitCircle;
    private Material _drawMat;

    [Range(0, 10)]
    public float radius;

    public Color curColor;
    
    private bool _drewLastFrame;
    private Vector3 _prevMousePos;

    public GameObject buttonParent;
    
    // Start is called before the first frame update
    void Start()
    {
        _scene = new RenderTexture(512, 512, 0, RenderTextureFormat.ARGB32);
        _scene.filterMode = FilterMode.Point;
        _scene.wrapMode = TextureWrapMode.Clamp;
        Shader.SetGlobalTexture("_Scene", _scene);
        
        Shader unlitColor = Shader.Find("Unlit/Color");
        _clearMat = new Material(unlitColor);
        _clearMat.color = Color.black;
        ClearScene();
        
        _drawMat = new Material(blitCircle);
        
        Button[] colorButtons = buttonParent.GetComponentsInChildren<Button>();
        foreach (Button button in colorButtons)
        {
            button.onClick.AddListener(() =>
            {
                curColor = button.GetComponent<RawImage>().color;
            });
        }
    }

    void ClearScene()
    {
        Graphics.Blit(null, _scene, _clearMat);
    }

    void DrawPoint(Vector2 pos)
    {
        //Vector2 mousePos = Input.mousePosition;
        _drawMat.SetColor("_Color", curColor);
        _drawMat.SetVector("_Circle", new Vector4(pos.x, pos.y, radius, 0));
        RenderTexture tmp = RenderTexture.GetTemporary(_scene.width, _scene.height, 0, _scene.format);
        Graphics.Blit(_scene, tmp);
        Graphics.Blit(tmp, _scene, _drawMat);
        RenderTexture.ReleaseTemporary(tmp);
    }

    // Update is called once per frame
    void Update()
    {
        bool drawing = Input.GetMouseButton(0);
        if (drawing)
        {
            if (_drewLastFrame)
            {
                Vector2 startPoint = _prevMousePos;
                Vector2 endPoint = Input.mousePosition;
                Vector2 direction = (endPoint - startPoint).normalized;
                float distance = Vector2.Distance(startPoint, endPoint);
                for (int i = 0; i < distance; i++)
                {
                    Vector2 point = startPoint + direction * i;
                    DrawPoint(point);
                }

            }
            //DrawPointUnderMouse();
            
            _prevMousePos = Input.mousePosition;
        }
        
        _drewLastFrame = drawing;
    }
}
