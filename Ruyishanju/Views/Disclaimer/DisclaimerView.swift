//
//  DisclaimerView.swift
//  Ruyishanju
//
//  免责声明
//

import SwiftUI

struct DisclaimerView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    generalDisclaimer
                    imageDisclaimer
                    pricingDisclaimer
                    policyDisclaimer
                    rightsReserved
                }
                .padding(20)
            }
            .background(AppTheme.background)
            .navigationTitle("免责声明")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("免责声明")
                .font(.brandTitle)
                .foregroundColor(AppTheme.textPrimary)

            Text("请在使用本应用前仔细阅读以下声明")
                .font(.system(size: 13))
                .foregroundColor(AppTheme.textSecondary)
        }
    }

    private var generalDisclaimer: some View {
        disclaimerSection(
            title: "一、一般声明",
            content: """
            本应用（绿城如意山居App）所展示的所有信息，包括但不限于项目介绍、户型图、价格信息、政策说明、周边配套、交通路线等，仅供用户参考之用，不构成任何形式的法律要约或承诺。

            开发商保留根据实际情况对项目规划、设计、户型、价格等进行调整的权利，具体信息以政府主管部门批准文件及买卖双方签订的《商品房买卖合同》为准。

            用户在做出购房决策前，应自行核实相关信息，并咨询专业人士的意见。开发商不对因使用本应用信息而产生的任何直接或间接损失承担责任。
            """
        )
    }

    private var imageDisclaimer: some View {
        disclaimerSection(
            title: "二、图片与效果图声明",
            content: """
            本应用中所展示的建筑效果图、户型图、景观示意图、室内装修示意图等均为示意参考，旨在传达项目设计理念与风格，不构成开发商的交付标准承诺。

            实际交付标准以《商品房买卖合同》及其附件中的约定为准。因拍摄光线、显示设备差异等因素，图片与实际可能存在色差，请以实物为准。

            户型图中的家具、家电、装饰品等仅为空间布局示意，非交付标准。户型面积、尺寸标示可能存在微小差异，最终以房产测绘部门实测面积为准。
            """
        )
    }

    private var pricingDisclaimer: some View {
        disclaimerSection(
            title: "三、价格信息声明",
            content: """
            本应用中所展示的房屋价格信息（包括但不限于参考总价、参考单价等）仅为市场参考信息，不构成最终成交价格的承诺。

            房屋销售实行「一房一价」原则，实际成交价格受楼层、朝向、付款方式、优惠政策等多种因素影响。具体价格以售楼处现场公示价格及《商品房买卖合同》约定为准。

            所有价格信息的最终解释权归开发商所有。
            """
        )
    }

    private var policyDisclaimer: some View {
        disclaimerSection(
            title: "四、政策信息声明",
            content: """
            本应用中所涉及的购房政策、自贸港政策、人才引进政策、信贷政策等信息，均来源于政府公开信息整理，仅供用户参考。

            相关政策可能随时调整或更新，用户应以政府主管部门最新发布的正式文件为准。开发商不对政策信息的时效性、准确性做出任何保证。

            建议购房前咨询当地住建部门或专业法律顾问，获取最新、最权威的政策解读。
            """
        )
    }

    private var rightsReserved: some View {
        VStack(alignment: .leading, spacing: 12) {
            disclaimerSection(
                title: "五、知识产权与权利保留",
                content: """
                本应用中所有内容（包括但不限于文字、图片、图标、界面设计、版式等）的知识产权归开发商或相关权利人所有，受《中华人民共和国著作权法》等相关法律法规保护。

                未经书面授权，任何单位或个人不得以任何方式复制、转载、引用、链接或以其他方式使用本应用中的任何内容。

                开发商名称：五指山市乾景源实业发展有限公司
                代建管理方：绿城管理控股有限公司
                本声明最终解释权归开发商所有。
                """
            )
        }
    }

    private func disclaimerSection(title: String, content: String) -> some View {
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
    DisclaimerView()
}
