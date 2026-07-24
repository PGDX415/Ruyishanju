//
//  ProjectOverview.swift
//  Ruyishanju
//
//  项目概览数据模型
//

import Foundation

/// 项目总览
struct ProjectOverview: Codable, Identifiable {
    let id: String
    let name: String             // 绿城如意山居
    let slogan: String           // 人生如意 自在山
    let subtitle: String         // App Store 副标题
    let description: String      // 项目简介
    let highlights: [String]     // 核心卖点
    let coverImage: String       // 封面图资源名
    let aerialImage: String      // 鸟瞰图/沙盘图
    let brochureURL: String?     // 电子楼书链接（可选）

    let phaseInfo: PhaseInfo     // 分期信息
}

/// 分期信息
struct PhaseInfo: Codable {
    let currentPhase: String     // 当前在售期数
    let totalPhases: Int         // 总期数
    let status: String           // "在售" / "售罄" / "待售"
    let deliveryDate: String     // 预计交付时间
}
