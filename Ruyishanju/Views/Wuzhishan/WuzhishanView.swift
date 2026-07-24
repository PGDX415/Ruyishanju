//
//  WuzhishanView.swift
//  Ruyishanju
//
//  五指山风物志 — 景点、美食、文化
//

import SwiftUI

struct WuzhishanView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    natureSection
                    attractionsSection
                    cultureSection
                    foodSection
                }
                .padding(16)
            }
            .background(AppTheme.background)
            .navigationTitle("五指山风物志")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 自然环境

    private var natureSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("北纬18° 天赋山境")

            Text("五指山位于海南岛中南部，主峰海拔1876米，是海南第一高峰。这里地处北纬18°黄金气候带，拥有原始森林90.63平方公里，森林覆盖率达86.44%，负氧离子浓度最高可达50000个/cm³，年均气温23.5°C，是天然的避暑康养胜地。")
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(6)

            HStack(spacing: 12) {
                natureStat(value: "1876m", label: "主峰海拔")
                natureStat(value: "23.5°C", label: "年均气温")
                natureStat(value: "86.44%", label: "森林覆盖率")
                natureStat(value: "50000", label: "负氧离子/cm³")
            }
        }
    }

    // MARK: - 景点

    private var attractionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("必游景点")

            VStack(spacing: 12) {
                attractionCard(
                    name: "五指山热带雨林风景区",
                    desc: "国家AAAA级旅游景区，保存完好的原始热带雨林生态系统，登山步道穿越雨林深处，沿途瀑布溪流相伴，登顶可观五指山全貌。",
                    icon: "leaf.fill"
                )
                attractionCard(
                    name: "海南热带雨林国家公园",
                    desc: "中国首批国家公园之一，涵盖五指山核心生态区域，是珍稀野生动植物的天堂。漫步其间可感受最纯净的自然气息。",
                    icon: "tree.fill"
                )
                attractionCard(
                    name: "五指山革命根据地纪念园",
                    desc: "琼崖纵队革命历史的见证地，红色旅游经典景区，了解海南革命历史的同时俯瞰群山环绕的壮丽景色。",
                    icon: "flag.fill"
                )
                attractionCard(
                    name: "太平山瀑布",
                    desc: "五指山境内落差最大的瀑布群，雨季水量充沛时尤为壮观，沿途原始林木葱郁，是户外徒步爱好者的热门去处。",
                    icon: "water.waves"
                )
            }
        }
    }

    // MARK: - 黎苗文化

    private var cultureSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("黎苗文化瑰宝")

            VStack(spacing: 0) {
                cultureItem(
                    title: "三月三节",
                    desc: "黎族苗族最盛大的传统节日，每年农历三月初三，当地群众载歌载舞、对歌竞技，热闹非凡。"
                )
                Divider().background(AppTheme.divider)
                cultureItem(
                    title: "黎锦技艺",
                    desc: "世界级非物质文化遗产，黎族妇女世代相传的纺织技艺，图案精美、色彩斑斓，堪称纺织史上的活化石。"
                )
                Divider().background(AppTheme.divider)
                cultureItem(
                    title: "船形屋",
                    desc: "黎族传统民居，形如倒扣木船，冬暖夏凉。五指山周边仍保留着原汁原味的黎族村落。"
                )
                Divider().background(AppTheme.divider)
                cultureItem(
                    title: "苗族银饰",
                    desc: "海南苗族银饰工艺精湛，苗家女子盛装时银饰满身、环佩叮当，是非遗文化的璀璨明珠。"
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    // MARK: - 美食

    private var foodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("五指山味道")

            VStack(spacing: 12) {
                foodCard(
                    name: "五指山小黄牛",
                    desc: "散养于山林之间，肉质细嫩鲜美、不膻不腻，白切或红烧皆可，是五指山最富盛名的美食名片。",
                    icon: "fork.knife"
                )
                foodCard(
                    name: "五脚猪",
                    desc: "五指山特色猪种，因嘴长似第五只脚而得名，肉质紧实弹牙，以炭火烤制最为地道。",
                    icon: "flame.fill"
                )
                foodCard(
                    name: "竹筒饭",
                    desc: "黎族传统美食，将糯米与香料放入竹筒中炭火烤制，饭香与竹香交融，清香扑鼻。",
                    icon: "takeoutbag.and.cup.and.straw.fill"
                )
                foodCard(
                    name: "五指山绿茶",
                    desc: "生长于高海拔云雾之中，汤色碧绿、滋味甘醇、回甘悠长，是海南最优质的高山茶之一。",
                    icon: "cup.and.saucer.fill"
                )
            }
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

    private func natureStat(value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.primary)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.03), radius: 3, y: 1)
        )
    }

    private func attractionCard(name: String, desc: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppTheme.primary)
                .frame(width: 32, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppTheme.primaryLight)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(name)
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
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    private func cultureItem(title: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            Text(desc)
                .font(.system(size: 13))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func foodCard(name: String, desc: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppTheme.wood)
                .frame(width: 32, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppTheme.wood.opacity(0.1))
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(name)
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
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }
}

#Preview {
    WuzhishanView()
}
