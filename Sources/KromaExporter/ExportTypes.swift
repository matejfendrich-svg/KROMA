import Foundation
import KromaCore

public enum PhotoExportFormat: String, Codable, Sendable, CaseIterable {
    case jpeg
    case png
    case tiff
    case heic
    case webp
}

public enum VideoContainer: String, Codable, Sendable, CaseIterable {
    case mp4
    case mov
}

public enum VideoCodec: String, Codable, Sendable, CaseIterable {
    case h264
    case hevc10bit
    case prores422
    case prores4444
}

public enum AnimationFormat: String, Codable, Sendable, CaseIterable {
    case gif
    case webp
    case mp4
}

public enum ExportKind: Sendable {
    case photo(PhotoExportFormat)
    case video(VideoContainer, VideoCodec)
    case animation(AnimationFormat)
}

public enum JobStatus: String, Codable, Sendable {
    case pending
    case running
    case done
    case failed
}

/// Jedna exportní úloha ve frontě.
public struct ExportJob: Identifiable, Sendable {
    public let id: UUID
    public var mediaID: UUID?
    public var kind: ExportKind
    public var destination: URL
    public var status: JobStatus

    public init(id: UUID = UUID(), mediaID: UUID? = nil, kind: ExportKind, destination: URL, status: JobStatus = .pending) {
        self.id = id
        self.mediaID = mediaID
        self.kind = kind
        self.destination = destination
        self.status = status
    }
}
