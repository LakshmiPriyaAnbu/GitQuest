import Foundation

enum GitQuestAPIError: Error, LocalizedError {
    case transport(Error)
    case decoding(Error)
    case notFound(String)
    case upstreamError(String)

    var errorDescription: String? {
        switch self {
        case .transport: return "Connection problem — check the server is running and try again."
        case .decoding: return "Received an unexpected response from the server."
        case .notFound(let message): return message
        case .upstreamError(let message): return message
        }
    }
}
