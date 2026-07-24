//
//  PrivacyView.swift
//  Ruyishanju
//
//  隐私政策 — App Store 上架必需
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    section1
                    section2
                    section3
                    section4
                    section5
                    section6
                }
                .padding(20)
            }
            .background(AppTheme.background)
            .navigationTitle("隐私政策")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("隐私政策")
                .font(.brandTitle)
                .foregroundColor(AppTheme.textPrimary)

            Text("更新日期：2026年7月24日\n生效日期：2026年7月24日")
                .font(.system(size: 13))
                .foregroundColor(AppTheme.textSecondary)
        }
    }

    private var section1: some View {
        policySection(
            title: "一、信息收集",
            content: """
            我们仅在为您提供看房预约服务时收集必要的个人信息，包括：
            • 姓名（用于预约确认与接待）
            • 手机号码（用于销售顾问与您联系）
            • 意向户型偏好（用于提供更精准的房源推荐）

            我们不会收集与看房服务无关的个人信息。
            """
        )
    }

    private var section2: some View {
        policySection(
            title: "二、信息使用",
            content: """
            您提供的个人信息仅用于以下目的：
            • 确认看房预约并安排销售顾问接待
            • 根据您的需求推荐合适的户型与房源
            • 后续楼盘动态及优惠信息的推送（仅在您明确同意的情况下）

            我们不会将您的个人信息用于上述目的之外的任何商业用途。
            """
        )
    }

    private var section3: some View {
        policySection(
            title: "三、信息存储与安全",
            content: """
            您的个人信息将存储于安全的服务器中，我们采用行业标准的安全措施保护您的数据，防止未经授权的访问、使用或泄露。

            您可通过联系客服随时要求查阅、更正或删除您的个人信息。
            """
        )
    }

    private var section4: some View {
        policySection(
            title: "四、信息共享",
            content: """
            我们不会向任何第三方出售、交易或转让您的个人信息。以下情形除外：
            • 获得您的明确授权同意
            • 法律法规要求披露
            • 为保护我们或他人的合法权益所必需
            """
        )
    }

    private var section5: some View {
        policySection(
            title: "五、您的权利",
            content: """
            您有权：
            • 查询我们所持有的您的个人信息
            • 要求更正不准确的个人信息
            • 要求删除您的个人信息
            • 撤回对信息收集的同意

            如需行使上述权利，请通过客服电话 400-123-4567 与我们联系。
            """
        )
    }

    private var section6: some View {
        policySection(
            title: "六、政策更新",
            content: """
            我们可能不时更新本隐私政策。更新后的政策将在本页面发布，重大变更将通过适当方式通知您。

            如您对本隐私政策有任何疑问，请联系我们：
            客服电话：400-123-4567
            联系地址：海南省五指山市·如意山居营销中心
            """
        )
    }

    private func policySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)

            Text(content)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(6)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.03), radius: 3, y: 1)
        )
    }
}

#Preview {
    PrivacyView()
}
