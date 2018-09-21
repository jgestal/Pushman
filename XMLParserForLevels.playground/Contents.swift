import UIKit

let fileManager = FileManager.default
let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]



class World: Codable {
    var id: Int?
    var title: String?
    var description: String?
    var email: String?
    var url: String?
    var author: String?
    var maxWidth : String?
    var maxHeight : String?
    var levels = [LevelMap]()
    
    func log() {
        if let title = title {
            print("Title: \(title)")
        }
        if let description = description {
            print("Description: \(description)")
        }
        if let email = email {
            print("Email: \(email)")
        }
        if let url = url {
            print("Url: \(url)")
        }
        if let author = author {
            print("Author: \(author)")
        }
        if let maxWidth = maxWidth {
            print("Max Width: \(maxWidth)")
        }
        if let maxHeight = maxHeight {
            print("Max Height: \(maxHeight)")
        }
        levels.forEach {
            $0.log()
        }
    }
}

class LevelMap: Codable {
    var id: Int?
    var name: String?
    var width: String?
    var height: String?
    var levelMap = ""
    func log() {
        if let name = name {
            print("- Level Name: \(name)")
        }
        if let width = width {
            print("- Level Width: \(width)")
        }
        if let height = height {
            print("- Level Height: \(height)")
        }
        print("- Level Map: \(levelMap)")
    }
}

var worlds = [World]()

var id = 0
var levelID = 0
var levelCount = 0

class Parser: NSObject, XMLParserDelegate {
    
    var xmlParser: XMLParser!
    var currentElement = ""
    var foundCharacters = ""
    var currentData = [String:String]()
    var parsedData = [[String:String]]()
    var isHeader = true
    
    var currentWorld : World!
    var currentLevel: LevelMap!

    func parseLevelPack(url: URL) {
        let xmlParser = XMLParser(contentsOf: url)
        xmlParser?.delegate = self
        if (xmlParser?.parse()) != nil {
            currentWorld = World()
            parsedData.append(currentData)
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        foundCharacters = ""
        
        if elementName == "LevelCollection" {
            currentWorld.author = attributeDict["Copyright"]
            currentWorld.maxWidth = attributeDict["MaxWidth"]
            currentWorld.maxHeight = attributeDict["MaxHeight"]
            currentWorld.id = id
            id += 1
            levelID = 0
        }
        
        else if elementName == "Level" {
            currentLevel = LevelMap()
            currentLevel.width = attributeDict["Width"]
            currentLevel.height = attributeDict["Height"]
            currentLevel.name = attributeDict["Id"]
            currentLevel.id = levelID
            levelID += 1
            levelCount += 1
        }
   }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "Title" {
            currentWorld.title = foundCharacters
        } else if elementName == "Description" {
            currentWorld.description = foundCharacters.replacingOccurrences(of: "\n", with: " ")
        } else if elementName == "Email" {
            currentWorld.email = foundCharacters
        } else if elementName == "Url" {
            currentWorld.url = foundCharacters
        }
        
        else if elementName == "Level" {
            currentWorld.levels.append(currentLevel)
        }
        
        else if elementName == "L" {
            let levelMapLine = foundCharacters.replacingOccurrences(of: " ", with: "-")
            if currentLevel.levelMap == "" {
                currentLevel.levelMap = levelMapLine
            } else {
                currentLevel.levelMap = currentLevel.levelMap + "|" + levelMapLine
            }
        }
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Start Document")
        currentWorld = World()
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("End Document")
        worlds.append(currentWorld)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        foundCharacters += string
    }
}

let parser = Parser()
var slcFiles = [URL]()
do {
    let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
    print(documentsURL)
    fileURLs.forEach {
        if $0.description.hasSuffix(".slc") {
            slcFiles.append($0)
        }
    }
} catch {
    print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
}

slcFiles.forEach {
    print("Parsing file: \($0)")
    parser.parseLevelPack(url: $0)
}

if let encodedData = try? JSONEncoder().encode(worlds) {
    let encodedString = String(data: encodedData, encoding: .utf8)!
    print(encodedString)
    let file = "output.txt"
    let text =  encodedString
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(file)
        print(fileURL)
        //writing
        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
    }
}

print("Levels: \(levelCount)")
//5430 // 48 Packs






