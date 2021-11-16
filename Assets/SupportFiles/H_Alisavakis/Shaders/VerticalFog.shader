Shader "Custom/VerticalFogPanningNoise"
{
    Properties
    {
       _Color("Main Color", Color) = (1, 1, 1, .5)
       _NoiseTextureA("Noise texture A", 2D) = "white" {} 
       _NoiseTextureB("Noise texture B", 2D) = "white" {} 
       _PanningSpeeds("Panning speeds", Vector) = (1,1,1,1)
       _IntersectionThresholdMin("Intersection Threshold Min", float) = 0
       _IntersectionThresholdMax("Intersection Threshold Max", float) = 1
       
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType"="Transparent"  }
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
  
        Pass
        {
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
               float2 uv : TEXCOORD0;
               float4 scrPos : TEXCOORD1;
               UNITY_FOG_COORDS(2)
               float4 vertex : SV_POSITION;
           };
  
            sampler2D _CameraDepthTexture;
            float4 _Color;
            float4 _IntersectionColor;
            float _IntersectionThresholdMax;
            float _IntersectionThresholdMin;
            sampler2D _NoiseTextureA;
            float4 _NoiseTextureA_ST;
            sampler2D _NoiseTextureB;
            float4 _NoiseTextureB_ST;
            float4 _PanningSpeeds;

           v2f vert(appdata v)
           {
               v2f o;
               o.vertex = UnityObjectToClipPos(v.vertex);
               o.scrPos = ComputeScreenPos(o.vertex);
               o.uv = v.uv;
               UNITY_TRANSFER_FOG(o,o.vertex);
               return o;   
           }
  
  
            half4 frag(v2f i) : SV_TARGET
            {
                float noise = tex2D(_NoiseTextureA, i.uv * _NoiseTextureA_ST.xy + _Time.y * float2(_PanningSpeeds.x, _PanningSpeeds.y)).x;
                noise *= tex2D(_NoiseTextureB, i.uv * _NoiseTextureB_ST.xy + _Time.y * float2(_PanningSpeeds.z, _PanningSpeeds.w)).x * 2.0;
                float depth = LinearEyeDepth (tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)));
                float diff = saturate(lerp(_IntersectionThresholdMin, _IntersectionThresholdMax, noise) * (depth - i.scrPos.w));
    
                fixed4 col = lerp(fixed4(_Color.rgb, 0.0), _Color, diff * diff * diff * (diff * (6 * diff - 15) + 10));
    
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
  
            ENDCG
        }
    }
}