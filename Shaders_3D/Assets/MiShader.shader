Shader "Unlit/MiShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_OtherTex ("Texture", 2D) = "black" {}
		_SlideTex ("Slider Texture", Range (0,1)) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _OtherTex;
			float4 _MainTex_ST;
			float4 _OtherText_ST;
			float _SlideTex;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col2 = tex2D(_OtherTex, i.uv2);
				// apply fog
				fixed4 finalCol= col * _SlideTex + col2 *(1-_SlideTex);
				UNITY_APPLY_FOG(i.fogCoord, finalCol);
				return finalCol;
			}
			ENDCG
		}
	}
}
