Shader "tongchan/fixed-function-shader-1"
{
    Properties
    {
        _Color ("Diffuse", Color) = (1,1,1,1)
        _Ambient("Ambient",Color) =(0.3,0.3,0.3,0.3)
        _Specular("Specular",Color) =(0.5,0.5,0.5,0.5)
        _Shininess("Shininess",Range(0,10)) =4
        _Emission("Emission",Color)=(1,1,1,1)

    }
    SubShader
    {
        pass
        {
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
        }
    }
}
