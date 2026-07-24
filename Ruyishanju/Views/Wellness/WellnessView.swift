//
//  WellnessView.swift
//  Ruyishanju
//
//  康养专题 — 五指山天赋康养资源深度解读
//

import SwiftUI

struct WellnessView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    heroSection
                    airSection
                    climateSection
                    lifestyleSection
                    healthTipsSection
                }
                .padding(16)
            }
            .background(AppTheme.background)
            .navigationTitle("康养山居")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 头部

    private var heroSection: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.primary, Color(red: 0.15, green: 0.28, blue: 0.20)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                VStack(spacing: 16) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.white.opacity(0.9))

                    Text("人生如意 自在山")
                        .font(.system(size: 24, weight: .medium, design: .serif))
                        .foregroundColor(.white)

                    Text("在五指山，遇见更好的自己")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.75))
                }
                .padding(.vertical, 40)
            }
            .frame(maxWidth: .infinity)

            Text("五指山是中国为数不多同时拥有热带雨林气候与高负氧离子空气的康养胜地。这里远离城市喧嚣，让身心回归大自然的怀抱，享受真正的山居康养生活。")
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(6)
        }
    }

    // MARK: - 空气

    private var airSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("天然氧吧 · 负氧离子")

            HStack(spacing: 12) {
                statCard(
                    value: "50000",
                    unit: "个/cm³",
                    label: "最高负氧离子浓度",
                    desc: "世界卫生组织清新空气标准的50倍以上"
                )
                statCard(
                    value: "86.44%",
                    unit: "",
                    label: "森林覆盖率",
                    desc: "远离雾霾，每一口呼吸都是纯净的"
                )
            }

            Text("负氧离子被誉为「空气维生素」，能够促进新陈代谢、改善睡眠质量、增强免疫力。五指山高达50000个/cm³的负氧离子浓度，远超城市环境中的几百个/cm³，长期居住于此，对呼吸系统疾病、心血管疾病和亚健康状态均有显著的改善作用。")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(5)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppTheme.cardBackground)
                        .shadow(color: .black.opacity(0.03), radius: 3, y: 1)
                )
        }
    }

    // MARK: - 气候

    private var climateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("四季如春 · 天赋气候")

            HStack(spacing: 12) {
                statCard(
                    value: "23.5",
                    unit: "°C",
                    label: "年均气温",
                    desc: "冬无严寒、夏无酷暑"
                )
                statCard(
                    value: "1876",
                    unit: "米",
                    label: "主峰海拔",
                    desc: "海南第一高峰，天然空调"
                )
            }

            VStack(spacing: 0) {
                climateRow(season: "春", temp: "18-26°C", desc: "万物复苏，山花烂漫，最适合登山踏青")
                Divider().background(AppTheme.divider)
                climateRow(season: "夏", temp: "22-30°C", desc: "比沿海城市低3-5°C，天然避暑胜地")
                Divider().background(AppTheme.divider)
                climateRow(season: "秋", temp: "20-28°C", desc: "秋高气爽，层林尽染，收获的季节")
                Divider().background(AppTheme.divider)
                climateRow(season: "冬", temp: "15-22°C", desc: "温暖过冬，候鸟老人的理想之选")
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    // MARK: - 生活方式

    private var lifestyleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("山居康养生活方式")

            VStack(spacing: 12) {
                lifestyleCard(
                    icon: "figure.walk",
                    title: "森林浴与徒步",
                    desc: "五指山热带雨林是进行森林浴（Shinrin-yoku）的绝佳场所，研究表明每周2小时的森林浴可显著降低压力激素水平、改善心率变异性。"
                )
                lifestyleCard(
                    icon: "bed.double.fill",
                    title: "优质睡眠环境",
                    desc: "高浓度负氧离子与低噪音环境共同营造理想的睡眠条件，帮助改善失眠、浅睡等问题，让您每晚享受深度修复性睡眠。"
                )
                lifestyleCard(
                    icon: "leaf.arrow.circlepath",
                    title: "有机食材养生",
                    desc: "五指山周边盛产天然有机食材，山泉水灌溉的蔬菜、散养的禽畜，从源头保障饮食健康。社区配套有机农场，业主可体验采摘之趣。"
                )
                lifestyleCard(
                    icon: "figure.mind.and.body",
                    title: "身心平衡之道",
                    desc: "社区规划中融入太极广场、瑜伽平台、禅修步道等设施，让山居生活不仅是身体的康养，更是心灵的修行。"
                )
            }
        }
    }

    // MARK: - 健康建议

    private var healthTipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("康养小贴士")

            VStack(spacing: 0) {
                tipRow("☀️", "晨起散步30分钟，吸收清晨高浓度负氧离子")
                Divider().background(AppTheme.divider)
                tipRow("💧", "五指山山泉水矿物质含量丰富，建议多饮用当地水源")
                Divider().background(AppTheme.divider)
                tipRow("🧘", "午后静坐冥想，感受山间微风与鸟鸣，放松身心")
                Divider().background(AppTheme.divider)
                tipRow("🌿", "适量食用当地五指山绿茶，富含茶多酚，抗氧化效果显著")
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    // MARK: - 辅助组件

    private func sectionHeader(_ title: String) -> some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(AppTheme.primary)
                .frame(width: 3, height: 18)
            Text(title)
                .font(.brandSubtitle)
                .foregroundColor(AppTheme.textPrimary)
        }
    }

    private func statCard(value: String, unit: String, label: String, desc: String) -> some View {
        VStack(spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.primary)
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.primary)
                }
            }

            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)

            Text(desc)
                .font(.system(size: 11))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    private func climateRow(season: String, temp: String, desc: String) -> some View {
        HStack(spacing: 14) {
            Text(season)
                .font(.system(size: 24))
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(season)季")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    Text(temp)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(AppTheme.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(AppTheme.primaryLight)
                        )
                }
                Text(desc)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    private func lifestyleCard(icon: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppTheme.primary)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppTheme.primaryLight)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                Text(desc)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(4)
            }
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    private func tipRow(_ emoji: String, _ text: String) -> some View {
        HStack(spacing: 14) {
            Text(emoji)
                .font(.system(size: 22))
                .frame(width: 32)

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textPrimary)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}

#Preview {
    WellnessView()
}
