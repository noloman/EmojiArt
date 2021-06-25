//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Manuel Lorenzo (@noloman) on 18/06/2021.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    @Published private(set) var emojiArt: EmojiArt {
        didSet {
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    init() {
        emojiArt = EmojiArt()
        emojiArt.addEmoji("👍", at: (100, 200), size: 40)
        emojiArt.addEmoji("🎱", at: (100, 300), size: 30)
    }
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    var background: EmojiArt.Background { emojiArt.background }
    
    @Published var backgroundImage: UIImage?
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .url(let url):
            // fetch the URL
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = try? Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    if self?.emojiArt.background == EmojiArt.Background.url(url) {
                        if let retrievedImageData = imageData {
                            self?.backgroundImage = UIImage(data: retrievedImageData)
                        }
                    }
                }
            }
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }
    
    // MARK: - Intent(s)
    
    func setBackground(_ backrgound: EmojiArt.Background) {
        emojiArt.background = background
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat ) {
        emojiArt.addEmoji(emoji, at: (location.x, location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
}
