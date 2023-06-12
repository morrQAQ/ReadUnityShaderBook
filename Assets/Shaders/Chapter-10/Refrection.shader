// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "tongchan/10/refraction"
{
    Properties  
    {
        _Color  ("Color  Tint",  Color)  =  (1,  1,  1,  1)
        _RefractColor  ("Refraction  Color",  Color)  =  (1,  1,  1,  1)
        _RefractAmount  ("Refraction  Amount",  Range(0,  1))  =  1
        _RefractRatio  ("Refraction  Ratio",  Range(0.1,  1))  =  0.5   //透射比
        _Cubemap  ("Refraction  Cubemap",  Cube)  =  "_Skybox"  {}
    }

    SubShader
    {
        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            
            CGPROGRAM
            
            #pragma multi_compile_fwdbase	
            
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            
            struct v2f 
            {
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
                fixed3 worldNormal : TEXCOORD1;
                fixed3 worldViewDir : TEXCOORD2;
                fixed3 worldRefr : TEXCOORD3;
                SHADOW_COORDS(4)
            };

            fixed4 _Color;
            fixed4 _RefrectColor;
            fixed _RefrectAmount;
            fixed _RefractRatio;
            samplerCUBE _Cubemap;

            v2f  vert(appdata  v)  
            {
                v2f  o;
                o.pos  =  UnityObjectToClipPos(v.vertex);
                o.worldNormal  =  UnityObjectToWorldNormal(v.normal);
                o.worldPos  =  mul(unity_ObjectToWorld,  v.vertex).xyz;
                o.worldViewDir  =  UnityWorldSpaceViewDir(o.worldPos);

                //  Compute  the  refract  dir  in  world  space
                o.worldRefr     =     refract(-normalize(o.worldViewDir),     normalize(o.worldNormal),
                _RefractRatio);
                //refreacRatio-入射光线所在介质的折射率和折射光线所在介质的折射率之间的比值，例如如果光是从空气射到玻璃表面，
                // 那么这个参数应该是空气的折射率和玻璃的折射率之间的比值


                TRANSFER_SHADOW(o);

                return  o;
            }

            fixed4  frag(v2f  i)  :  SV_Target  
            {
                fixed3  worldNormal  =  normalize(i.worldNormal);
                fixed3  worldLightDir  =  normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3  worldViewDir  =  normalize(i.worldViewDir);

                fixed3  ambient  =  UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 diffuse = _LightColor0.rgb * _Color.rgb * max(0, dot(worldNormal, worldLightDir));

                //  Use  the  refract  dir  in  world  space  to  access  the  cubemap
                fixed3  refraction  =  texCUBE(_Cubemap,  i.worldRefr).rgb  *  _RefrectColor.rgb;

                UNITY_LIGHT_ATTENUATION(atten,  i,  i.worldPos);

                //  Mix  the  diffuse  color  with  the  refract  color
                fixed3  color  =  ambient  +  lerp(diffuse,  refraction,  _RefrectAmount)  *  atten;

                return  fixed4(color,  1.0);
            }
            ENDCG
        }
    }
    FallBack "Reflective/VertexLit"
}
