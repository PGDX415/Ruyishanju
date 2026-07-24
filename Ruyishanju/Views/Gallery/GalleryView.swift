//
//  GalleryView.swift
//  Ruyishanju
//
//  图库 — 20张实景效果图沉浸式浏览
//

import SwiftUI

struct GalleryView: View {
    @State private var selectedImage: MediaHelper.GalleryPhoto? = nil
    @State private var showVideo = false

    var body: some View {
        NavigationStack {
            ScrollView {
                // 宣传片入口
                VideoThumbnailCard(
                    title: "项目宣传片",
                    duration: "约 2 分钟",
                    action: { showVideo = true }
                )
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 4)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ],
                    spacing: 10
                ) {
                    ForEach(MediaHelper.GalleryPhoto.allCases) { photo in
                        Button {
                            selectedImage = photo
                        } label: {
                            VStack(spacing: 0) {
                                photo.image
                                    .resizable()
                                    .aspectRatio(photo.rawValue.contains("pano") ? 2 : 4/3, contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(height: photo.rawValue.contains("pano") ? 100 : 140)
                                    .clipped()

                                Text(photo.displayName)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(AppTheme.textPrimary)
                                    .padding(.vertical, 8)
                            }
                            .background(AppTheme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .background(AppTheme.background)
            .navigationTitle("实景图库")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedImage) { photo in
                let index = MediaHelper.GalleryPhoto.allCases.firstIndex(of: photo) ?? 0
                FullScreenImageView(
                    image: photo.image,
                    title: photo.displayName,
                    allPhotos: MediaHelper.GalleryPhoto.allCases,
                    initialIndex: index
                )
            }
            .fullScreenCover(isPresented: $showVideo) {
                VideoPlayerView(videoName: "promo")
            }
        }
    }
}

// MARK: - 全屏滑动图片浏览

struct FullScreenImageView: View {
    let image: Image
    let title: String
    let allPhotos: [MediaHelper.GalleryPhoto]
    let initialIndex: Int

    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex: Int
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    init(image: Image, title: String, allPhotos: [MediaHelper.GalleryPhoto], initialIndex: Int) {
        self.image = image
        self.title = title
        self.allPhotos = allPhotos
        self.initialIndex = initialIndex
        self._currentIndex = State(initialValue: initialIndex)
    }

    var body: some View {
        NavigationStack {
            TabView(selection: $currentIndex) {
                ForEach(allPhotos.indices, id: \.self) { index in
                    allPhotos[index].image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(scale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = lastScale * value
                                }
                                .onEnded { _ in
                                    withAnimation { scale = min(max(scale, 1), 4) }
                                    lastScale = scale
                                }
                        )
                        .onTapGesture(count: 2) {
                            withAnimation {
                                scale = scale > 1 ? 1 : 2.5
                                lastScale = scale
                            }
                        }
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .background(Color.black)
            .navigationTitle(allPhotos[currentIndex].displayName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Text("\(currentIndex + 1) / \(allPhotos.count)")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.white.opacity(0.6))
                        Spacer()
                        Button {
                            withAnimation { scale = 1; lastScale = 1 }
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
            }
            .toolbarBackground(.black.opacity(0.3), for: .navigationBar)
            .toolbarBackground(.black.opacity(0.3), for: .bottomBar)
        }
    }
}

#Preview {
    GalleryView()
}
