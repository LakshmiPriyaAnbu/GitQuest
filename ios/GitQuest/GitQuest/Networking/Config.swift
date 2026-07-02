import Foundation

enum Config {
    private static let overrideKey = "gq_api_base_url"

    /// Resolves the Express server base URL. Simulator defaults to localhost since it shares
    /// the Mac's network stack; a physical device needs the Mac's LAN IP (edit the fallback
    /// below, or set the debug override in Settings while running a Debug build).
    static var apiBaseURL: URL {
        #if DEBUG
        if let override = UserDefaults.standard.string(forKey: overrideKey), let url = URL(string: override) {
            return url
        }
        #endif
        #if targetEnvironment(simulator)
        return URL(string: "http://localhost:3000")!
        #else
        return URL(string: "http://192.168.1.50:3000")!
        #endif
    }

    #if DEBUG
    static func setDebugOverride(_ urlString: String?) {
        if let urlString, !urlString.isEmpty {
            UserDefaults.standard.set(urlString, forKey: overrideKey)
        } else {
            UserDefaults.standard.removeObject(forKey: overrideKey)
        }
    }

    static var debugOverride: String? {
        UserDefaults.standard.string(forKey: overrideKey)
    }
    #endif
}
