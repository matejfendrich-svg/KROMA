import Metal

/// Sdílený Metal kontext aplikace.
public final class MetalContext: @unchecked Sendable {
    public static let shared = MetalContext()

    public let device: MTLDevice?
    public let commandQueue: MTLCommandQueue?

    private init() {
        device = MTLCreateSystemDefaultDevice()
        commandQueue = device?.makeCommandQueue()
    }

    public var isGPUAvailable: Bool { device != nil }
}
