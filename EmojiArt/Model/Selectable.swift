//
//  Selectable.swift
//  EmojiArt
//
//  Created by Manu on 27/06/2021.
//

import SwiftUI

struct Selectable: ViewModifier {
    @State var select: Bool
    @State var onTapped: () -> Void
    func body(content: Content) -> some View {
        ZStack {
            if select {
                content.overlay(
                    Rectangle()
                        .fill(Color.clear)
                        .border(Color.red, width: 2.0)
                )
            } else {
                content
            }
        }
        .onTapGesture {
            self.select = !self.select
            onTapped()
        }
    }
}
