//
//  EmptyResponseView.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/5/25.
//

import SwiftUI

struct EmptyResponseView: View {
    @State private var rotateImage = false
    @State private var rotationAngle: Double = 0

    let action: () -> Void

    var body: some View {
        ZStack {
            Image(.lonely)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("It's so lonely here...")
                    .font(.headline)
                    .accessibilityAddTraits(.isStaticText)

                Text("Maybe you can try refreshing the view")
                    .font(.subheadline)
                    .accessibilityAddTraits(.isStaticText)

                Button {
                    action()
                    rotateImage.toggle()
                    withAnimation(.easeInOut(duration: 0.8)) {
                        rotationAngle += 360
                    }
                    rotationAngle = rotateImage ? 360 : 0
                } label: {
                    buttonLabel()
                }
                .accessibilityAddTraits(.isButton)

                Spacer()
            }
            .padding(.top, 100)
            .foregroundStyle(.black)
        }
    }

    private func buttonLabel() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 200, height: 50)
                .foregroundStyle(.blue)
            HStack {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
                    .rotationEffect(Angle(degrees: rotationAngle))
                    .accessibilityAddTraits(.isImage)

                Text("Refresh")
                    .accessibilityAddTraits(.isStaticText)
            }
            .bold()
            .foregroundStyle(.white)
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 16)
    }
}

#if DEBUG
#Preview {
    EmptyResponseView(action: {})
}
#endif
