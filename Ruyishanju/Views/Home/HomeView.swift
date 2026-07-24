//
//  HomeView.swift
//  Ruyishanju
//
//  首页 — 品牌展示 + 快速导航
//

import SwiftUI

struct HomeView: View {
    @Binding var showKiosk: Bool
    var switchTab: (ContentView.AppTab) -> Void
    @State private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 0) {
            brandHeader
                .ignoresSafeArea(edges: .top)

            ScrollView {
                VStack(spacing: 0) {
                    highlightsSection
                    quickActions
                    projectPreview
                }
                .frame(maxWidth: .infinity)
            }
        }
        .background(AppTheme.background)
        .overlay(alignment: .topTrailing) {
            Button {
                showKiosk = true
            } label: {
                Image(systemName: "play.rectangle.fill")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(.ultraThinMaterial))
            }
            .padding(.top, 54)
            .padding(.trailing, 16)
        }
    }

    // MARK: - 品牌头部

    private var brandHeader: some View {
        MediaHelper.heroImage
            .resizable()
            .scaledToFill()
            .frame(height: 340)
            .clipped()
            .overlay {
                LinearGradient(
                    stops: [
                        .init(color: .black.opacity(0.55), location: 0),
                        .init(color: .black.opacity(0.35), location: 0.4),
                        .init(color: .black.opacity(0.05), location: 0.7),
                        .init(color: .clear, location: 1),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [.clear, AppTheme.background],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 60)
            }
            .overlay(alignment: .bottom) {
                VStack(spacing: 12) {
                    Spacer().frame(height: 54)

                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 56, height: 56)
                        .overlay {
                            Image(systemName: "building.columns.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }

                    Text(viewModel.projectName)
                        .font(.system(size: 30, weight: .semibold, design: .serif))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)

                    Text(viewModel.slogan)
                        .font(.system(size: 16, weight: .light, design: .serif))
                        .foregroundColor(.white.opacity(0.85))

                    HStack(spacing: 10) {
                        TagBadge(text: viewModel.phaseText, color: .white)
                        TagBadge(text: viewModel.statusText, color: .white)
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
    }

    // MARK: - 核心亮点

    private var highlightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("项目亮点")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(viewModel.highlights, id: \.self) { highlight in
                    HStack(spacing: 6) {
                        Image(systemName: "sparkle")
                            .font(.system(size: 11))
                            .foregroundColor(AppTheme.wood)
                            .frame(width: 14)
                        Text(highlight)
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary)
                            .lineLimit(2)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppTheme.cardBackground)
                            .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    // MARK: - 快捷入口

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("快捷浏览")
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    quickCard(icon: "square.grid.2x2.fill", title: "户型鉴赏",
                              subtitle: "精选户型", color: AppTheme.primary,
                              tab: .unitTypes)
                    quickCard(icon: "photo.fill.on.rectangle.fill", title: "实景图库",
                              subtitle: "身临其境", color: AppTheme.wood,
                              tab: .gallery)
                    quickCard(icon: "map.fill", title: "项目总览",
                              subtitle: "沙盘·配套", color: Color(red: 0.35, green: 0.45, blue: 0.55),
                              tab: .overview)
                    quickCard(icon: "phone.fill", title: "预约看房",
                              subtitle: "联系我们", color: AppTheme.stone,
                              tab: .more)
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 22)
    }

    // MARK: - 楼盘预览

    private var projectPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("项目介绍")
                .padding(.horizontal, 20)

            VStack(spacing: 0) {
                // 实景预览图
                MediaHelper.GalleryPhoto.photo08.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()

                // 介绍文案
                VStack(spacing: 12) {
                    Text(viewModel.description)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 16)
                }
                .padding(.vertical, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppTheme.cardBackground)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.06), radius: 8, y: 3)
            .padding(.horizontal, 20)
        }
        .padding(.top, 24)
        .padding(.bottom, 24)
    }

    // MARK: - 辅助方法

    private func sectionTitle(_ title: String) -> some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(AppTheme.primary)
                .frame(width: 3, height: 18)

            Text(title)
                .font(.brandSubtitle)
                .foregroundColor(AppTheme.textPrimary)
        }
    }

    private func quickCard(icon: String, title: String, subtitle: String, color: Color, tab: ContentView.AppTab) -> some View {
        Button {
            switchTab(tab)
        } label: {
            QuickActionCard(icon: icon, title: title, subtitle: subtitle, color: color)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 快捷入口卡片

struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 52, height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(color.opacity(0.1))
                )

            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)

            Text(subtitle)
                .font(.system(size: 12))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(width: 120, height: 140)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
        .contentShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - 标签组件

struct TagBadge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.infoLabel)
            .foregroundColor(color == .white ? .white : color)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(color == .white
                        ? .white.opacity(0.18)
                        : color.opacity(0.15))
            )
            .overlay(
                Capsule()
                    .stroke(color == .white ? .white.opacity(0.3) : color.opacity(0.3), lineWidth: 0.5)
            )
    }
}

// MARK: - ViewModel

@Observable
class HomeViewModel {
    let projectName = "绿城如意山居"
    let slogan = "人生如意 自在山"
    let phaseText = "一期在售"
    let statusText = "热销中"
    let description = "绿城如意山居，位于海南五指山，是绿城中国倾力打造的山居康养理想作品。项目占地约300亩，总建筑面积约24.6万㎡，一期打造6幢14层山景高层，以桂语系的极致简约语言，融合当代建筑的国际审美格调，将建筑妥帖安放在山色之间，开启理想山居生活的全新篇章。"

    let highlights = [
        "北纬18° 海南五指山天赋山境",
        "森林覆盖率86.44%天然氧吧",
        "建面约100-120㎡精装板式美宅",
        "绿城品牌 理想生活综合服务商"
    ]
}

#Preview {
    HomeView(showKiosk: .constant(false), switchTab: { _ in })
}
