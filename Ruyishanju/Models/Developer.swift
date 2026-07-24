//
//  Developer.swift
//  Ruyishanju
//
//  开发商与物业信息数据模型
//

import Foundation

/// 开发商信息
struct Developer: Codable, Identifiable {
    let id: String
    let name: String             // 开发商名称
    let slogan: String           // 品牌口号
    let logoImage: String        // Logo 资源名
    let description: String      // 开发商介绍
    let foundedYear: Int         // 成立年份
    let projectCount: Int        // 累计开发项目数
    let highlights: [String]     // 品牌亮点
}

/// 物业信息
struct PropertyService: Codable, Identifiable {
    let id: String
    let name: String             // 物业公司名称
    let logoImage: String        // 物业 Logo
    let description: String      // 物业服务介绍
    let features: [String]       // 服务特色
    let feeDescription: String?  // 物业费说明
}
