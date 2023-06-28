using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeDetection : PostEffectsBase
{
    public EdgeDetectionSettings settings;

    protected override void ApplySettings()
    {
        Material.SetFloat("_EdgeOnly", settings.edgesOnly);
        Material.SetColor("_EdgeColor", settings.edgeColor);
        Material.SetColor("_BackgroundColor", settings.backgroundColor);
    }
}


[System.Serializable]
public class EdgeDetectionSettings
{
    [Range(0.0f, 1.0f)]
    public float edgesOnly = 0.0f;

    public Color edgeColor = Color.black;

    public Color backgroundColor = Color.white;
}