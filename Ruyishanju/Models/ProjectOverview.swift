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
    let projectSpecs: ProjectSpecs?       // 项目规格
    let developer: DeveloperInfo?          // 开发商信息
    let natureInfo: NatureInfo?           // 自然环境信息
}

/// 分期信息
struct PhaseInfo: Codable {
    let currentPhase: String     // 当前在售期数
    let totalPhases: Int         // 总期数
    let status: String           // "在售" / "售罄" / "待售"
    let deliveryDate: String     // 预计交付时间
}

/// 项目规格参数
struct ProjectSpecs: Codable {
    let landArea: String         // 占地面积
    let buildingArea: String     // 建筑面积
    let floorAreaRatio: String   // 容积率
    let greenRate: String        // 绿地率
    let parkingSpaces: String    // 停车位
    let unitArea: String         // 户型面积区间
    let buildingInfo: String     // 楼栋信息
}

/// 开发商信息
struct DeveloperInfo: Codable {
    let name: String             // 开发商名称
    let agent: String            // 代建/管理方
}

/// 自然环境信息
struct NatureInfo: Codable {
    let forestRate: String       // 森林覆盖率
    let oxygenIon: String        // 负氧离子浓度
    let avgTemperature: String   // 年均气温
    let altitude: String         // 海拔
    let forestArea: String       // 原始森林面积
}
