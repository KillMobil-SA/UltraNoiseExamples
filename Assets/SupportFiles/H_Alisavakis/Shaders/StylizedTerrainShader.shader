Shader "Custom/StylizedTerrainShader_noCliffstuff"
{
    Properties
    {
   

        _LightCutoff("Light cutoff", Range(0,1)) = 0.5
        _ShadowBands("Shadow bands", Range(1,4)) = 1
        [Toggle(COLORED_SHADOWS)]
        _ColoredShadows("Colored shadows", float) = 0
        [HDR]_ShadowColor("Shadow color", Color) = (1,1,1,1)
        [HDR]_SpecularColor("Specular color", Color) = (0,0,0,1)
        

    }
    SubShader
    {
        Tags {
            "SplatCount" = "4"
            "Queue" = "Geometry-100"
            "RenderType" = "Opaque"
        }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf CelShaded fullforwardshadows exclude_path:prepass
        #pragma shader_feature COLORED_SHADOWS

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0


        fixed4 _SpecularColor;

        sampler2D _Control;

		// Textures
		sampler2D _Splat0, _Splat1, _Splat2, _Splat3;
        float4 _Splat0_ST, _Splat1_ST, _Splat2_ST, _Splat3_ST;

		//Normal Textures
		sampler2D _Normal0, _Normal1, _Normal2, _Normal3;

        //Normal scales
        float _NormalScale0, _NormalScale1, _NormalScale2, _NormalScale3;

        //Smoothness
        float _Smoothness0, _Smoothness1, _Smoothness2, _Smoothness3;

        //Metallic
        float _Metallic0, _Metallic1, _Metallic2, _Metallic3;

        float4 _Specular0, _Specular1, _Specular2, _Specular3;

        float _LightCutoff;
        
        fixed4 _ShadowColor;
        float _ShadowBands;


        struct Input
        {
            float2 uv_Control;
            float3 worldPos;
            float3 worldNormal;
            INTERNAL_DATA
        };

        struct SurfaceOutputCelShaded
        {
            fixed3 Albedo;
            fixed3 Normal;
			float Smoothness;
            half3 Emission;
            fixed Alpha;
        };

        half4 LightingCelShaded (SurfaceOutputCelShaded s, half3 lightDir, half3 viewDir, half atten) {
            half nDotL = saturate(dot(s.Normal, normalize(lightDir)));
            half diff = round(saturate(nDotL / _LightCutoff) * _ShadowBands) / _ShadowBands;

            float3 refl = reflect(normalize(lightDir), s.Normal);
            float vDotRefl = dot(viewDir, -refl);
            float3 specular = _SpecularColor.rgb * step(1 - s.Smoothness, vDotRefl);
            
            half stepAtten = round(atten);
            half shadow = diff * stepAtten;

            half3 col = (s.Albedo + specular) * _LightColor0;
            half4 c = half4(1,1,1,1);
            
            #if defined(COLORED_SHADOWS) && defined(USING_DIRECTIONAL_LIGHT)
            c.rgb = lerp(_ShadowColor, col.rgb, saturate(shadow +  (1.0 - _ShadowColor.a)));
            #else
            c.rgb = col * shadow;
            #endif
            
            c.a = s.Alpha;
            return c;
        }


        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputCelShaded o)
        {
            fixed4 splatControl = tex2D(_Control, IN.uv_Control);
            splatControl.r = step(0.1, splatControl.r - splatControl.g - splatControl.b - splatControl.a);
            splatControl.g = step(0.1, splatControl.g - splatControl.r - splatControl.b - splatControl.a);
            splatControl.b = step(0.1, splatControl.b - splatControl.g - splatControl.r - splatControl.a);
            splatControl.a = step(0.1, splatControl.a - splatControl.g - splatControl.b - splatControl.r);
            fixed4 col = splatControl.r * tex2D (_Splat0, IN.uv_Control * _Splat0_ST.xy) * _Specular0;
            col += splatControl.g * tex2D(_Splat1, IN.uv_Control * _Splat1_ST.xy) * _Specular1;
            col += splatControl.b * tex2D (_Splat2, IN.uv_Control * _Splat2_ST.xy) * _Specular2;
            col += splatControl.a * tex2D (_Splat3, IN.uv_Control * _Splat3_ST.xy) * _Specular3;
            
            o.Normal = splatControl.r * UnpackNormalWithScale(tex2D(_Normal0, IN.uv_Control * _Splat0_ST.xy), _NormalScale0);
            o.Normal += splatControl.g * UnpackNormalWithScale(tex2D(_Normal1, IN.uv_Control * _Splat1_ST.xy), _NormalScale1);
            o.Normal += splatControl.b * UnpackNormalWithScale(tex2D(_Normal2, IN.uv_Control * _Splat2_ST.xy), _NormalScale2);
            o.Normal += splatControl.a * UnpackNormalWithScale(tex2D(_Normal3, IN.uv_Control * _Splat3_ST.xy), _NormalScale3);

            o.Smoothness = splatControl.r * _Smoothness0;
            o.Smoothness += splatControl.g * _Smoothness1;
            o.Smoothness += splatControl.b * _Smoothness2;
            o.Smoothness += splatControl.a * _Smoothness3;


            o.Albedo = col.rgb;
            o.Alpha = col.a;
        }
        ENDCG
    }
    Dependency "AddPassShader" = "Custom/StylizedTerrainShaderAddPass"
    FallBack "Diffuse"
}
