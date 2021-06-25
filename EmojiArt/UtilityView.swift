//
//  UtilityView.swift
//  EmojiArt
//
//  Created by Manu on 23/06/2021.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        if let uiImage = uiImage {
            Image(uiImage: uiImage)
        }
    }
}
