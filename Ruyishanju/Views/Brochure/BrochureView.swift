//
//  BrochureView.swift
//  Ruyishanju
//
//  电子楼书
//

import SwiftUI

struct BrochureView: View {
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 封面
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            AppTheme.primary,
                                            Color(red: 0.15, green: 0.28, blue: 0.20)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )

                            VStack(spacing: 16) {
                                Image(systemName: "book.pages.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(.white.opacity(0.8))

                                Text("绿城如意山居")
                                    .font(.system(size: 24, weight: .semibold, design: .serif))
                                    .foregroundColor(.white)

                                Text("电子楼书")
                                    .font(.system(size: 16, weight: .light, design: .serif))
                                    .foregroundColor(.white.opacity(0.7))

                                Divider()
                                    .frame(width: 40)
                                    .background(Color.white.opacity(0.3))

                                Text("人生如意 自在山")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.5))
                                    .tracking(4)
                            }
                            .padding(.vertical, 50)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    // 楼书内容预览
                    previewSection

                    // 获取方式
                    acquireSection

                    // 联系按钮
                    contactButton
                }
                .padding(16)
            }
            .background(AppTheme.background)
            .navigationTitle("电子楼书")
            .navigationBarTitleDisplayMode(.large)
            .alert("提示", isPresented: $showAlert) {
                Button("确定", role: .cancel) {}
            } message: {
                Text("电子楼书功能即将上线，敬请期待。如需了解详细信息，请联系销售顾问或前往营销中心。")
            }
        }
    }

    // MARK: - 预览

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 18)
                Text("楼书内容预览")
                    .font(.brandSubtitle)
                    .foregroundColor(AppTheme.textPrimary)
            }

            VStack(spacing: 12) {
                brochureChapter(index: "01", title: "品牌实力", desc: "绿城中国 · 近30年品质历程")
                brochureChapter(index: "02", title: "项目概况", desc: "300亩山居大盘 · 6幢14层山景高层")
                brochureChapter(index: "03", title: "户型鉴赏", desc: "建面约100-120㎡全装板式美宅")
                brochureChapter(index: "04", title: "园林景观", desc: "桂语系简约美学 · 热带雨林园林")
                brochureChapter(index: "05", title: "康养配套", desc: "天然氧吧 · 全龄康养服务体系")
                brochureChapter(index: "06", title: "周边资源", desc: "五指山热带雨林 · 国家公园")
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    // MARK: - 获取方式

    private var acquireSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 18)
                Text("获取方式")
                    .font(.brandSubtitle)
                    .foregroundColor(AppTheme.textPrimary)
            }

            VStack(spacing: 8) {
                acquireMethod(
                    icon: "arrow.down.doc.fill",
                    title: "在线下载",
                    desc: "点击下方按钮即可下载完整版电子楼书 PDF"
                )
                acquireMethod(
                    icon: "envelope.fill",
                    title: "邮件发送",
                    desc: "联系销售顾问，我们将通过邮件发送至您的邮箱"
                )
                acquireMethod(
                    icon: "building.2.fill",
                    title: "到访领取",
                    desc: "前往如意山居营销中心，免费领取精美纸质楼书"
                )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    // MARK: - 联系按钮

    private var contactButton: some View {
        VStack(spacing: 12) {
            Button {
                showAlert = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.down.doc.fill")
                        .font(.system(size: 16))
                    Text("下载电子楼书")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppTheme.primary)
                )
            }

            Link(destination: URL(string: "tel://4001234567")!) {
                HStack(spacing: 8) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 14))
                    Text("电话咨询：400-123-4567")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(AppTheme.textSecondary)
            }
        }
    }

    // MARK: - 辅助组件

    private func brochureChapter(index: String, title: String, desc: String) -> some View {
        HStack(spacing: 14) {
            Text(index)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(AppTheme.primary)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(AppTheme.primaryLight)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Text(desc)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
            }
            Spacer()
        }
    }

    private func acquireMethod(icon: String, title: String, desc: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppTheme.primary)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Text(desc)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textSecondary)
            }
            Spacer()
        }
    }
}

#Preview {
    BrochureView()
}
