import AnyCodable

public class PlistManager {
    
    private static let documentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    public static func get<T:Codable>(_ type: T.Type) throws -> T {
        let path: URL = documentsDirectory.appendingPathComponent("\(String(describing: type.self)).plist")
        writeFileIfNeeded(path)
        do {
            let data = try Data(contentsOf: path)
            let decoder = PropertyListDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
    public static func save<T:Codable>(_ value: T) throws {
        let path: URL = documentsDirectory.appendingPathComponent("\(String(describing: T.self)).plist")
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
          let data = try encoder.encode(value)
          try data.write(to: path)
        } catch {
          throw error
        }
    }
    
    private static func writeFileIfNeeded(_ path: URL) {
        if !FileManager.default.fileExists(atPath: path.path) {
            let emptyDict = NSDictionary(dictionary: [String: String]())
            let isWritten = emptyDict.write(toFile: path.path, atomically: true)
            print("is the file created: \(isWritten)")
        } else {
            print("file exists")
        }
    }

}
