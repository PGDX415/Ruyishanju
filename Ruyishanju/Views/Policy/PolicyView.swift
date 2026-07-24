//
//  PolicyView.swift
//  Ruyishanju
//
//  海南自贸港购房政策
//

import SwiftUI

struct PolicyView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 自贸港概述
                    ftpOverview

                    // 购房政策
                    housingPolicy

                    // 人才引进
                    talentPolicy

                    // 温馨提示
                    tipsSection
                }
                .padding(16)
            }
            .background(AppTheme.background)
            .navigationTitle("购房政策")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 自贸港概述

    private var ftpOverview: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("海南自由贸易港")

            Text("海南自由贸易港是中国政府于2020年正式设立的国家级自贸港，目标在2025年底前实现全岛封关运作，建成具有国际竞争力的高水平自由贸易港。五指山地处海南中南部生态核心区，在享受自贸港政策红利的同时，拥有得天独厚的自然生态资源。")
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(6)

            VStack(spacing: 0) {
                policyItem(icon: "globe.asia.australia.fill", title: "零关税", desc: "封关后岛内进口商品免征关税，大幅降低生活成本")
                Divider().background(AppTheme.divider)
                policyItem(icon: "person.badge.key.fill", title: "低税率", desc: "个人所得税最高15%，企业所得税15%，全国最低")
                Divider().background(AppTheme.divider)
                policyItem(icon: "airplane.departure", title: "免签政策", desc: "59国人员入境旅游免签30天，全球人才汇聚")
                Divider().background(AppTheme.divider)
                policyItem(icon: "banknote.fill", title: "资金自由", desc: "贸易结算自由、跨境资金流动便利")
            }
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.03), radius: 3, y: 1)
            )
        }
    }

    // MARK: - 购房政策

    private var housingPolicy: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("购房利好政策")

            VStack(spacing: 0) {
                policyCard(
                    title: "全面取消限购",
                    content: "五指山市已全面取消商品住房购买限制，非本地户籍居民与本地居民享有同等购房资格，无需社保或个税缴纳证明。"
                )
                policyCard(
                    title: "取消限售政策",
                    content: "商品住房取得不动产权证后即可上市交易，不再受年限限制，资产流动性大大提升。"
                )
                policyCard(
                    title: "「双暂」税收优惠",
                    content: "暂免征收房产税和城镇土地使用税，降低持有成本，让您在五指山轻松置业安居。"
                )
                policyCard(
                    title: "公积金支持",
                    content: "支持异地公积金贷款购房，最高贷款额度上浮，进一步降低购房门槛。"
                )
            }
        }
    }

    // MARK: - 人才引进

    private var talentPolicy: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("人才引进政策")

            VStack(spacing: 0) {
                policyCard(
                    title: "购房补贴",
                    content: "经认定的高层次人才在五指山购房，可享受最高数十万元的购房补贴，具体以当年政策为准。"
                )
                policyCard(
                    title: "落户便利",
                    content: "符合条件的人才可在五指山直接落户，享受与本地居民同等的教育、医疗等公共服务。"
                )
                policyCard(
                    title: "子女教育",
                    content: "人才子女可享受当地优质教育资源，包括公办学校就近入学等教育保障政策。"
                )
            }
        }
    }

    // MARK: - 温馨提示

    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("温馨提示")

            Text("以上政策信息仅供参考，具体以政府主管部门最新发布文件为准。建议购房前咨询项目销售顾问或当地住建部门，获取最新、最准确的政策解读。")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(5)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.95, green: 0.93, blue: 0.88))
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

    private func policyItem(icon: String, title: String, desc: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppTheme.primary)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Text(desc)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(2)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    private func policyCard(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Circle()
                    .fill(AppTheme.primary)
                    .frame(width: 6, height: 6)
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
            }
            Text(content)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(5)
                .padding(.leading, 14)
        }
        .padding(16)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(AppTheme.divider)
                .frame(height: 0.5),
            alignment: .bottom
        )
    }
}

#Preview {
    PolicyView()
}
