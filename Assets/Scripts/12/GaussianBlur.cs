using System;
using UnityEngine;

public class GaussianBlur : PostEffectsBase
{
    public GaussianBlurEdition edition;
    public GaussianBlurSettings settings;

    protected override void ApplySettings(RenderTexture src, RenderTexture dest)
    {
        Blur(edition, src, dest);
    }

    void Blur(GaussianBlurEdition edition, RenderTexture src, RenderTexture dest)
    {
        switch (edition)
        {
            case GaussianBlurEdition.BASE:
                Base(src, dest);
                break;
            case GaussianBlurEdition.INVOLVED_EDITION:
                Evolved(src, dest);
                break;
            case GaussianBlurEdition.FINAL_EDITION:
                Final(src, dest);
                break;
        }
    }

    void Base(RenderTexture src, RenderTexture dest)
    {
        int rtW = src.width;
        int rtH = src.height;
        //GetTemporary(int width, int height, int depthBuffer = 0)————单位:像素
        RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);

        //This method copies pixel data from a texture on the GPU to a render texture on the GPU. 
        // This is one of the fastest ways to copy a texture.
        //https://docs.unity3d.com/ScriptReference/Graphics.Blit.html
        //  Render  the  vertical  pass
        //  unity 先把src 给到 material 的 maintex上
        // 然后将这个用这个material渲染buffer
        Graphics.Blit(src, buffer, material, 0);
        //  Render  the  horizontal  pass
        Graphics.Blit(buffer, dest, material, 1);

        RenderTexture.ReleaseTemporary(buffer);

    }

    void Evolved(RenderTexture src, RenderTexture dest)
    {
        int rtW = src.width / settings.downSample;
        int rtH = src.height / settings.downSample;
        RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);
        buffer.filterMode = FilterMode.Bilinear;

        //  Render  the  vertical  pass
        Graphics.Blit(src, buffer, material, 0);
        //  Render  the  horizontal  pass
        Graphics.Blit(buffer, dest, material, 1);

        RenderTexture.ReleaseTemporary(buffer);

    }

    void Final(RenderTexture src, RenderTexture dest)
    {
        int rtW = src.width / settings.downSample;
        int rtH = src.height / settings.downSample;

        RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
        buffer0.filterMode = FilterMode.Bilinear;

        Graphics.Blit(src, buffer0);

        for (int i = 0; i < settings.iterations; i++)
        {
            material.SetFloat("_BlurSize", 1.0f + i * settings.blurSpread);

            RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);

            //  Render  the  vertical  pass
            Graphics.Blit(buffer0, buffer1, material, 0);

            RenderTexture.ReleaseTemporary(buffer0);
            buffer0 = buffer1;
            buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);

            //  Render  the  horizontal  pass
            Graphics.Blit(buffer0, buffer1, material, 1);

            RenderTexture.ReleaseTemporary(buffer0);
            buffer0 = buffer1;
        }

        Graphics.Blit(buffer0, dest);
        RenderTexture.ReleaseTemporary(buffer0);
    }
}

[Serializable]
public class GaussianBlurSettings
{
    [Range(1, 8)]
    public int downSample = 2;

    //  Blur  iterations  -  larger  number  means  more  blur.
    [Range(0, 4)]
    public int iterations = 3;

    //  Blur  spread  for  each  iteration  -  larger  value  means  more  blur
    [Range(0.2f, 3.0f)]
    public float blurSpread = 0.6f;
}

public enum GaussianBlurEdition
{
    BASE,
    INVOLVED_EDITION,
    FINAL_EDITION
}
