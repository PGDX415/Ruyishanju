//
//  ShareSheet.swift
//  Ruyishanju
//
//  分享组件 — UIActivityViewController SwiftUI 封装
//

import SwiftUI

/// SwiftUI 分享面板
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.excludedActivityTypes = [
            .assignToContact, .addToReadingList, .openInIBooks,
            .markupAsPDF, .print
        ]
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

/// 生成户型分享文本
struct UnitTypeShareText {
    static func generate(for unitType: UnitType) -> String {
        """
        🏠 \(unitType.name) — 绿城如意山居

        📐 \(unitType.roomCount)室\(unitType.hallCount)厅\(unitType.bathroomCount)卫
        📏 建面约 \(String(format: "%.0f", unitType.area))㎡
        🧭 朝向：\(unitType.orientation)
        📍 海南五指山 · 北纬18°天赋山境

        \(unitType.description)

        🌿 森林覆盖率86.44% · 负氧离子最高50000个/cm³
        🏗️ 一期6幢14层山景高层 · 2026年12月交付

        —— 人生如意 自在山 ——
        """
    }
}

/// 生成项目分享文本
struct ProjectShareText {
    static let shareText = """
    🏔️ 绿城如意山居 — 人生如意 自在山

    📍 海南五指山 · 北纬18°天赋山境
    🏠 建面约100-120㎡ 康养板式全装美宅
    🌿 森林覆盖率86.44% · 天然氧吧

    绿城中国倾力打造山居康养理想作品
    一期6幢14层山景高层 · 2026年12月交付

    —— 邀您共鉴山居之美 ——
    """
}
