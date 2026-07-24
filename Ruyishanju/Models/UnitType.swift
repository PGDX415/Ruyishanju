//
//  UnitType.swift
//  Ruyishanju
//
//  户型数据模型
//

import Foundation

/// 户型信息
struct UnitType: Codable, Identifiable {
    let id: String
    let name: String             // 户型名称，如"如意·雅居"
    let roomCount: Int           // 室
    let hallCount: Int           // 厅
    let bathroomCount: Int       // 卫
    let area: Double             // 建筑面积（㎡）
    let innerArea: Double?       // 套内面积（㎡）
    let orientation: String      // 朝向，如"南北通透"
    let floorLevel: String       // 楼层范围，如"1-6层"
    let buildingNumber: String   // 所在楼栋
    let featureTags: [String]    // 户型特色标签，如"双阳台"、"主卧套房"
    let floorPlanImage: String   // 户型图资源名
    let priceRange: PriceRange   // 价格区间
    let status: UnitStatus       // 可售状态
    let description: String      // 户型介绍文案
}

/// 价格区间
struct PriceRange: Codable {
    let minTotalPrice: Decimal?   // 最低总价（万元）
    let maxTotalPrice: Decimal?   // 最高总价（万元）
    let unitPrice: Decimal?       // 参考单价（元/㎡）
}

/// 户型可售状态
enum UnitStatus: String, Codable {
    case available   = "在售"
    case reserved    = "已定"
    case sold        = "售罄"
}

/// 筛选条件
enum RoomFilter: String, CaseIterable, Identifiable {
    case all = "全部"
    case two = "两室"
    case three = "三室"
    case four = "四室"
    case fivePlus = "五室及以上"

    var id: String { rawValue }

    var minRooms: Int {
        switch self {
        case .all: return 0
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .fivePlus: return 5
        }
    }

    var maxRooms: Int? {
        switch self {
        case .all: return nil
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .fivePlus: return nil
        }
    }
}

enum AreaFilter: String, CaseIterable, Identifiable {
    case all = "全部面积"
    case under120 = "120㎡以下"
    case range120to160 = "120-160㎡"
    case range160to200 = "160-200㎡"
    case above200 = "200㎡以上"

    var id: String { rawValue }
}
