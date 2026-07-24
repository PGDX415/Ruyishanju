//
//  AppTheme.swift
//  Ruyishanju
//
//  品牌配色与字体主题 — 温润、雅致、东方山居意境
//

import SwiftUI

/// 品牌配色体系
struct AppTheme {
    // MARK: 主色调 — 水墨/木色系

    /// 墨绿 — 主色调，用于强调按钮、导航标题
    static let primary = Color(red: 0.22, green: 0.35, blue: 0.29)       // #38594A

    /// 浅墨绿 — 用于卡片背景、选中态
    static let primaryLight = Color(red: 0.85, green: 0.91, blue: 0.88) // #D9E9E0

    /// 暖木色 — 辅助色
    static let wood = Color(red: 0.65, green: 0.49, blue: 0.35)          // #A67C58

    /// 石色 — 中性背景
    static let stone = Color(red: 0.94, green: 0.92, blue: 0.90)         // #F0EBE5

    /// 宣纸白 — 页面背景
    static let paperWhite = Color(red: 0.98, green: 0.97, blue: 0.95)   // #FAF7F2

    /// 墨色 — 正文文字
    static let ink = Color(red: 0.20, green: 0.18, blue: 0.16)           // #332E29

    /// 淡墨 — 次要文字
    static let lightInk = Color(red: 0.47, green: 0.44, blue: 0.40)     // #787066

    // MARK: 语义色

    static let accent = primary
    static let background = paperWhite
    static let surface = stone
    static let textPrimary = ink
    static let textSecondary = lightInk
    static let divider = Color(red: 0.88, green: 0.86, blue: 0.83)
}

/// 品牌字体扩展
extension Font {
    /// 品牌大标题 — 用于首页品牌展示
    static var brandLargeTitle: Font {
        .system(size: 36, weight: .semibold, design: .serif)
    }

    /// 品牌标题 — 用于页面主标题
    static var brandTitle: Font {
        .system(size: 28, weight: .medium, design: .serif)
    }

    /// 品牌副标题
    static var brandSubtitle: Font {
        .system(size: 20, weight: .regular, design: .serif)
    }

    /// Slogan 字体
    static var brandSlogan: Font {
        .system(size: 18, weight: .light, design: .serif)
    }

    /// 信息标签字体
    static var infoLabel: Font {
        .system(size: 13, weight: .medium, design: .rounded)
    }
}
