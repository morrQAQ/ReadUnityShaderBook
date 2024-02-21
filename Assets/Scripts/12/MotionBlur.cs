using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionBlur : PostEffectsBase
{
    RenderTexture accumulationTexture;
    [SerializeField] MotionBlurSettings motionBlurSettings;


    protected override void ApplySettings(RenderTexture src, RenderTexture dest)
    {
        if (accumulationTexture == null || accumulationTexture.width != src.width ||
     accumulationTexture.height != src.height)
        {
            DestroyImmediate(accumulationTexture);
            accumulationTexture = new RenderTexture(src.width, src.height, 0);
            accumulationTexture.hideFlags = HideFlags.HideAndDontSave;
            Graphics.Blit(src, accumulationTexture);
        }

        material.SetFloat("_BlurAmount", 1.0f - motionBlurSettings.blurAmount);

        Graphics.Blit(src, accumulationTexture, material);
        Graphics.Blit(accumulationTexture, dest);
    }

    void OnDisable()
    {
        DestroyImmediate(accumulationTexture);
    }
}

[Serializable]
public class MotionBlurSettings
{
    [Range(0.0f, 0.9f)]
    public float blurAmount = 0.5f;
}

