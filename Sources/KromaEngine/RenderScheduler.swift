import Foundation

/// Plánovač renderu. Engine je oddělen od UI, aby headless render
/// (testy, exportní fronta) běžel bez spuštění UI.
public protocol RenderScheduler: Sendable {
    func render(_ request: RenderRequest) async throws -> RenderResult
}
