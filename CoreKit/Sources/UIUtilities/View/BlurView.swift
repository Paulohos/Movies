//
//  SwiftUIView.swift
//  
//
//  Created by Paulo Henrique Oliveira Souza on 10/08/24.
//

import SwiftUI

public struct BlurView: View {

    public init() {}

    public var body: some View {
        GeometryReader{ proxy in
            ZStack {
                Rectangle()
               .background(.ultraThinMaterial)
               .blur(radius: .roundedCorderMedium)
               .frame(width: proxy.size.width + 32)
               .padding(.leading, -.paddingMedium)
               .padding(.bottom, -.paddingRegular)
            }
        }
    }
}

#Preview {
    BlurView()
}
