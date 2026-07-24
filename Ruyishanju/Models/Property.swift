//
//  Property.swift
//  Ruyishanju
//
//  物业/楼盘信息数据模型
//

import Foundation
import CoreLocation

/// 楼盘周边配套
struct Amenity: Codable, Identifiable {
    let id: String
    let name: String
    let category: AmenityCategory
    let distance: String?       // 距离描述，如"步行5分钟"
    let description: String?
    let coordinate: Coordinate?
}

enum AmenityCategory: String, Codable, CaseIterable, Identifiable {
    case education = "教育"
    case shopping = "商业"
    case medical = "医疗"
    case transport = "交通"
    case leisure = "休闲"
    case dining = "餐饮"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .education: return "book.fill"
        case .shopping: return "cart.fill"
        case .medical: return "cross.case.fill"
        case .transport: return "bus.fill"
        case .leisure: return "leaf.fill"
        case .dining: return "fork.knife"
        }
    }
}

/// 地图坐标
struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double

    var clLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

/// 项目位置信息
struct ProjectLocation: Codable {
    let address: String
    let coordinate: Coordinate
    let mapImage: String          // 地图截图/示意图
    let amenities: [Amenity]      // 周边配套列表
    let transportation: String    // 交通出行说明
}
