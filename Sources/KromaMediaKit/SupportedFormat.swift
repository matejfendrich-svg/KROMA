import Foundation
import KromaCore

/// Podporované formáty importu (kapitola 4.1 specifikace).
public enum SupportedFormat: String, CaseIterable, Sendable {
    case jpeg
    case heic
    case png
    case tiff
    case webp
    case gif
    case cr3
    case nef
    case arw
    case raf
    case dng
    case orf
    case mp4
    case mov

    public var fileExtensions: [String] {
        switch self {
        case .jpeg: return ["jpg", "jpeg"]
        case .heic: return ["heic"]
        case .png: return ["png"]
        case .tiff: return ["tif", "tiff"]
        case .webp: return ["webp"]
        case .gif: return ["gif"]
        case .cr3: return ["cr3"]
        case .nef: return ["nef"]
        case .arw: return ["arw"]
        case .raf: return ["raf"]
        case .dng: return ["dng"]
        case .orf: return ["orf"]
        case .mp4: return ["mp4", "m4v"]
        case .mov: return ["mov"]
        }
    }

    public var isRAW: Bool {
        switch self {
        case .cr3, .nef, .arw, .raf, .dng, .orf: return true
        default: return false
        }
    }

    public var kind: MediaKind {
        switch self {
        case .mp4, .mov: return .video
        default: return .photo
        }
    }

    public static func format(for url: URL) -> SupportedFormat? {
        let ext = url.pathExtension.lowercased()
        return allCases.first { $0.fileExtensions.contains(ext) }
    }

    public static func isSupported(url: URL) -> Bool {
        format(for: url) != nil
    }
}
