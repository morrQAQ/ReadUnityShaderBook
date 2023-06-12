// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "tongchan/10/mirror"
{
    Properties  
    {
        _MainTex  ("Main  Tex",  2D)  =  "white"  {}
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;

            v2f  vert(appdata  v)  
            {
                v2f  o;
                o.pos  =  UnityObjectToClipPos(v.vertex);
                o.uv  =  v.texcoord;
                //  Mirror  needs  to  filp  x
                o.uv.x  =  1  -  o.uv.x;
                return  o;
            }

            fixed4  frag(v2f  i)  :  SV_Target 
            {
                return  tex2D(_MainTex,  i.uv);
            }

            ENDCG
        }
    }
}
