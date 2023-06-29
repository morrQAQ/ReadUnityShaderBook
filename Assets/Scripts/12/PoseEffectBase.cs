using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public abstract class PostEffectsBase : MonoBehaviour
{
    [SerializeField]
    protected Shader shader;

    [SerializeField]
    protected Material material;

    public Material Material => CheckShaderAndCreateMaterial(shader, material);

    //  Caution: CheckSupport always returns true ,no need to call it .
    //  Called  in  CheckResources  to  check  support  on  this  platform
    // protected bool CheckSupport()
    // {
    //     //[Obsolete("supportsImageEffects always returns true, no need to call it")]
    //     // Debug.LogWarning("This   platform   does   not   support   image   effects   or   render textures.");
    //     // return SystemInfo.supportsImageEffects || SystemInfo.supportsRenderTextures;
    // }

    protected abstract void ApplySettings(RenderTexture src, RenderTexture dest);

    protected void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (Material != null)
            ApplySettings(src, dest);
        else
            Graphics.Blit(src, dest);
    }

    /// <summary>
    /// Called  when  need  to  create  the  material  used  by  this  effect
    /// </summary>
    protected Material CheckShaderAndCreateMaterial(Shader shader, Material material)
    {
        if (!shader || !shader.isSupported) return null;    //shader check
        if (material && material.shader != shader) return null;    //mat check

        return material ??= Creat();

        Material Creat()
        {
            //TODO why???????????????????????????????????????????????

            //https://stackoverflow.com/questions/40676426/what-is-the-difference-between-x-is-null-and-x-null
            // is null checks if the variable or object is of a nullable type and has a value of null.
            // == null compares the variable or object to the literal value of null.

            //false true true null
            Debug.Log((material is null) + "-- " + (material == null) + (material.Equals(null)) + (material));
            material = new Material(shader);
            material.hideFlags = HideFlags.DontSave;
            return material;
        }
    }
}


