// Upgrade NOTE: upgraded instancing buffer 'SkyBoxShading' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SkyBox Shading"
{
	Properties
	{
		_MoonDiskSize("Moon Disk Size", Range( 0 , 0.5)) = 0
		_SunDiskSize("Sun Disk Size", Range( 0 , 0.5)) = 0
		_SunDiskSizeAdjust("Sun Disk Size Adjust", Range( 0 , 0.01)) = 0
		_MoonDiskSizeAdjust("Moon Disk Size Adjust", Range( 0 , 0.01)) = 0
		_MoonDiskSharpness("Moon Disk Sharpness", Range( 0 , 0.01)) = 0
		_SunDiskSharpness("Sun Disk Sharpness", Range( 0 , 0.01)) = 0
		_HorizonGlowIntensity("Horizon Glow Intensity", Range( 0 , 1)) = 0.59
		_HorizonSharpness("Horizon Sharpness", Float) = 5.7
		_HorizonSunGlowSpreadMin("Horizon Sun Glow Spread Min", Range( 0 , 10)) = 5.075109
		_HorizonSunGlowSpreadMax("Horizon Sun Glow Spread Max", Range( 0 , 10)) = 0
		_HorizonTintSunPower("Horizon Tint Sun Power", Float) = 0
		_NightTransitionScale("Night Transition Scale", Float) = 1
		_NightTransitionHorizonDelay("Night Transition Horizon Delay", Float) = 0
		_HorizonMinAmountAlways("Horizon Min Amount Always", Range( 0 , 1)) = 0
		[HDR]_MoonColor("MoonColor", Color) = (1,1,1,0)
		[HDR]_SunColor("SunColor", Color) = (1,1,1,0)
		_SunOpacity("Sun Opacity", Range( 0 , 1)) = 1
		_MoonOpacity("Moon Opacity", Range( 0 , 1)) = 1
		_SkyColor("SkyColor", Color) = (0.5330188,0.9382771,1,0)
		_HighSkyColor("HighSkyColor", Color) = (0.5330188,0.9382771,1,0)
		_Horizon_Glow("Horizon_Glow", Float) = 0
		_SkyGradient_Size("SkyGradient_Size", Float) = 1
		_SkyGradient_Height("SkyGradient_Height", Float) = 0
		_Cloudscale("Cloud scale", Float) = 0
		_CloudsDensity("Clouds Density", Range( 0 , 1)) = 0
		_CloudsOpacity("Clouds Opacity", Range( -1 , 1)) = 0
		_CloudsColor("Clouds Color", Color) = (0.9433962,0.9433962,0.9433962,0)
		_CloudsDistance("Clouds Distance", Float) = 0
		_Cloudsheight("Clouds height", Float) = 0
		_CloudsSpeed("Clouds Speed", Float) = 0
		_NoiseSpeed("Noise Speed", Float) = 0.1
		_NoiseColor("NoiseColor", Color) = (0.2884107,0,1,0)
		_NoisePower("Noise Power", Range( 0 , 1)) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 0

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			//This is a late directive
			
			uniform float4 _CloudsColor;
			uniform float _CloudsSpeed;
			uniform float _Cloudscale;
			uniform float _CloudsDensity;
			uniform float _Cloudsheight;
			uniform float _CloudsDistance;
			uniform float _CloudsOpacity;
			uniform float _SkyGradient_Size;
			uniform float _SkyGradient_Height;
			uniform float4 _NoiseColor;
			uniform float _NoiseSpeed;
			uniform float _NoisePower;
			uniform float _Horizon_Glow;
			uniform float _NightTransitionScale;
			uniform float _NightTransitionHorizonDelay;
			uniform float _HorizonMinAmountAlways;
			uniform float _HorizonSharpness;
			uniform float _HorizonSunGlowSpreadMin;
			uniform float _HorizonSunGlowSpreadMax;
			uniform float _HorizonGlowIntensity;
			uniform float _HorizonTintSunPower;
			uniform float _SunDiskSize;
			uniform float _SunDiskSizeAdjust;
			uniform float _SunDiskSharpness;
			uniform float _SunOpacity;
			uniform float4 _SunColor;
			uniform float _MoonDiskSize;
			uniform float _MoonDiskSizeAdjust;
			uniform float _MoonDiskSharpness;
			uniform float _MoonOpacity;
			uniform float4 _MoonColor;
			UNITY_INSTANCING_BUFFER_START(SkyBoxShading)
				UNITY_DEFINE_INSTANCED_PROP(float4, _SkyColor)
#define _SkyColor_arr SkyBoxShading
				UNITY_DEFINE_INSTANCED_PROP(float4, _HighSkyColor)
#define _HighSkyColor_arr SkyBoxShading
			UNITY_INSTANCING_BUFFER_END(SkyBoxShading)
			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1 = v.vertex;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float3 appendResult497 = (float3(i.ase_texcoord1.xyz.x , ( i.ase_texcoord1.xyz.y / 0.1 ) , i.ase_texcoord1.xyz.z));
				float mulTime538 = _Time.y * ( _CloudsSpeed * 1.0 );
				float3 temp_output_537_0 = ( appendResult497 + mulTime538 );
				float temp_output_494_0 = ( _Cloudscale / 1.0 );
				float simplePerlin3D543 = snoise( temp_output_537_0*temp_output_494_0 );
				simplePerlin3D543 = simplePerlin3D543*0.5 + 0.5;
				float simplePerlin3D489 = snoise( temp_output_537_0*( temp_output_494_0 / 2.0 ) );
				simplePerlin3D489 = simplePerlin3D489*0.5 + 0.5;
				float4 Clouds524 = ( _CloudsColor * step( ( simplePerlin3D543 * simplePerlin3D489 ) , ( _CloudsDensity * ( _Cloudsheight - ( i.ase_texcoord1.xyz.y * _CloudsDistance ) ) ) ) );
				float4 _SkyColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_SkyColor_arr, _SkyColor);
				float4 _HighSkyColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_HighSkyColor_arr, _HighSkyColor);
				float4 lerpResult436 = lerp( _SkyColor_Instance , _HighSkyColor_Instance , saturate( ( ( i.ase_texcoord1.xyz.y * _SkyGradient_Size ) + _SkyGradient_Height ) ));
				float mulTime553 = _Time.y * _NoiseSpeed;
				float3 appendResult567 = (float3(( i.ase_texcoord1.xyz.x + mulTime553 ) , i.ase_texcoord1.xyz.y , i.ase_texcoord1.xyz.z));
				float simplePerlin3D547 = snoise( appendResult567 );
				simplePerlin3D547 = simplePerlin3D547*0.5 + 0.5;
				float3 appendResult568 = (float3(i.ase_texcoord1.xyz.x , ( i.ase_texcoord1.xyz.y + ( mulTime553 * 2.0 ) ) , i.ase_texcoord1.xyz.z));
				float simplePerlin3D555 = snoise( appendResult568 );
				simplePerlin3D555 = simplePerlin3D555*0.5 + 0.5;
				float3 appendResult569 = (float3(i.ase_texcoord1.xyz.y , i.ase_texcoord1.xyz.y , ( i.ase_texcoord1.xyz.z + ( mulTime553 * 2.4 ) )));
				float simplePerlin3D558 = snoise( appendResult569*0.5 );
				simplePerlin3D558 = simplePerlin3D558*0.5 + 0.5;
				float4 lerpResult554 = lerp( lerpResult436 , _NoiseColor , ( step( ( simplePerlin3D547 * simplePerlin3D555 * simplePerlin3D558 ) , 0.1 ) * _NoisePower ));
				float4 SkyColor197 = lerpResult554;
				float4 HorizonColor313 = ( SkyColor197 + _Horizon_Glow );
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(WorldPosition);
				float dotResult238 = dot( -worldSpaceLightDir , float3( 0,1,0 ) );
				float NightTransScale235 = _NightTransitionScale;
				float HorizonScaleDayNight304 = saturate( ( dotResult238 * ( NightTransScale235 + _NightTransitionHorizonDelay ) ) );
				float dotResult213 = dot( worldSpaceLightDir , float3( 0,1,0 ) );
				float HorizonGlowGlobalScale307 = (_HorizonMinAmountAlways + (saturate( pow( ( 1.0 - abs( dotResult213 ) ) , 4.14 ) ) - 0.0) * (1.0 - _HorizonMinAmountAlways) / (1.0 - 0.0));
				float3 normalizeResult42 = normalize( WorldPosition );
				float dotResult40 = dot( normalizeResult42 , float3( 0,1,0 ) );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float dotResult12 = dot( -worldSpaceLightDir , ase_worldViewDir );
				float InvVDotL200 = dotResult12;
				float temp_output_22_0 = min( _HorizonSunGlowSpreadMin , _HorizonSunGlowSpreadMax );
				float temp_output_23_0 = max( _HorizonSunGlowSpreadMin , _HorizonSunGlowSpreadMax );
				float clampResult14 = clamp( (0.0 + (InvVDotL200 - ( 1.0 - ( temp_output_22_0 * temp_output_22_0 ) )) * (1.0 - 0.0) / (( 1.0 - ( temp_output_23_0 * temp_output_23_0 ) ) - ( 1.0 - ( temp_output_22_0 * temp_output_22_0 ) ))) , 0.0 , 1.0 );
				float dotResult88 = dot( worldSpaceLightDir , float3( 0,-1,0 ) );
				float clampResult89 = clamp( dotResult88 , 0.0 , 1.0 );
				float TotalHorizonMask314 = ( ( ( 1.0 - HorizonScaleDayNight304 ) * HorizonGlowGlobalScale307 ) * saturate( pow( ( 1.0 - abs( dotResult40 ) ) , _HorizonSharpness ) ) * saturate( ( pow( ( 1.0 - clampResult14 ) , 5.0 ) * _HorizonGlowIntensity * ( 1.0 - clampResult89 ) ) ) );
				float4 lerpResult55 = lerp( SkyColor197 , HorizonColor313 , TotalHorizonMask314);
				float temp_output_2_0_g1 = TotalHorizonMask314;
				float temp_output_3_0_g1 = ( 1.0 - temp_output_2_0_g1 );
				float3 appendResult7_g1 = (float3(temp_output_3_0_g1 , temp_output_3_0_g1 , temp_output_3_0_g1));
				float3 temp_cast_1 = (_HorizonTintSunPower).xxx;
				float SunDiskSize286 = ( 1.0 - ( _SunDiskSize + _SunDiskSizeAdjust ) );
				float temp_output_262_0 = ( SunDiskSize286 * ( 1.0 - ( 0.99 + _SunDiskSharpness ) ) );
				float temp_output_75_0 = saturate( InvVDotL200 );
				float dotResult265 = dot( temp_output_75_0 , temp_output_75_0 );
				float smoothstepResult261 = smoothstep( ( SunDiskSize286 - temp_output_262_0 ) , ( SunDiskSize286 + temp_output_262_0 ) , dotResult265);
				float dotResult302 = dot( WorldPosition.y , 1.0 );
				float3 appendResult382 = (float3(_SunColor.r , _SunColor.g , _SunColor.b));
				float3 SunDisk203 = ( saturate( ( smoothstepResult261 * saturate( dotResult302 ) ) ) * _SunOpacity * appendResult382 );
				float MoonDiskSize463 = ( 1.0 - ( _MoonDiskSize + _MoonDiskSizeAdjust ) );
				float temp_output_465_0 = ( MoonDiskSize463 * ( 1.0 - ( 0.99 + _MoonDiskSharpness ) ) );
				float dotResult454 = dot( worldSpaceLightDir , ase_worldViewDir );
				float temp_output_464_0 = saturate( dotResult454 );
				float dotResult468 = dot( temp_output_464_0 , temp_output_464_0 );
				float smoothstepResult473 = smoothstep( ( MoonDiskSize463 - temp_output_465_0 ) , ( MoonDiskSize463 + temp_output_465_0 ) , dotResult468);
				float dotResult470 = dot( WorldPosition.y , 1.0 );
				float3 appendResult477 = (float3(_MoonColor.r , _MoonColor.g , _MoonColor.b));
				float3 MoonDisk481 = ( saturate( ( smoothstepResult473 * saturate( dotResult470 ) ) ) * _MoonOpacity * appendResult477 );
				float4 Sky175 = ( ( Clouds524 * _CloudsOpacity ) + ( lerpResult55 + float4( ( pow( ( ( HorizonColor313.rgb * temp_output_2_0_g1 ) + appendResult7_g1 ) , temp_cast_1 ) * ( SunDisk203 + MoonDisk481 ) ) , 0.0 ) ) );
				
				
				finalColor = Sky175;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
