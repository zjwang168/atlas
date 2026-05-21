//
//  BottomActionBar.swift
//  atlas
//
//  Created by Zijin Wang on 5/18/26.
//

import SwiftUI

struct BottomActionBar: View {
    let onTapImport: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button {
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundStyle(.black)
                    .frame(width: 56, height: 56)
                    .background(.white.opacity(0.92))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.08), radius: 10)
            }

            HStack(spacing: 8) {
                Text("Ask, search, or make anything...")
                    .font(.subheadline)
                    .foregroundStyle(.gray.opacity(0.75))
                    .lineLimit(1)

                Spacer()

                Image(systemName: "mic")
                    .font(.subheadline)
                    .foregroundStyle(.gray.opacity(0.8))
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
            .background(.white.opacity(0.92))
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.06), radius: 8)

            Button {
                onTapImport()
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundStyle(.black)
                    .frame(width: 56, height: 56)
                    .background(.white.opacity(0.92))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.08), radius: 10)
            }
        }
    }
}

#Preview {
    BottomActionBar {
    }
}
