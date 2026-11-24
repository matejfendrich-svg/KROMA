#include <metal_stdlib>
using namespace metal;

// Základní korekce expozice v lineárním prostoru: rgb * 2^ev.
kernel void exposure(texture2d<float, access::read> source [[texture(0)]],
                     texture2d<float, access::write> destination [[texture(1)]],
                     constant float& ev [[buffer(0)]],
                     uint2 gid [[thread_position_in_grid]]) {
    if (gid.x >= source.get_width() || gid.y >= source.get_height()) {
        return;
    }
    float4 color = source.read(gid);
    float scale = pow(2.0f, ev);
    destination.write(float4(color.rgb * scale, color.a), gid);
}
