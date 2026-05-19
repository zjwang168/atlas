//
//  PlaceRow.swift
//  atlas
//
//  Created by Zijin Wang on 5/18/26.
//

import SwiftUI

struct PlaceRow: View {
    let place: Place

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(place.name)
                    .font(.headline)

                Text(place.summary)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)

                HStack {
                    ForEach(place.tags.prefix(2), id: \.self) { tag in
                        Text("\(tag)  ›")
                    }
                }
                .font(.caption)
                .padding(.top, 6)
            }

            Spacer()

            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.18))
                .frame(width: 82, height: 82)
        }
        .padding(.bottom, 14)
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.12))
        }
    }
}
