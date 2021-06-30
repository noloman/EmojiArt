//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Manuel Lorenzo (@noloman) on 18/06/2021.
//

import Foundation

struct EmojiArt: Codable {
    var background = Background.blank
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable, Hashable, Codable {
        let text: String
        var x: Int
        var y: Int
        var size: Int
        var id: Int
        
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    init(from json: Data) throws {
        self = try JSONDecoder().decode(EmojiArt.self, from: json)
    }
    
    init(url: URL) throws {
        // This is blocking but as long as we're loading such small amount of data, it should be fine. Otherwise it'd be more cumbersome to make it async
        let data = try Data(contentsOf: url)
        self = try EmojiArt(from: data)
    }
    
    init() { }
    
    private var uniqueEmojiId = 0
    
    func json() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id: uniqueEmojiId))
    }
    
    mutating func removeEmoji(_ emoji: Emoji) {
        emojis.remove(object: emoji)
    }
}

extension Array where Element : Equatable {
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else { return }
        remove(at: index)
    }
}