7;305;2546;1074;801.2385;1998.091;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;199;-1880.225,-1873.41;Inherit;False;3564.311;751.8528;Comment;38;554;197;563;564;84;81;92;91;85;556;551;436;441;547;422;558;555;444;445;552;560;559;548;562;443;447;561;438;553;446;235;557;86;565;566;567;568;569;Sky Color Base;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;206;-4306.389,-1003.857;Inherit;False;4121.021;1625.509;Comment;18;198;175;76;55;63;311;313;314;316;356;398;400;448;305;309;528;531;532;Horizon And Sun Glow;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;205;-4328.524,-1856.158;Inherit;False;2352.849;723.3484;Comment;31;75;203;71;69;10;261;263;264;265;262;268;271;281;282;252;285;284;286;287;297;298;300;302;303;380;382;383;200;12;11;34;Sun Disk;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;557;-384.8109,-1363.651;Inherit;False;Property;_NoiseSpeed;Noise Speed;32;0;Create;True;0;0;0;False;0;False;0.1;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;10;-4289.205,-1433.755;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;356;-4279.824,-167.2684;Inherit;False;2341.093;657.4434;Comment;23;62;19;90;15;17;89;16;32;14;88;13;87;201;27;29;28;26;25;24;23;22;20;21;Horizon Glow added from the sun;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;308;-2889.816,-2319.44;Inherit;False;1802.634;338.6813;Comment;10;213;221;215;220;222;212;216;223;244;307;Scalar that makes the horizon glow brighter when the sun is low, scales it out when the sun is down and directly above;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;553;-199.7233,-1357.516;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;562;13.99669,-1252.189;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;212;-2839.816,-2269.44;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;86;-1813.676,-1276.479;Float;False;Property;_NightTransitionScale;Night Transition Scale;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-4229.824,122.2515;Float;False;Property;_HorizonSunGlowSpreadMax;Horizon Sun Glow Spread Max;9;0;Create;True;0;0;0;False;0;False;0;5.11;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-4219.824,33.2516;Float;False;Property;_HorizonSunGlowSpreadMin;Horizon Sun Glow Spread Min;8;0;Create;True;0;0;0;False;0;False;5.075109;4.9;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;34;-4026.139,-1302.774;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;11;-4288.771,-1289.879;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;306;-4345.006,-2340.811;Inherit;False;1333.227;394.979;Scales the horizon glow depending on the direction of the sun.  If it's below the horizon it scales out faster;9;241;237;243;242;238;239;240;236;304;Horizon Daynight mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;548;-124.2518,-1505.791;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;561;19.10958,-1351.38;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;22;-3914.826,22.25159;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;235;-1502.353,-1270.548;Float;False;NightTransScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;236;-4236.198,-2290.811;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;12;-3853.616,-1301.558;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;23;-3899.826,138.2514;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;552;151.491,-1504.881;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;450;-4245.031,712.2099;Inherit;False;2352.849;723.3484;Comment;32;481;480;479;478;477;476;475;474;473;472;471;470;469;468;467;466;465;464;463;462;461;460;459;458;457;456;454;453;451;486;487;488;Sun Disk;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;559;157.6264,-1391.374;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;560;157.6264,-1280.935;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;566;211.7615,-1654.591;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;213;-2557.587,-2253.341;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-3751.826,140.2514;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;456;-4207.588,992.6068;Float;False;Property;_MoonDiskSizeAdjust;Moon Disk Size Adjust;3;0;Create;True;0;0;0;False;0;False;0;0.01;0;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;438;-882.5624,-1575.567;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-3763.826,11.25165;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;221;-2406.566,-2255.662;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;-3699.708,-1299.173;Float;False;InvVDotL;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;457;-4202.163,761.1789;Float;False;Property;_MoonDiskSize;Moon Disk Size;0;0;Create;True;0;0;0;False;0;False;0;0.031;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;243;-4295.005,-2060.831;Float;False;Property;_NightTransitionHorizonDelay;Night Transition Horizon Delay;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-4285.656,-1807.189;Float;False;Property;_SunDiskSize;Sun Disk Size;1;0;Create;True;0;0;0;False;0;False;0;0.013;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;237;-3949.367,-2270.218;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;446;-911.2361,-1434.927;Inherit;False;Property;_SkyGradient_Size;SkyGradient_Size;23;0;Create;True;0;0;0;False;0;False;1;3.4372;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;-4236.392,-2146.804;Inherit;False;235;NightTransScale;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;311;-4282.975,-560.9692;Inherit;False;1484.109;291.775;;8;59;51;47;46;44;40;42;41;Base Horizon Glow;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;568;465.7615,-1415.591;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;567;462.7615,-1531.591;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;569;461.7615,-1287.591;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-4291.081,-1575.761;Float;False;Property;_SunDiskSizeAdjust;Sun Disk Size Adjust;2;0;Create;True;0;0;0;False;0;False;0;0.00631;0;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;284;-3921.335,-1803.423;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;27;-3577.876,87.55197;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;451;-4205.712,1134.613;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;201;-3628.821,-110.7302;Inherit;False;200;InvVDotL;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;443;-673.2361,-1529.927;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-3575.277,0.4519947;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;238;-3798.68,-2278.003;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-3553.177,244.8518;Float;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;242;-3947.212,-2138.988;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;281;-4015.29,-1428.623;Float;False;Property;_SunDiskSharpness;Sun Disk Sharpness;5;0;Create;True;0;0;0;False;0;False;0;0.00999999;0;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;216;-2229.349,-2180.238;Float;False;Constant;_HideHorizonGlowScale;Hide Horizon Glow Scale;12;0;Create;True;0;0;0;False;0;False;4.14;4.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;459;-3967.797,1084.745;Float;False;Property;_MoonDiskSharpness;Moon Disk Sharpness;4;0;Create;True;0;0;0;False;0;False;0;0.00976;0;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;447;-654.2361,-1423.927;Inherit;False;Property;_SkyGradient_Height;SkyGradient_Height;24;0;Create;True;0;0;0;False;0;False;0;0.3919404;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;453;-4205.278,1278.489;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;28;-3555.777,160.3517;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;215;-2214.217,-2265.927;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;458;-3837.842,764.9449;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;558;600.96,-1299.228;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;547;591.7568,-1519.084;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;555;601.9824,-1419.894;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;41;-4228.346,-494.7657;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;461;-3653.123,944.3868;Inherit;False;2;2;0;FLOAT;0.99;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;445;-429.2361,-1528.927;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;87;-3309.25,228.3578;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;454;-3770.123,1266.81;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;282;-3736.616,-1623.981;Inherit;False;2;2;0;FLOAT;0.99;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;42;-4033.649,-463.454;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;268;-3747.704,-1807.15;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;460;-3664.211,761.2178;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;239;-3641.031,-2266.257;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;13;-3321.69,-47.08187;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;556;831.0411,-1478.181;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;220;-1956.32,-2236.495;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;286;-3526.744,-1801.192;Float;False;SunDiskSize;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;40;-3757.447,-464.7546;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;441;-1145.236,-1656.927;Inherit;False;InstancedProperty;_HighSkyColor;HighSkyColor;21;0;Create;True;0;0;0;False;0;False;0.5330188,0.9382771,1,0;0.09120867,0.02440761,0.2673206,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;564;841.2672,-1363.651;Inherit;False;Property;_NoisePower;Noise Power;34;0;Create;True;0;0;0;False;0;False;0;0.9970633;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;222;-1788.71,-2225.302;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;463;-3443.251,767.1758;Float;False;MoonDiskSize;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;240;-3471.867,-2252.022;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;515;-116.0105,-215.3755;Inherit;False;2436.059;643.3586;Clouds;23;497;498;524;525;490;526;489;511;510;494;534;514;493;535;533;513;541;542;538;537;543;544;546;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;565;957.7615,-1480.591;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;75;-3452.344,-1367.051;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;244;-1918.605,-2095.759;Float;False;Property;_HorizonMinAmountAlways;Horizon Min Amount Always;13;0;Create;True;0;0;0;False;0;False;0;0.625;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;88;-3068.165,229.0258;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,-1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;14;-3101.354,-47.41712;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;271;-3532.888,-1614.416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;462;-3449.395,953.9518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;464;-3368.851,1201.317;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;444;-294.2361,-1532.927;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;422;-1146.165,-1824.502;Inherit;False;InstancedProperty;_SkyColor;SkyColor;20;0;Create;True;0;0;0;False;0;False;0.5330188,0.9382771,1,0;0.08466775,0,0.3047357,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;287;-3572.001,-1525.927;Inherit;False;286;SunDiskSize;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;32;-2938.803,-35.81703;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;467;-3352.122,1286.722;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;436;-45.56438,-1747.634;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;468;-3154.896,1179.235;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;300;-3435.615,-1281.646;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;551;958.8645,-1670.427;Inherit;False;Property;_NoiseColor;NoiseColor;33;0;Create;True;0;0;0;False;0;False;0.2884107,0,1,0;0.2936458,0.06092024,0.3490566,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;304;-3307.78,-2256.349;Float;False;HorizonScaleDayNight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;44;-3571.094,-457.9051;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;465;-3205.995,769.4449;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;563;1098.958,-1474.09;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-3063.753,77.28284;Float;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;89;-2936.466,224.2446;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-3289.488,-1798.923;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;265;-3238.389,-1389.133;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;541;-73.26752,75.65543;Inherit;False;Property;_CloudsSpeed;Clouds Speed;31;0;Create;True;0;0;0;False;0;False;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;546;-47.754,-171.0228;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;223;-1574.484,-2227.258;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;466;-3488.508,1042.441;Inherit;False;463;MoonDiskSize;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;305;-4257.591,-878.2952;Inherit;False;304;HorizonScaleDayNight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;469;-2989.763,899.3078;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;471;-2988.708,769.7789;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;302;-3249.104,-1278.298;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;263;-3073.256,-1669.06;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;472;-2881.298,1046.9;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;15;-2732.854,-73.21727;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;264;-3072.201,-1798.589;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;493;586.0159,60.397;Inherit;False;Property;_Cloudscale;Cloud scale;25;0;Create;True;0;0;0;False;0;False;0;0.81;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2870.218,66.3748;Float;False;Property;_HorizonGlowIntensity;Horizon Glow Intensity;6;0;Create;True;0;0;0;False;0;False;0.59;0.523;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;307;-1363.18,-2227.899;Float;False;HorizonGlowGlobalScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;47;-3381.537,-444.7644;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;554;1276.887,-1746.098;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;542;107.9261,82.98676;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;297;-2964.791,-1521.468;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-3514.3,-367.9907;Float;False;Property;_HorizonSharpness;Horizon Sharpness;7;0;Create;True;0;0;0;False;0;False;5.7;25.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;470;-3165.611,1290.07;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;498;194.9895,-38.37551;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;90;-2781.34,217.5739;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;303;-3065.358,-1358.665;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;261;-2902.857,-1720.626;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;535;740.6654,170.0099;Inherit;False;Property;_CloudsDistance;Clouds Distance;29;0;Create;True;0;0;0;False;0;False;0;3.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;1445.898,-1749.653;Float;False;SkyColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;474;-2981.865,1209.703;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;-4248.517,-776.4443;Inherit;False;307;HorizonGlowGlobalScale;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;494;777.016,65.39699;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;473;-2819.364,847.7419;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;538;241.1064,78.97708;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;513;746.5223,234.8399;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-2512.698,-43.05833;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;234;-3960.059,-876.0325;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;497;428.9895,-135.3755;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;51;-3213.856,-440.3124;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;448;-2213.252,-762.8535;Inherit;False;Property;_Horizon_Glow;Horizon_Glow;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;534;936.8979,189.206;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;533;1064.666,153.0099;Inherit;False;Property;_Cloudsheight;Clouds height;30;0;Create;True;0;0;0;False;0;False;0;1.71;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;398;-2149.721,-951.576;Inherit;True;197;SkyColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;537;682.786,-38.10587;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;59;-2969.237,-465.6631;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;476;-2603.185,896.5599;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;544;998.246,59.97717;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;475;-2666.296,1157.352;Inherit;False;Property;_MoonColor;MoonColor;16;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0.6452273,0.9536855,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;62;-2346.927,-49.23482;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;-2686.678,-1671.808;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;380;-2749.789,-1411.016;Inherit;False;Property;_SunColor;SunColor;17;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;-3739.015,-824.0848;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;489;1205.215,-36.85286;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1E-05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;478;-2421.043,906.0518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;69;-2504.536,-1662.316;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;400;-1876.721,-924.576;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.6981132;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;514;1269.522,159.8399;Inherit;False;2;0;FLOAT;1.25;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;383;-2645.592,-1515.349;Inherit;False;Property;_SunOpacity;Sun Opacity;18;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-1807.266,-707.8991;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;382;-2463.119,-1384.225;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;479;-2562.099,1053.019;Inherit;False;Property;_MoonOpacity;Moon Opacity;19;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;510;1163.925,86.94574;Inherit;False;Property;_CloudsDensity;Clouds Density;26;0;Create;True;0;0;0;False;0;False;0;0.209;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;477;-2379.626,1184.143;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;543;1210.246,-140.0228;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1E-05;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;314;-1622.942,-714.1615;Float;False;TotalHorizonMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;313;-1583.498,-821.9012;Float;False;HorizonColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;480;-2212.066,909.3948;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-2295.559,-1658.973;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;511;1435.924,95.94575;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;316;-1892.409,-11.60108;Inherit;False;937.6819;498.8079;Comment;9;288;290;204;291;289;315;312;484;485;Tintint the sun with the horizon color for added COOL;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;545;1465.246,-19.02283;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;203;-2156.953,-1667.295;Float;False;SunDisk;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;481;-2070.302,901.0728;Float;False;MoonDisk;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;526;1616.151,-159.7976;Inherit;False;Property;_CloudsColor;Clouds Color;28;0;Create;True;0;0;0;False;0;False;0.9433962,0.9433962,0.9433962,0;0.9433962,0.9433962,0.9433962,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;490;1618.824,1.845747;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;312;-1827,35.13788;Inherit;False;313;HorizonColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;-1840.013,131.3501;Inherit;False;314;TotalHorizonMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;484;-1797.816,370.8813;Inherit;False;481;MoonDisk;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;289;-1573.055,79.37746;Inherit;False;Lerp White To;-1;;1;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;525;1901.151,10.20245;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;204;-1798.367,301.5597;Inherit;False;203;SunDisk;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;291;-1848.931,222.4503;Float;False;Property;_HorizonTintSunPower;Horizon Tint Sun Power;10;0;Create;True;0;0;0;False;0;False;0;15.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;524;2059.151,2.202451;Inherit;False;Clouds;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;485;-1565.124,308.4966;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-1566.107,-913.3846;Inherit;False;197;SkyColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;290;-1370.484,86.31239;Inherit;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;532;-1033.983,-840.6526;Inherit;False;Property;_CloudsOpacity;Clouds Opacity;27;0;Create;True;0;0;0;False;0;False;0;-0.01554242;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;55;-1273.505,-853.463;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;528;-919.6082,-907.8065;Inherit;False;524;Clouds;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;-1140.778,141.2002;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-919.7489,-762.123;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;530;-726.9829,-850.6526;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;531;-584.9829,-774.6526;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-425.2654,-771.2576;Float;False;Sky;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;371;233.7476,-2803.307;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;81;-1206.26,-1389.306;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;487;-3416.972,1431.433;Inherit;False;InvVDotL2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;372;374.7475,-2811.307;Inherit;False;SkyBoxUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;91;-1848.937,-1463.985;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;361;-380.2529,-2881.307;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;488;-3576.67,1326.681;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;374;619.7324,-2508.088;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PiNode;364;-297.253,-2602.307;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;375;437.7325,-2195.088;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TauNode;369;-43.25256,-2795.307;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1025.165,-1336.528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;359;1248.005,-2510.331;Float;False;Sky2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NegateNode;92;-1562.107,-1442.092;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;377;331.7325,-2394.088;Inherit;False;Property;_Color1;Color 1;15;0;Create;True;0;0;0;False;0;False;0.990566,0.7270182,0.3224012,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;373;245.1915,-2180.688;Inherit;False;372;SkyBoxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;360;-569.253,-2883.307;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;486;-3806.319,1359.151;Inherit;False;200;InvVDotL;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;365;-76.25257,-2615.307;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;368;-54.25257,-2910.307;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;379;935.7314,-2507.088;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;84;-838.4169,-1285.169;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;218;-94.76877,-903.5953;Inherit;True;175;Sky;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;370;95.74747,-2853.307;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;366;95.74747,-2686.307;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;362;-233.253,-2881.307;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ASinOpNode;363;-81.25257,-2711.307;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;376;328.7325,-2555.088;Inherit;False;Property;_Color0;Color 0;14;0;Create;True;0;0;0;False;0;False;1,0.935315,0.6933962,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;39;132.271,-911.8556;Float;False;True;-1;2;ASEMaterialInspector;0;1;SkyBox Shading;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;553;0;557;0
WireConnection;562;0;553;0
WireConnection;34;0;10;0
WireConnection;561;0;553;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;235;0;86;0
WireConnection;12;0;34;0
WireConnection;12;1;11;0
WireConnection;23;0;20;0
WireConnection;23;1;21;0
WireConnection;552;0;548;1
WireConnection;552;1;553;0
WireConnection;559;0;548;2
WireConnection;559;1;561;0
WireConnection;560;0;548;3
WireConnection;560;1;562;0
WireConnection;213;0;212;0
WireConnection;25;0;23;0
WireConnection;25;1;23;0
WireConnection;24;0;22;0
WireConnection;24;1;22;0
WireConnection;221;0;213;0
WireConnection;200;0;12;0
WireConnection;237;0;236;0
WireConnection;568;0;566;1
WireConnection;568;1;559;0
WireConnection;568;2;566;3
WireConnection;567;0;552;0
WireConnection;567;1;566;2
WireConnection;567;2;566;3
WireConnection;569;0;566;2
WireConnection;569;1;566;2
WireConnection;569;2;560;0
WireConnection;284;0;252;0
WireConnection;284;1;285;0
WireConnection;27;0;25;0
WireConnection;443;0;438;2
WireConnection;443;1;446;0
WireConnection;26;0;24;0
WireConnection;238;0;237;0
WireConnection;242;0;241;0
WireConnection;242;1;243;0
WireConnection;215;0;221;0
WireConnection;458;0;457;0
WireConnection;458;1;456;0
WireConnection;558;0;569;0
WireConnection;547;0;567;0
WireConnection;555;0;568;0
WireConnection;461;1;459;0
WireConnection;445;0;443;0
WireConnection;445;1;447;0
WireConnection;454;0;451;0
WireConnection;454;1;453;0
WireConnection;282;1;281;0
WireConnection;42;0;41;0
WireConnection;268;0;284;0
WireConnection;460;0;458;0
WireConnection;239;0;238;0
WireConnection;239;1;242;0
WireConnection;13;0;201;0
WireConnection;13;1;26;0
WireConnection;13;2;27;0
WireConnection;13;3;28;0
WireConnection;13;4;29;0
WireConnection;556;0;547;0
WireConnection;556;1;555;0
WireConnection;556;2;558;0
WireConnection;220;0;215;0
WireConnection;220;1;216;0
WireConnection;286;0;268;0
WireConnection;40;0;42;0
WireConnection;222;0;220;0
WireConnection;463;0;460;0
WireConnection;240;0;239;0
WireConnection;565;0;556;0
WireConnection;75;0;200;0
WireConnection;88;0;87;0
WireConnection;14;0;13;0
WireConnection;271;0;282;0
WireConnection;462;0;461;0
WireConnection;464;0;454;0
WireConnection;444;0;445;0
WireConnection;32;0;14;0
WireConnection;436;0;422;0
WireConnection;436;1;441;0
WireConnection;436;2;444;0
WireConnection;468;0;464;0
WireConnection;468;1;464;0
WireConnection;304;0;240;0
WireConnection;44;0;40;0
WireConnection;465;0;463;0
WireConnection;465;1;462;0
WireConnection;563;0;565;0
WireConnection;563;1;564;0
WireConnection;89;0;88;0
WireConnection;262;0;286;0
WireConnection;262;1;271;0
WireConnection;265;0;75;0
WireConnection;265;1;75;0
WireConnection;223;0;222;0
WireConnection;223;3;244;0
WireConnection;469;0;466;0
WireConnection;469;1;465;0
WireConnection;471;0;466;0
WireConnection;471;1;465;0
WireConnection;302;0;300;2
WireConnection;263;0;287;0
WireConnection;263;1;262;0
WireConnection;472;0;468;0
WireConnection;15;0;32;0
WireConnection;15;1;16;0
WireConnection;264;0;287;0
WireConnection;264;1;262;0
WireConnection;307;0;223;0
WireConnection;47;0;44;0
WireConnection;554;0;436;0
WireConnection;554;1;551;0
WireConnection;554;2;563;0
WireConnection;542;0;541;0
WireConnection;297;0;265;0
WireConnection;470;0;467;2
WireConnection;498;0;546;2
WireConnection;90;0;89;0
WireConnection;303;0;302;0
WireConnection;261;0;297;0
WireConnection;261;1;264;0
WireConnection;261;2;263;0
WireConnection;197;0;554;0
WireConnection;474;0;470;0
WireConnection;494;0;493;0
WireConnection;473;0;472;0
WireConnection;473;1;471;0
WireConnection;473;2;469;0
WireConnection;538;0;542;0
WireConnection;19;0;15;0
WireConnection;19;1;17;0
WireConnection;19;2;90;0
WireConnection;234;0;305;0
WireConnection;497;0;546;1
WireConnection;497;1;498;0
WireConnection;497;2;546;3
WireConnection;51;0;47;0
WireConnection;51;1;46;0
WireConnection;534;0;513;2
WireConnection;534;1;535;0
WireConnection;537;0;497;0
WireConnection;537;1;538;0
WireConnection;59;0;51;0
WireConnection;476;0;473;0
WireConnection;476;1;474;0
WireConnection;544;0;494;0
WireConnection;62;0;19;0
WireConnection;298;0;261;0
WireConnection;298;1;303;0
WireConnection;233;0;234;0
WireConnection;233;1;309;0
WireConnection;489;0;537;0
WireConnection;489;1;544;0
WireConnection;478;0;476;0
WireConnection;69;0;298;0
WireConnection;400;0;398;0
WireConnection;400;1;448;0
WireConnection;514;0;533;0
WireConnection;514;1;534;0
WireConnection;63;0;233;0
WireConnection;63;1;59;0
WireConnection;63;2;62;0
WireConnection;382;0;380;1
WireConnection;382;1;380;2
WireConnection;382;2;380;3
WireConnection;477;0;475;1
WireConnection;477;1;475;2
WireConnection;477;2;475;3
WireConnection;543;0;537;0
WireConnection;543;1;494;0
WireConnection;314;0;63;0
WireConnection;313;0;400;0
WireConnection;480;0;478;0
WireConnection;480;1;479;0
WireConnection;480;2;477;0
WireConnection;71;0;69;0
WireConnection;71;1;383;0
WireConnection;71;2;382;0
WireConnection;511;0;510;0
WireConnection;511;1;514;0
WireConnection;545;0;543;0
WireConnection;545;1;489;0
WireConnection;203;0;71;0
WireConnection;481;0;480;0
WireConnection;490;0;545;0
WireConnection;490;1;511;0
WireConnection;289;1;312;0
WireConnection;289;2;315;0
WireConnection;525;0;526;0
WireConnection;525;1;490;0
WireConnection;524;0;525;0
WireConnection;485;0;204;0
WireConnection;485;1;484;0
WireConnection;290;0;289;0
WireConnection;290;1;291;0
WireConnection;55;0;198;0
WireConnection;55;1;313;0
WireConnection;55;2;314;0
WireConnection;288;0;290;0
WireConnection;288;1;485;0
WireConnection;76;0;55;0
WireConnection;76;1;288;0
WireConnection;530;0;528;0
WireConnection;530;1;532;0
WireConnection;531;0;530;0
WireConnection;531;1;76;0
WireConnection;175;0;531;0
WireConnection;371;0;370;0
WireConnection;371;1;366;0
WireConnection;81;0;92;0
WireConnection;487;0;488;0
WireConnection;372;0;371;0
WireConnection;361;0;360;0
WireConnection;488;0;454;0
WireConnection;488;1;486;0
WireConnection;374;0;376;0
WireConnection;374;1;377;0
WireConnection;374;2;375;1
WireConnection;375;0;373;0
WireConnection;85;0;81;0
WireConnection;85;1;235;0
WireConnection;359;0;379;0
WireConnection;92;0;91;0
WireConnection;365;0;364;0
WireConnection;368;0;362;0
WireConnection;368;1;362;2
WireConnection;379;0;374;0
WireConnection;84;0;85;0
WireConnection;370;0;368;0
WireConnection;370;1;369;0
WireConnection;366;0;363;0
WireConnection;366;1;365;0
WireConnection;362;0;361;0
WireConnection;363;0;362;1
WireConnection;39;0;218;0
ASEEND*/
//CHKSM=857912120F7986D0C7CA0EF4FDDA233C11A24DB5