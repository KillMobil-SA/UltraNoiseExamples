Shader "Custom/VerticalFogIntersection"
{
    Properties
    {
       _Color("Main Color", Color) = (1, 1, 1, .5)
       _IntersectionThresholdMax("Intersection Threshold Max", float) = 1
       _NoiseTex("Noise", 2D) = "white" {}
       _GradientMap("Gradient map", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType"="Transparent"  }
  
        Pass
        {
           Blend SrcAlpha OneMinusSrcAlpha
           ZWrite Off
           CGPROGRAM


           #pragma vertex vert
           #pragma fragment frag
           #pragma multi_compile_fog
           #include "UnityCG.cginc"
  
           struct appdata
           {
               float4 vertex : POSITION;
               float2 uv : TEXCOORD0;
               
           };
  
           struct v2f
           {
               float4 scrPos : TEXCOORD0;
               UNITY_FOG_COORDS(1)
               float4 vertex : SV_POSITION;
               float2 noiseUV: TEXCOORD2;
           };
  
           sampler2D _CameraDepthTexture;
           float4 _Color;
           float4 _IntersectionColor;
           float _IntersectionThresholdMax;

            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;
            sampler2D _GradientMap;
  
           v2f vert(appdata v)
           {
               v2f o;
               
               o.vertex = UnityObjectToClipPos(v.vertex);
               o.scrPos = ComputeScreenPos(o.vertex);
                o.noiseUV = TRANSFORM_TEX(v.uv,_NoiseTex);
               UNITY_TRANSFER_FOG(o,o.vertex);
               return o;   
           }
  
  
            half4 frag(v2f i) : SV_TARGET
            {
               float depth = LinearEyeDepth (tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)));
               float diff = saturate(_IntersectionThresholdMax * (depth - i.scrPos.w));
               fixed4 gradCol = tex2D(_GradientMap, float2(tex2D(_NoiseTex, i.noiseUV).r, 0)) * _Color;
               //fixed4 col = lerp(fixed4(_Color.rgb, 0.0), _Color, diff * diff * diff * (diff * (6 * diff - 15) + 10));
               fixed4 col = lerp(fixed4(gradCol.rgb, 0.0), gradCol, diff * diff * diff * (diff * (6 * diff - 15) + 10));
               UNITY_APPLY_FOG(i.fogCoord, col);
               return col;
            }
  
            ENDCG
        }
    }
}