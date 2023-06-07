/// annotate to avoid shader error

Shader "tongchan/fundamental-of-deferred-render"
{
    // Pass  1  
    // {
        //     // 第一个Pass不迚行真正的光照计算
        //     // 仅仅把光照计算需要的信息存储到G缓冲中

        //     for  (each  primitive  in  this  model)  {

            //         for  (each  fragment  covered  by  this  primitive)  {
                //             if  (failed  in  depth  test)  {
                    //                 // 如果没有通过深度测试，说明该片元是不可见的
                    //                 discard;
                    //                 }  else  {
                    //                 // 如果该片元可见
                    //                 // 就把需要的信息存储到G缓冲中
                    //                 writeGBuffer(materialInfo,  pos,  normal,  lightDir,  viewDir);
                //             }
            //         }
        //     }
    // }

    // Pass  2  
    // {
        //     // 利用G缓冲中的信息迚行真正的光照计算

        //     for  (each  pixel  in  the  screen)  {
            //         if  (the  pixel  is  valid)  {
                //             // 如果该像素是有效的
                //             // 读取它对应的G缓冲中的信息
                //             readGBuffer(pixel,  materialInfo,  pos,  normal,  lightDir,  viewDir);

                //             // 根据读取到的信息迚行光照计算
                //             float4  color  =  Shading(materialInfo,  pos,  normal,  lightDir,  viewDir);
                //             // 更新帧缓冲
                //             writeFrameBuffer(pixel,  color);
            //         }
        //     }
    // }
}


//前向渲染的翻译好信达雅