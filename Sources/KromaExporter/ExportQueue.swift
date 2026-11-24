import Foundation
import Observation

/// Exportní fronta na pozadí: uživatel pracuje dál, exporty běží
/// v nízce prioritních vláknech (qualityOfService .background).
@MainActor
@Observable
public final class ExportQueue {
    public private(set) var jobs: [ExportJob] = []

    private let queue = OperationQueue()

    public init() {
        queue.qualityOfService = .background
        queue.maxConcurrentOperationCount = 1
    }

    public func enqueue(_ job: ExportJob) {
        jobs.append(job)
    }

    public func remove(_ id: UUID) {
        jobs.removeAll { $0.id == id }
    }

    public func clearFinished() {
        jobs.removeAll { $0.status == .done || $0.status == .failed }
    }
}
