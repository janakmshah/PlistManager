public class PlistManager {
    
    public typealias PlistName = String
    
    private static func plistPath(_ name: PlistName) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("\(name).plist")
    }
    
    public static func get<T: Codable>(_ type: T.Type, from plistName: PlistName, handleError: ((Error?) -> Void)? = nil) -> T? {
        let path = plistPath(plistName)
        do {
            let data = try Data(contentsOf: path)
            let decoder = PropertyListDecoder()
            let object = try decoder.decode(T.self, from: data)
            handleError?(nil)
            return object
        } catch {
            handleError?(error)
            return nil
        }
    }
    
    public static func save<T: Codable>(_ object: T?, plistName: PlistName, handleError: ((Error?) -> Void)? = nil) {
        let path = plistPath(plistName)
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
            let data = try encoder.encode(object)
            try data.write(to: path)
            handleError?(nil)
        } catch {
            handleError?(error)
        }
    }

}
