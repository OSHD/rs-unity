// Amplify Color - Advanced Color Grading for Unity Pro
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

Shader "Hidden/Amplify Color/BlendMask3d" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}
	
	Subshader {
		ZTest Always Cull Off ZWrite Off Blend Off
		Fog { Mode off }
		
		// LDR
		Pass {
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma exclude_renderers flash gles
				#include "Common3d.cginc"
				
				half4 frag( v2f i ) : COLOR
				{
					half4 color = tex2D( _MainTex, i.uv );
					half mask = tex2D( _MaskTex, i.uv1 ).r;
					return lerp( color, apply3d_blend( color ), mask );
				}
			ENDCG
		}
	
		// HDR
		Pass {
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma exclude_renderers flash gles
				#include "Common3d.cginc"
				
				half4 frag( v2f i ) : COLOR
				{
				#if SHADER_API_D3D9
					half4 color = min( tex2D( _MainTex, i.uv ), 1.0 );
				#else
					half4 color = saturate( tex2D( _MainTex, i.uv ) );
				#endif
					half mask = tex2D( _MaskTex, i.uv1 ).r;
					return lerp( color, apply3d_blend( color ), mask );
				}
			ENDCG
		}
	}

Fallback off
	
} // shader