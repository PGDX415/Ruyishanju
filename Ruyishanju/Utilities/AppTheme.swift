//
//  AppTheme.swift
//  Ruyishanju
//
//  品牌配色与字体主题 — 温润、雅致、东方山居意境
//  支持 Light / Dark Mode 自动切换
//

import SwiftUI

/// 品牌配色体系 — 适配明暗模式
struct AppTheme {
    // MARK: - Light 模式原始色

    private static let lPrimary     = Color(red: 0.22, green: 0.35, blue: 0.29)  // #38594A
    private static let lPrimaryLight = Color(red: 0.85, green: 0.91, blue: 0.88)
    private static let lWood        = Color(red: 0.65, green: 0.49, blue: 0.35)  // #A67C58
    private static let lStone       = Color(red: 0.94, green: 0.92, blue: 0.90)
    private static let lPaperWhite  = Color(red: 0.98, green: 0.97, blue: 0.95)
    private static let lInk         = Color(red: 0.20, green: 0.18, blue: 0.16)
    private static let lLightInk    = Color(red: 0.47, green: 0.44, blue: 0.40)
    private static let lDivider     = Color(red: 0.88, green: 0.86, blue: 0.83)
    private static let lCardWhite   = Color.white

    // MARK: - Dark 模式「山居夜色」

    private static let dPrimary     = Color(red: 0.48, green: 0.68, blue: 0.58)  // 柔化墨绿
    private static let dPrimaryLight = Color(red: 0.15, green: 0.22, blue: 0.18)  // 暗绿底
    private static let dWood        = Color(red: 0.83, green: 0.66, blue: 0.42)  // 暖琥珀
    private static let dStone       = Color(red: 0.16, green: 0.19, blue: 0.17)  // 深岩色
    private static let dPaperWhite  = Color(red: 0.10, green: 0.12, blue: 0.11)  // 深夜色
    private static let dInk         = Color(red: 0.91, green: 0.89, blue: 0.86)  // 暖白文字
    private static let dLightInk    = Color(red: 0.63, green: 0.60, blue: 0.55)  // 暗灰文字
    private static let dDivider     = Color(red: 0.23, green: 0.26, blue: 0.24)  // 暗分隔线
    private static let dCardWhite   = Color(red: 0.18, green: 0.21, blue: 0.19)  // 暗卡片

    // MARK: - 自适应语义色

    static var primary: Color       { adaptive(lPrimary, dark: dPrimary) }
    static var primaryLight: Color  { adaptive(lPrimaryLight, dark: dPrimaryLight) }
    static var wood: Color          { adaptive(lWood, dark: dWood) }
    static var stone: Color         { adaptive(lStone, dark: dStone) }
    static var paperWhite: Color    { adaptive(lPaperWhite, dark: dPaperWhite) }
    static var ink: Color           { adaptive(lInk, dark: dInk) }
    static var lightInk: Color      { adaptive(lLightInk, dark: dLightInk) }
    static var divider: Color       { adaptive(lDivider, dark: dDivider) }
    static var cardBackground: Color { adaptive(lCardWhite, dark: dCardWhite) }

    static var accent: Color        { primary }
    static var background: Color    { paperWhite }
    static var surface: Color       { stone }
    static var textPrimary: Color   { ink }
    static var textSecondary: Color { lightInk }

    // MARK: - UIColor 动态色（支持色阶内插值）

    private static func adaptive(_ light: Color, dark: Color) -> Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

/// 品牌字体扩展
extension Font {
    static var brandLargeTitle: Font {
        .system(size: 36, weight: .semibold, design: .serif)
    }
    static var brandTitle: Font {
        .system(size: 28, weight: .medium, design: .serif)
    }
    static var brandSubtitle: Font {
        .system(size: 20, weight: .regular, design: .serif)
    }
    static var brandSlogan: Font {
        .system(size: 18, weight: .light, design: .serif)
    }
    static var infoLabel: Font {
        .system(size: 13, weight: .medium, design: .rounded)
    }
}
