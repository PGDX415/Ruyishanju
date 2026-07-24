//
//  PriceInfo.swift
//  Ruyishanju
//
//  价位参考数据模型
//

import Foundation

/// 楼盘整体价位信息
struct PriceInfo: Codable {
    let projectName: String
    let areaRange: String        // 面积范围文字，如"120-280㎡"
    let avgUnitPrice: Decimal    // 均价（元/㎡）
    let totalPriceRange: String  // 总价区间文字，如"约180万-450万"
    let priceNotes: String?      // 价格备注，如"一房一价，具体以售楼处公示为准"
}
