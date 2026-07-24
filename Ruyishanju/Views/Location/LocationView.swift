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
            center: CLLocationCoordinate2D(latitude: 30.258, longitude: 120.15),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    )
    @State private var selectedAmenity: Amenity?

    /// 项目位置
    static let projectCoordinate = CLLocationCoordinate2D(latitude: 30.258, longitude: 120.15)

    let amenities: [Amenity] = [
        Amenity(id: "1", name: "南山实验小学", category: .education, distance: "步行8分钟", description: "市重点小学",
                coordinate: Coordinate(latitude: 30.261, longitude: 120.148)),
        Amenity(id: "2", name: "南山第一中学", category: .education, distance: "车程5分钟", description: "省级示范中学",
                coordinate: Coordinate(latitude: 30.254, longitude: 120.158)),
        Amenity(id: "3", name: "万象城购物中心", category: .shopping, distance: "车程10分钟", description: "大型商业综合体",
                coordinate: Coordinate(latitude: 30.250, longitude: 120.142)),
        Amenity(id: "4", name: "市第三人民医院", category: .medical, distance: "车程8分钟", description: "三甲医院",
                coordinate: Coordinate(latitude: 30.263, longitude: 120.155)),
        Amenity(id: "5", name: "地铁3号线南山站", category: .transport, distance: "步行12分钟", description: nil,
                coordinate: Coordinate(latitude: 30.255, longitude: 120.145)),
        Amenity(id: "6", name: "南山森林公园", category: .leisure, distance: "步行5分钟", description: "城市绿肺",
                coordinate: Coordinate(latitude: 30.262, longitude: 120.155)),
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
                Text("南山风景区·如意路88号")
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
                    .fill(Color.white)
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
                .fill(Color.white)
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
