// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "tongchan/11/animated-vertex-shader"
{
    Properties  
    {
        _MainTex  ("Main  Tex",  2D)  =  "white"  {}
        _Color  ("Color  Tint",  Color)  =  (1,  1,  1,  1)
        _Magnitude  ("Distortion  Magnitude",  Float)  =  1
        _Frequency  ("Distortion  Frequency",  Float)  =  1
        _InvWaveLength  ("Distortion  Inverse  Wave  Length",  Float)  =  10
        _Speed  ("Speed",  Float)  =  0.5
    }

    SubShader  
    {
        //TODO test for editor batching influence this ?
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos :SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4  _Color;
            float _Magnitude;
            float _Frequency;
            float _InvWaveLength;
            float _Speed;

            v2f  vert(appdata  v)  
            {
                v2f  o;

                float4  offset;
                offset.yzw  =  float3(0.0,  0.0,  0.0);

                if(v.vertex.x >0)
                {
                    offset.x  =  sin(_Frequency  *  _Time.y  +  v.vertex.x  *  _InvWaveLength  +  v.vertex.y  *
                    _InvWaveLength  +  v.vertex.z  *  _InvWaveLength)  *  _Magnitude;
                }
                else
                {
                    offset.x  =  cos(_Frequency  *  _Time.y  +  v.vertex.x  *  _InvWaveLength  +  v.vertex.y  *
                    _InvWaveLength  +  v.vertex.z  *  _InvWaveLength)  *  _Magnitude;
                }

                // offset.y  = offset.x *0.3;

                o.pos  =  UnityObjectToClipPos(v.vertex  +  offset);
                o.uv  =  TRANSFORM_TEX(v.texcoord,  _MainTex);
                o.uv  +=   float2(0.0,  _Time.y  *  _Speed);

                return  o;
            }

            fixed4  frag(v2f  i)  :  SV_Target  
            {
                fixed4  c  =  tex2D(_MainTex,  i.uv);
                c.rgb  *=  _Color.rgb;

                return  c;
            }
            ENDCG
        }
    }
    Fallback  "Transparent/VertexLit"
}
