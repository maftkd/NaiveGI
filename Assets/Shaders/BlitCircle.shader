Shader "Hidden/BlitCircle"
{
    Properties
    {
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

            fixed4 _Color;
            fixed4 _Circle;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 circleUv = _Circle.xy / _ScreenParams.xy;
                float radius = _Circle.z / _ScreenParams.x;
                fixed dist = length(i.uv - circleUv);
                if(dist > radius)
                {
                    discard;
                }
                return _Color;
            }
            ENDCG
        }
    }
}
