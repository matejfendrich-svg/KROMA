#include <metal_stdlib>
using namespace metal;

kernel void passthrough(texture2d<float, access::read> source [[texture(0)]],
                        texture2d<float, access::write> destination [[texture(1)]],
                        uint2 gid [[thread_position_in_grid]]) {
    if (gid.x >= source.get_width() || gid.y >= source.get_height()) {
        return;
    }
    float4 color = source.read(gid);
    destination.write(color, gid);
}
