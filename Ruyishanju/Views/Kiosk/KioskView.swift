//
//  KioskView.swift
//  Ruyishanju
//
//  展厅待机/演示模式 — iPad 横屏分栏 + iPhone 全屏轮播
//

import SwiftUI

struct KioskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var currentSlide = 0
    @State private var timer: Timer?

    /// 轮播用的所有图库照片
    let photos = MediaHelper.GalleryPhoto.allCases

    var isLandscape: Bool {
        horizontalSizeClass == .regular
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if isLandscape {
                landscapeLayout
            } else {
                portraitLayout
            }

            // 退出按钮
            VStack {
                HStack {
                    Spacer()
                    Button {
                        stopTimer()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(16)
                }
                Spacer()
            }
        }
        .onAppear(perform: startTimer)
        .onDisappear(perform: stopTimer)
    }

    // MARK: - iPad 横屏分栏布局

    private var landscapeLayout: some View {
        HStack(spacing: 0) {
            // 左侧：大图轮播
            imageCarousel
                .frame(maxWidth: .infinity)

            // 右侧：品牌信息面板
            infoPanel
                .frame(width: 380)
        }
    }

    // MARK: - iPhone 全屏布局

    private var portraitLayout: some View {
        TabView(selection: $currentSlide) {
            ForEach(photos.indices, id: \.self) { index in
                fullScreenSlide(photos[index], index: index)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
    }

    // MARK: - 图片轮播

    private var imageCarousel: some View {
        TabView(selection: $currentSlide) {
            ForEach(photos.indices, id: \.self) { index in
                photos[index].image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            // 页码指示
            HStack(spacing: 6) {
                ForEach(photos.indices, id: \.self) { i in
                    Circle()
                        .fill(i == currentSlide ? .white : .white.opacity(0.3))
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.bottom, 16)
        }
    }

    // MARK: - 信息面板（iPad 右侧）

    private var infoPanel: some View {
        VStack(spacing: 0) {
            Spacer()

            // Logo
            Circle()
                .fill(.white.opacity(0.08))
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: "building.columns.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white.opacity(0.7))
                }

            Spacer().frame(height: 28)

            // 项目名
            Text("绿城如意山居")
                .font(.system(size: 30, weight: .semibold, design: .serif))
                .foregroundColor(.white)

            Spacer().frame(height: 10)

            Text("人生如意 自在山")
                .font(.system(size: 16, weight: .light, design: .serif))
                .foregroundColor(.white.opacity(0.6))
                .tracking(6)

            Spacer().frame(height: 40)

            // 核心信息
            infoRow(icon: "ruler", label: "容积率", value: "住宅1.0")
            infoRow(icon: "tree.fill", label: "绿地率", value: "40%")
            infoRow(icon: "leaf.fill", label: "森林覆盖率", value: "86.44%")
            infoRow(icon: "figure.walk", label: "在售户型", value: "100-120㎡")

            Spacer().frame(height: 40)

            // 联系信息
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 11))
                    Text("海南省五指山市 · 如意山居")
                        .font(.system(size: 13))
                }
                .foregroundColor(.white.opacity(0.45))

                HStack(spacing: 6) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 11))
                    Text("400-123-4567")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                }
                .foregroundColor(.white.opacity(0.6))
            }

            Spacer().frame(height: 30)

            // 底部
            VStack(spacing: 4) {
                Rectangle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 40, height: 1)
                Text("展厅演示模式")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.2))
            }

            Spacer().frame(height: 40)
        }
        .padding(.horizontal, 30)
        .background(
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.12, blue: 0.10), .black],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    // MARK: - 全屏幻灯片（iPhone）

    private func fullScreenSlide(_ photo: MediaHelper.GalleryPhoto, index: Int) -> some View {
        ZStack(alignment: .bottom) {
            photo.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .overlay(
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black.opacity(0.2), location: 0.6),
                            .init(color: .black.opacity(0.6), location: 1),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            VStack(spacing: 12) {
                Spacer()

                if index < 4 {
                    slideTitle(index: index)
                } else {
                    Text(photo.displayName)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.5))
                }

                Text("\(index + 1) / \(photos.count)")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.25))

                Text("请咨询现场销售人员")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.4))
                    .padding(.bottom, 50)
            }
            .padding(.horizontal, 40)
        }
    }

    @ViewBuilder
    private func slideTitle(index: Int) -> some View {
        switch index {
        case 0:
            VStack(spacing: 8) {
                Text("绿城如意山居")
                    .font(.brandLargeTitle)
                    .foregroundColor(.white)
                    .shadow(radius: 4)
                Text("人生如意 自在山")
                    .font(.brandSlogan)
                    .foregroundColor(.white.opacity(0.8))
                    .tracking(4)
            }
        case 1:
            VStack(spacing: 8) {
                Text("天赋山境")
                    .font(.brandTitle)
                    .foregroundColor(.white)
                Text("北纬18° · 森林覆盖率86.44%")
                    .font(.brandSlogan)
                    .foregroundColor(.white.opacity(0.7))
            }
        case 2:
            VStack(spacing: 8) {
                Text("匠心品质")
                    .font(.brandTitle)
                    .foregroundColor(.white)
                Text("绿城桂语系 · 近30年深耕")
                    .font(.brandSlogan)
                    .foregroundColor(.white.opacity(0.7))
            }
        case 3:
            VStack(spacing: 8) {
                Text("诚邀品鉴")
                    .font(.brandTitle)
                    .foregroundColor(.white)
                Text("海南五指山 · 如意山居")
                    .font(.brandSlogan)
                    .foregroundColor(.white.opacity(0.7))
            }
        default:
            EmptyView()
        }
    }

    // MARK: - 信息行

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.35))
                .frame(width: 18)

            Text(label)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.4))

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.vertical, 6)
    }

    // MARK: - 定时器

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.8)) {
                currentSlide = (currentSlide + 1) % photos.count
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview("iPhone") {
    KioskView()
}

#Preview("iPad Landscape", traits: .landscapeRight) {
    KioskView()
}

