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
    @Published var backgroundImageFetchStatus: BackgroundImageFetchStatus = .idle
    
    enum BackgroundImageFetchStatus {
        case idle
        case fetching
    }
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .url(let url):
            // fetch the URL
            backgroundImageFetchStatus = .fetching
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = try? Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    if self?.emojiArt.background == EmojiArt.Background.url(url) {
                        self?.backgroundImageFetchStatus = .idle
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
    
    func setBackground(_ background: EmojiArt.Background) {
        emojiArt.background = background
        print("setting background from: \(background)")
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat ) {
        emojiArt.addEmoji(emoji, at: (location.x, location.y), size: Int(size))
    }
    
    func removeEmoji(_ emoji: EmojiArt.Emoji) {
        emojiArt.removeEmoji(emoji)
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
