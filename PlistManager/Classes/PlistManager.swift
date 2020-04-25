import AnyCodable

public class PlistManager {
    
    public typealias PlistName = String
    
    private static func plistPath(_ name: PlistName) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("\(name).plist")
    }
    
    private static func createFileIfNeeded(_ path: URL) {
        if !FileManager.default.fileExists(atPath: path.path) {
            let emptyDict = NSDictionary(dictionary: [String: String]())
            emptyDict.write(toFile: path.path, atomically: true)
        }
    }
    
    private static func getPlistContents(for path: URL) -> Result<[String: AnyCodable], Error> {
        createFileIfNeeded(path)
        do {
            let data = try Data(contentsOf: path)
            let decoder = PropertyListDecoder()
            let dict = try decoder.decode([String: AnyCodable].self, from: data)
            return(.success(dict))
        } catch {
            return(.failure(error))
        }
    }
    
    public static func getObject(_ key: String, from plistName: PlistName, handleError: ((Error?) -> Void)? = nil) -> Codable? {
        let path = plistPath(plistName)
        switch getPlistContents(for: path) {
        case .failure(let error):
            handleError?(error)
            return nil
        case .success(let plistContents):
            if let object = plistContents[key]?.value as? Codable {
                handleError?(nil)
                return object
            } else {
                handleError?(NSError()) //TODO: Make this a custom error
                return nil
            }
        }
    }
    
    public static func remove(for key: String, from plistName: PlistName, handleError: ((Error?) -> Void)? = nil) {
        let path = plistPath(plistName)
        switch getPlistContents(for: path) {
        case .failure(let error):
            handleError?(error)
        case .success(var plistContents):
            plistContents.removeValue(forKey: key)
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            do {
                let data = try encoder.encode(plistContents)
                try data.write(to: path)
                handleError?(nil)
            } catch {
                handleError?(error)
            }
        }
    }
    
    public static func saveValue(_ value: Codable, key: String, from plistName: PlistName, handleError: ((Error?) -> Void)? = nil) {
        let path = plistPath(plistName)
        switch getPlistContents(for: path) {
        case .failure(let error):
            handleError?(error)
        case .success(var plistContents):
            plistContents[key] = AnyCodable(value)
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            do {
                let data = try encoder.encode(plistContents)
                try data.write(to: path)
                handleError?(nil)
            } catch {
                handleError?(error)
            }
        }
    }

}
