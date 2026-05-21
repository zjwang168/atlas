//
//  ImportSheetView.swift
//  atlas
//
//  Created by Zijin Wang on 5/21/26.
//

import SwiftUI

struct ImportSheetView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var importText = ""
    @State private var isProcessing = false
    @State private var processingStep = "Analyzing content..."

    var onImport: (String) -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {

                        header

                        inputCard

                        howItWorks

                        Spacer(minLength: 120)
                    }
                    .padding(22)
                }
                .background(Color(.systemGroupedBackground))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.headline)
                                .foregroundStyle(.black)
                                .frame(width: 38, height: 38)
                                .background(.white)
                                .clipShape(Circle())
                        }
                    }
                }

                VStack {
                    Spacer()

                    Button {
                        startImport()
                    } label: {
                        HStack(spacing: 8) {
                            Text(isProcessing ? "Mapping..." : "Map it")

                            Image(systemName: "arrow.right")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(
                            importText.isEmpty
                            ? Color.gray.opacity(0.2)
                            : Color.black
                        )
                        .foregroundStyle(
                            importText.isEmpty
                            ? .gray
                            : .white
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .disabled(importText.isEmpty || isProcessing)
                    .padding(.horizontal, 22)
                    .padding(.bottom, 22)
                }

                if isProcessing {

                    Color.black.opacity(0.22)
                        .ignoresSafeArea()

                    VStack(spacing: 24) {

                        ProgressView()
                            .scaleEffect(1.2)

                        VStack(spacing: 8) {

                            Text("Atlas is understanding")
                                .font(.headline)

                            Text(processingStep)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(32)
                    .background(.ultraThinMaterial)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 28,
                            style: .continuous
                        )
                    )
                    .shadow(
                        color: .black.opacity(0.12),
                        radius: 24,
                        x: 0,
                        y: 10
                    )
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Add anything")
                .font(.system(size: 34, weight: .bold))

            Text("Paste a link, screenshot, notes, or files. Atlas turns them into structured places.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineSpacing(3)
        }
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 18) {

            TextEditor(text: $importText)
                .frame(height: 180)
                .padding(14)
                .scrollContentBackground(.hidden)
                .background(Color(.secondarySystemBackground))
                .clipShape(
                    RoundedRectangle(cornerRadius: 22)
                )

            HStack(spacing: 18) {

                ImportActionIcon(
                    icon: "link",
                    title: "Link"
                )

                ImportActionIcon(
                    icon: "photo",
                    title: "Image"
                )

                ImportActionIcon(
                    icon: "note.text",
                    title: "Note"
                )

                ImportActionIcon(
                    icon: "paperclip",
                    title: "File"
                )

                Spacer()
            }
        }
        .padding(18)
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 28)
        )
        .shadow(
            color: .black.opacity(0.04),
            radius: 12,
            x: 0,
            y: 6
        )
    }

    private var howItWorks: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("How it works")
                .font(.headline)

            VStack(spacing: 18) {

                HowItWorksRow(
                    number: "1",
                    title: "Add",
                    subtitle: "Paste, upload, or write anything."
                )

                HowItWorksRow(
                    number: "2",
                    title: "Understand",
                    subtitle: "Atlas extracts places, categories, and key details."
                )

                HowItWorksRow(
                    number: "3",
                    title: "Map",
                    subtitle: "See structured places instantly on the map."
                )
            }
            .padding(20)
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 26)
            )
        }
    }

    private func startImport() {

        isProcessing = true

        Task {

            let steps = [
                "Analyzing content...",
                "Extracting places...",
                "Understanding locations...",
                "Building structured map..."
            ]

            for step in steps {

                processingStep = step

                try? await Task.sleep(for: .seconds(0.8))
            }

            onImport(importText)

            dismiss()
        }
    }
}

struct ImportActionIcon: View {

    let icon: String
    let title: String

    var body: some View {

        VStack(spacing: 8) {

            Image(systemName: icon)
                .font(.headline)
                .frame(width: 44, height: 44)
                .background(Color(.secondarySystemBackground))
                .clipShape(Circle())

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct HowItWorksRow: View {

    let number: String
    let title: String
    let subtitle: String

    var body: some View {

        HStack(alignment: .top, spacing: 14) {

            Text(number)
                .font(.caption.bold())
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(.black)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(.subheadline.weight(.semibold))

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }
}

#Preview {
    ImportSheetView { _ in }
}
