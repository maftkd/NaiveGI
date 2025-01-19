Shader "Hidden/Renderer"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _Scene;
            sampler2D _JumpFlood;
            sampler2D _GI;
            sampler2D _History;

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_Scene, i.uv);
                //fixed4 col = tex2D(_JumpFlood, i.uv);
                //fixed4 col = tex2D(_GI, i.uv);
                fixed4 curCol = tex2D(_GI, i.uv);
                fixed4 history = tex2D(_History, i.uv);
                return lerp(curCol, history, 0.9);
            }
            ENDCG
        }
    }
}
