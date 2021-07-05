//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Manuel Lorenzo (@noloman) on 02/07/2021.
//

import SwiftUI

struct PaletteChooser: View {
    var emojiFontSize: CGFloat = 40
    var emojiFont: Font {
        .system(size: emojiFontSize)
    }
    @EnvironmentObject var store: PaletteStore
    @State private var chosenPaletteIndex = 0
    
    var body: some View {
        HStack {
            paletteControlButton
            body(for: store.palette(at: chosenPaletteIndex))
        }.clipped()
    }
    
    var paletteControlButton: some View {
        Button {
            chosenPaletteIndex = (chosenPaletteIndex + 1) % store.palettes.count
        } label : {
            Image(systemName: "paintpalette")
        }
        .font(emojiFont)
        .contextMenu { contextMenu }
    }
    
    @ViewBuilder
    var contextMenu: some View {
        AnimatedActionButton(title: "New", systemImage: "plus") {
            store.insertPalette(named: "New", emojis: "", at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "Delete", systemImage: "minus.circle") {
            chosenPaletteIndex = store.removePalette(at: chosenPaletteIndex)
        }
        goToMenu
    }
    
    var goToMenu: some View {
        Menu {
            ForEach(store.palettes) { palette in
                AnimatedActionButton(title: palette.name) {
                    if let index = store.palettes.index(matching: palette) {
                        chosenPaletteIndex = index
                    }
                }
            }
        } label: {
            Label("Go To", systemImage: "text.insert")
        }
    }
    
    var rollTransition: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .offset(x: 0, y: emojiFontSize),
            removal: .offset(x: 0, y: -emojiFontSize)
        )
    }
    
    func body(for palette: Palette) -> some View {
        print("Palette with id \(palette.id)")
        return HStack {
            Text(palette.name)
            ScrollingEmojisView(emojis: palette.emojis)
                .font(.system(size: emojiFontSize))
        }
        .id(palette.id)
        .transition(rollTransition)
    }
}
