//
//  LocationView.swift
//  Ruyishanju
//
//  位置与周边配套 — MapKit 真实地图 + 配套列表
//

import SwiftUI
import MapKit

struct LocationView: View {
    @State private var selectedCategory: AmenityCategory?
    @State private var camera: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 18.775, longitude: 109.517),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @State private var selectedAmenity: Amenity?

    /// 项目位置 — 海南五指山
    static let projectCoordinate = CLLocationCoordinate2D(latitude: 18.775, longitude: 109.517)

    let amenities: [Amenity] = [
        Amenity(id: "1", name: "五指山热带雨林风景区", category: .leisure, distance: "约3公里",
                description: "国家AAAA级旅游景区，原始热带雨林",
                coordinate: Coordinate(latitude: 18.790, longitude: 109.530)),
        Amenity(id: "2", name: "五指山市第一小学", category: .education, distance: "约2公里",
                description: "五指山市重点小学",
                coordinate: Coordinate(latitude: 18.772, longitude: 109.510)),
        Amenity(id: "3", name: "五指山中学", category: .education, distance: "约2.5公里",
                description: "五指山市完全中学",
                coordinate: Coordinate(latitude: 18.770, longitude: 109.505)),
        Amenity(id: "4", name: "三月三广场", category: .shopping, distance: "约1.5公里",
                description: "五指山市商业中心，购物休闲",
                coordinate: Coordinate(latitude: 18.773, longitude: 109.520)),
        Amenity(id: "5", name: "海南省第二人民医院", category: .medical, distance: "约3公里",
                description: "二级甲等综合医院",
                coordinate: Coordinate(latitude: 18.780, longitude: 109.510)),
        Amenity(id: "6", name: "五指山汽车站", category: .transport, distance: "约2公里",
                description: nil,
                coordinate: Coordinate(latitude: 18.772, longitude: 109.515)),
        Amenity(id: "7", name: "海南热带雨林国家公园", category: .leisure, distance: "约5公里",
                description: "国家级自然保护区，天然氧吧",
                coordinate: Coordinate(latitude: 18.800, longitude: 109.540)),
        Amenity(id: "8", name: "五指山黎苗风情街", category: .dining, distance: "约2公里",
                description: "黎苗特色美食与民族文化体验",
                coordinate: Coordinate(latitude: 18.771, longitude: 109.522)),
    ]

    var filteredAmenities: [Amenity] {
        guard let category = selectedCategory else { return amenities }
        return amenities.filter { $0.category == category }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    mapArea
                    amenitiesSection
                }
                .padding(16)
            }
            .background(AppTheme.background)
            .navigationTitle("位置配套")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 地图区域

    private var mapArea: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("项目位置")
                .font(.brandSubtitle)
                .foregroundColor(AppTheme.textPrimary)

            // MapKit 地图
            Map(position: $camera) {
                // 项目位置标记
                Marker("绿城如意山居", systemImage: "building.columns.fill", coordinate: Self.projectCoordinate)
                    .tint(AppTheme.primary)

                // 周边配套标记
                ForEach(amenities) { amenity in
                    if let coord = amenity.coordinate?.clLocation {
                        Marker(amenity.name, systemImage: amenity.category.iconName, coordinate: coord)
                            .tint(categoryColor(amenity.category))
                    }
                }
            }
            .mapStyle(.standard(pointsOfInterest: .excludingAll))
            .frame(height: 280)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.1), radius: 6, y: 3)

            // 地址信息
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.primary)
                Text("海南省五指山市·如意山居")
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
                Spacer()
                Button {
                    openInMaps()
                } label: {
                    Text("导航")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(AppTheme.primary)
                        )
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: .black.opacity(0.03), radius: 3, y: 1)
            )
        }
    }

    // MARK: - 配套

    private var amenitiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 18)
                Text("周边配套")
                    .font(.brandSubtitle)
                    .foregroundColor(AppTheme.textPrimary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(
                        title: "全部",
                        isSelected: selectedCategory == nil,
                        action: { selectedCategory = nil }
                    )
                    ForEach(AmenityCategory.allCases) { category in
                        FilterChip(
                            title: category.rawValue,
                            isSelected: selectedCategory == category,
                            action: { selectedCategory = category }
                        )
                    }
                }
            }

            VStack(spacing: 8) {
                ForEach(filteredAmenities) { amenity in
                    Button {
                        if let coord = amenity.coordinate?.clLocation {
                            selectedAmenity = amenity
                            withAnimation(.easeInOut(duration: 0.5)) {
                                camera = .region(MKCoordinateRegion(
                                    center: coord,
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                ))
                            }
                        }
                    } label: {
                        AmenityRow(amenity: amenity)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - 辅助

    private func categoryColor(_ category: AmenityCategory) -> Color {
        switch category {
        case .education: return .blue
        case .shopping: return .orange
        case .medical: return .red
        case .transport: return .purple
        case .leisure: return .green
        case .dining: return .yellow
        }
    }

    private func openInMaps() {
        let lat = Self.projectCoordinate.latitude
        let lon = Self.projectCoordinate.longitude
        let urlString = "http://maps.apple.com/?q=\(lat),\(lon)&ll=\(lat),\(lon)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct AmenityRow: View {
    let amenity: Amenity

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: amenity.category.iconName)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(categoryColor)
                )

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(amenity.name)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)

                    if let distance = amenity.distance {
                        Text(distance)
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.primary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(AppTheme.primaryLight)
                            )
                    }
                }

                if let description = amenity.description {
                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 11))
                .foregroundColor(AppTheme.textSecondary.opacity(0.3))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.03), radius: 3, y: 1)
        )
    }

    private var categoryColor: Color {
        switch amenity.category {
        case .education: return .blue
        case .shopping: return .orange
        case .medical: return .red
        case .transport: return .purple
        case .leisure: return .green
        case .dining: return .yellow
        }
    }
}
