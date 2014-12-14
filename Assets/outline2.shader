Shader "lwsoft/outline2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_StepSize("step ", Vector ) = (0,0,0,0)
		_Color( "Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100
	
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha 
/*
		LIGHTMAP OFF
		DIRLIGHTMAP OFF
		SHADOWS OFF
*/
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float4 _StepSize;
		float4 _Color; 
		
		struct Input {
			float2 uv_MainTex;
		};
        half4 goOut( float2 texturePos ){
        	half4 clr = tex2D (_MainTex, texturePos);
        	       	
        	float alpha = 4*clr.a;
        	
        	float2 arr[4]={ {1,0},{-1,0},{0,1},{0,-1} //,
        				//	{1,1},{1,-1},{-1,1},{-1,-1}
        	              }; 
        	for( int n=0; n< 4; n++)
        	{
        		float2 tmp = float2( texturePos.x+( arr[n].x *_StepSize.x), texturePos.y+(arr[n].y*_StepSize.y));
        		alpha -= tex2D(_MainTex,  tmp ).a;
        	}
			clr.rgb = _Color.rgb;
		    clr.a = alpha;
		    
        	return clr;
        }
		void surf (Input IN, inout SurfaceOutput o) {
		
			half4 c = goOut(  IN.uv_MainTex) ; //
			half4 org = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = lerp(  c.rgb,org.rgb, org.a-c.a);
			o.Alpha = c.a + org.a ;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
