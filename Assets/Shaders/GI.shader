Shader "Hidden/GI"
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

            sampler2D _Scene;
            sampler2D _JumpFlood;
            float4 _JumpFlood_TexelSize;
            int _MaxSteps;
            int _NumRays;
            sampler2D _BlueNoise;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_Scene, i.uv);
                //skip for light sources / walls / objects
                if(col.a > 0.1)
                {
                    return col;
                }
                else
                {
                    //const int maxSteps = 4;
                    float eps = _JumpFlood_TexelSize.x;

                    float noise = tex2D(_BlueNoise, i.uv).r;

                    float4 radiance = 0;
                    for(int rayIndex = 0; rayIndex < _NumRays; rayIndex++)
                    {
                        float angle = (rayIndex / float(_NumRays) + noise) * UNITY_TWO_PI;
                        float2 dir = float2(cos(angle), sin(angle));
                        
                        float2 curPos = i.uv;
                        //return dist;
                        for(int marchStep = 0; marchStep < _MaxSteps; marchStep++)
                        {
                            float2 nearestObj = tex2Dlod(_JumpFlood, float4(curPos, 0, 0)).xy;
                            float minDist = distance(nearestObj, curPos);
                            if(minDist < eps)
                            {
                                radiance += tex2Dlod(_Scene, float4(nearestObj, 0, 0));
                                break;
                            }
                            else
                            {
                                curPos += dir * minDist;
                            }
                        }
                    }
                    return radiance / _NumRays;
                    return float4(1,0,1,1);
                }
            }
            ENDCG
        }
    }
}
