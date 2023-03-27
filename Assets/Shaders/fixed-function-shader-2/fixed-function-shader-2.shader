Shader "tongchan/fixed-function-shader-2"
{
    Properties
    {
        _Color ("Diffuse", Color) = (1,1,1,1)
        _Ambient("Ambient",Color) =(0.3,0.3,0.3,0.3)
        _Specular("Specular",Color) =(0.5,0.5,0.5,0.5)
        _Shininess("Shininess",Range(0,10)) =4
        _Emission("Emission",Color)=(1,1,1,1)

        _Alpha("Alpha",Color) =(1,1,1,0.3)

        _MainTex("MainTex",2D)=""
        _SecondaryTex("SecTex",2D)=""

    }
    SubShader
    {

        Tags { "RenderType"="Transparent" }

        pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            // //...
            // //()代表它是一个固定值,[]代表参数值
            // // color(1,1,1,1)

            // color[_Color]

            //...
            Material
            {
                diffuse[_Color]
                ambient[_Ambient]
                specular[_Specular]
                shininess[_Shininess]
                emission[_Emission]
            }

            Lighting on
            SeparateSpecular on

            SetTexture[_MainTex]
            {
                Combine texture * primary double
                //primary 只是顶点光照的颜色 , double 是颜色*2,quad *4
            }

            SetTexture[_SecondaryTex]
            {
                ConstantColor[_Alpha]
                Combine  texture * previous double ,texture * constant
                //要混合两张贴图,可以用previous
            }
        }
    }
}


