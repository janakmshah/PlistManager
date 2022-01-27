public class PlistManager {
    
    public typealias PlistName = String
    
    private static func baseDirectoryPath(_ name: PlistName) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("\(name).plist")
    }
    
    private static func appGroupDirectoryPath(appGroupId: String, name: PlistName) throws -> URL {
        guard let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId) else {
            throw(PlistManagerError.appGroupDirectoryNotFound(appGroupId))
        }
        return path.appendingPathComponent("\(name).plist")
    }
    
    public static func get<T: Codable>(_ type: T.Type,
                                       from plistName: PlistName,
                                       appGroupId: String? = nil) throws -> T? {
        
        let path: URL
        if let appGroupId = appGroupId {
            path = try appGroupDirectoryPath(appGroupId: appGroupId, name: plistName)
        } else {
            path = baseDirectoryPath(plistName)
        }
        
        let data = try Data(contentsOf: path)
        let decoder = PropertyListDecoder()
        let object = try decoder.decode(T.self, from: data)
        return object
    }
    
    public static func save<T: Codable>(_ object: T?,
                                        plistName: PlistName,
                                        appGroupId: String? = nil) throws {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        let path: URL
        if let appGroupId = appGroupId {
            path = try appGroupDirectoryPath(appGroupId: appGroupId, name: plistName)
        } else {
            path = baseDirectoryPath(plistName)
        }
        
        let data = try encoder.encode(object)
        try data.write(to: path)
    }

}

public enum PlistManagerError: Error {
    case appGroupDirectoryNotFound(String)
}

extension PlistManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .appGroupDirectoryNotFound(let appGroupId):
            return NSLocalizedString("Could not find App Group Container with id: \(appGroupId)", comment: "Unable to find App Group Directory")
        }
    }
}
