// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//为啥叫广告牌?
Shader "tongchan/11/billboard"
{
    Properties  
    {
        _MainTex  ("Main  Tex",  2D)  =  "white"  {}
        _Color  ("Color  Tint",  Color)  =  (1,  1,  1,  1)
        _VerticalBillboarding  ("Vertical  Restraints",  Range(0,  1))  =  1
    }

    SubShader  
    {
        //  Need  to  disable  batching  because  of  the  vertex  animation
        Tags   
        {
            "Queue"="Transparent"   
            "IgnoreProjector"="True"   
            "RenderType"="Transparent"
            "DisableBatching"="True"
        }

        Pass 
        {
            Tags  {  "LightMode"="ForwardBase"  }

            ZWrite  Off
            Blend  SrcAlpha  OneMinusSrcAlpha
            Cull  Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv:TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            fixed _VerticalBillboarding;

            v2f vert(appdata v)
            {
                //  Suppose  the  center  in  object  space  is  fixed
                float3  center  =  float3(0,  0,  0);
                float3  viewer  =  mul(unity_WorldToObject, float4(_WorldSpaceCameraPos,  1));

                float3  normalDir  =  viewer  -  center;
                //  If  _VerticalBillboarding  equals  1,  we  use  the  desired  view  dir  as  the  normal  dir
                //  Which  means  the  normal  dir  is  fixed
                //  Or  if  _VerticalBillboarding  equals  0,  the  y  of  normal  is  0
                //  Which  means  the  up  dir  is  fixed
                normalDir.y  =normalDir.y  *  _VerticalBillboarding;
                normalDir  =  normalize(normalDir);

                //  Get  the  approximate  up  dir
                //  If  normal  dir  is  already  towards  up,  then  the  up  dir  is  towards  front
                float3  upDir  =  abs(normalDir.y)  >  0.999  ?  float3(0,  0,  1)  :  float3(0,  1,  0);
                float3  rightDir  =  normalize(cross(upDir,  normalDir));
                upDir  =  normalize(cross(normalDir,  rightDir));

                float3  centerOffs  =  v.vertex.xyz  -  center;
                float3 localPos = center + rightDir * centerOffs.x + upDir * centerOffs.y + normalDir.z
                *  centerOffs.z;

                v2f o;
                o.pos  =  UnityObjectToClipPos(float4(localPos,  1));
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);

                return o;
            }


            fixed4  frag  (v2f  i)  :  SV_Target  
            {
                fixed4  c  =  tex2D  (_MainTex,  i.uv);
                c.rgb  *=  _Color.rgb;

                return  c;
            }
            ENDCG
        }
    }
    Fallback  "Transparent/VertexLit"
}