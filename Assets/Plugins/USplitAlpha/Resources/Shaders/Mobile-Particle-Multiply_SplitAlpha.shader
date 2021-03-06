﻿Shader "SplitAlpha/Mobile/Particles/Multiply" {
Properties {
    _MainTex ("Particle Texture", 2D) = "white" {}
    _AlphaTex ("External Alpha", 2D) = "white" {}
}

Category {
    Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
    Blend Zero SrcColor
    Cull Off Lighting Off ZWrite Off Fog { Color (1,1,1,1) }
    
    BindChannels {
        Bind "Color", color
        Bind "Vertex", vertex
        Bind "TexCoord", texcoord
    }
    
    SubShader
    {
        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _AlphaTex;

            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            v2f vert(appdata_t v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord;
                o.color = v.color;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 c = tex2D (_MainTex, i.texcoord);
                fixed4 alpha = tex2D (_AlphaTex, i.texcoord);
                c.a = alpha.r;
                c *= i.color;

                c = lerp(half4(1,1,1,1), c, c.a);

                return c;
            }

            ENDCG
        }
    }
}
}
