Shader "Hidden/JumpFlood"
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

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                if(col.a > 0.1)
                {
                    return float4(i.uv, 0, 2);
                }
                return -1;
            }
            ENDCG
        }
        
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
            float4 _MainTex_TexelSize;
            int _Radius;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                if(col.a > 1)
                {
                    return col;
                }

                float2 texelSize = _MainTex_TexelSize.xy;
                float2 nearestCoords = 0;
                float minDist = 1;
                for(int y = -1; y <= 1; y++)
                {
                    for(int x = -1; x <= 1; x++)
                    {
                        if(x == 0 && y == 0)
                        {
                            continue;
                        }
                        float2 uv = i.uv + float2(x, y) * texelSize * _Radius;
                        if(uv.x < 0 || uv.x > 1 || uv.y < 0 || uv.y > 1)
                        {
                            continue;
                        }

                        float2 coords = tex2D(_MainTex, uv).xy;
                        if(coords.x < 0)
                        {
                            continue;
                        }

                        float dist = distance(coords, i.uv);
                        if(dist < minDist)
                        {
                            minDist = dist;
                            nearestCoords = coords;
                        }
                    }
                }
                if(minDist == 1)
                {
                    return col;
                }
                else
                {
                    return float4(nearestCoords, 0, 1);
                }
            }
            ENDCG
        }
    }
}
