Shader "lwsoft/outline3" {

	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_StepSize("step ", Float ) = 0.005
		_AlphaThrottle("alpha throttle ", Float ) = 0.5
		_Color( "Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100
	
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha 
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0
		sampler2D _MainTex;
		float  _StepSize;
		float4 _Color; 
		float _AlphaThrottle;
		struct Input {
			float2 uv_MainTex;
		};
        half4 goOut( float2 texturePos ){
        	half4 clr = tex2D (_MainTex, texturePos);
        	half alphaOffset = _AlphaThrottle;
        	if( clr.a < alphaOffset )
        	{
        	    float l = tex2D(_MainTex,  float2(texturePos.x - _StepSize  , texturePos.y ) ).a;
        	    float r = tex2D(_MainTex,  float2(texturePos.x + _StepSize  , texturePos.y ) ).a;
        	    float t = tex2D(_MainTex,  float2(texturePos.x              , texturePos.y + _StepSize) ).a;
        	    float b = tex2D(_MainTex,  float2(texturePos.x              , texturePos.y - _StepSize) ).a;
        	    
        	    float lt = tex2D(_MainTex,  float2(texturePos.x - _StepSize , texturePos.y + _StepSize) ).a;
        	    float lb = tex2D(_MainTex,  float2(texturePos.x - _StepSize , texturePos.y - _StepSize) ).a;
        	    float rt = tex2D(_MainTex,  float2(texturePos.x + _StepSize , texturePos.y + _StepSize) ).a;
        	    float rb = tex2D(_MainTex,  float2(texturePos.x + _StepSize , texturePos.y - _StepSize) ).a;
        	    
        	    if( (l+ r+ t+ b+ lt+ lb+ rt+ rb) > alphaOffset )
             	{
        			clr.rgb = _Color.rgb;
        			clr.a = _Color.a;
        		}else
        			clr.a = 0;
			
        	}
        	return clr;
        }
		void surf (Input IN, inout SurfaceOutput o) {
		
			half4 c = goOut(  IN.uv_MainTex) ; //
			
			o.Albedo = c.rgb  ; //c.rgb +tex2D (_MainTex, IN.uv_MainTex).rgb ;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
