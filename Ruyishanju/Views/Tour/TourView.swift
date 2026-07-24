//
//  TourView.swift
//  Ruyishanju
//
//  3D 户型漫游 — 3D 旋转俯瞰 + 房间漫游导览
//

import SwiftUI

struct TourView: View {
    @State private var unitTypes: [UnitType] = []
    @State private var selectedUnitID: String = ""
    @State private var mode: TourMode = .explore3D

    // 3D 旋转状态
    @State private var rotationY: Double = 25
    @State private var tiltX: Double = 55
    @State private var scale: CGFloat = 1.0
    @State private var dragRotation: Double = 0
    @State private var isDragging = false

    // 房间漫游
    @State private var currentRoomIndex: Int = 0
    @State private var showRoomDetail = false

    enum TourMode: String, CaseIterable {
        case explore3D = "3D 俯瞰"
        case roomWalk = "房间漫游"
    }

    struct TourRoom: Identifiable {
        let id: Int
        let name: String
        let position: String  // "南"/"北"/"东"/"西"
        let size: String
        let features: String
        /// 房间在地图上的相对位置 (x, y, w, h)，0~1
        let rect: (CGFloat, CGFloat, CGFloat, CGFloat)
    }

    /// 100㎡ 房间布局
    let rooms100: [TourRoom] = [
        TourRoom(id: 1, name: "客厅", position: "南", size: "4.5m × 5.4m",
                 features: "约6.8米宽景阳台相连，南北通透采光极佳", rect: (0.05, 0.38, 0.55, 0.35)),
        TourRoom(id: 2, name: "主卧", position: "南", size: "3.6m × 4.2m",
                 features: "主卧套房，独立卫浴+步入式衣帽间，南向飘窗", rect: (0.62, 0.38, 0.33, 0.35)),
        TourRoom(id: 3, name: "次卧", position: "北", size: "3.2m × 3.6m",
                 features: "北向静区，可做儿童房或书房，全明设计", rect: (0.05, 0.05, 0.33, 0.28)),
        TourRoom(id: 4, name: "餐厅", position: "北", size: "3.0m × 3.6m",
                 features: "与客厅LDK一体化设计，空间通透流畅", rect: (0.42, 0.10, 0.30, 0.22)),
        TourRoom(id: 5, name: "厨房", position: "北", size: "2.4m × 2.8m",
                 features: "U型厨房动线流畅，明厨通风，紧邻餐厅", rect: (0.75, 0.05, 0.20, 0.28)),
        TourRoom(id: 6, name: "阳台", position: "南", size: "6.8m × 1.8m",
                 features: "超宽景观阳台，揽五指山色入室", rect: (0.05, 0.75, 0.90, 0.15)),
    ]

    /// 120㎡ 房间布局
    let rooms120: [TourRoom] = [
        TourRoom(id: 1, name: "客厅", position: "南", size: "4.8m × 6.0m",
                 features: "约7.5米跑道式阳台，LDK一体，奢阔通透", rect: (0.05, 0.35, 0.55, 0.38)),
        TourRoom(id: 2, name: "主卧", position: "南", size: "3.8m × 4.5m",
                 features: "双主卧套房之一，独立卫浴+衣帽间+飘窗", rect: (0.62, 0.38, 0.33, 0.35)),
        TourRoom(id: 3, name: "次卧A", position: "南", size: "3.4m × 3.8m",
                 features: "南向次主卧，独立卫浴，适合长辈居住", rect: (0.62, 0.05, 0.33, 0.28)),
        TourRoom(id: 4, name: "次卧B", position: "北", size: "3.2m × 3.6m",
                 features: "北向静区，全明设计，可做儿童房或书房", rect: (0.05, 0.05, 0.30, 0.25)),
        TourRoom(id: 5, name: "餐厅", position: "北", size: "3.2m × 3.8m",
                 features: "独立餐厅区域，与客厅和厨房动线流畅", rect: (0.38, 0.10, 0.22, 0.22)),
        TourRoom(id: 6, name: "厨房", position: "北", size: "2.6m × 3.0m",
                 features: "U型明厨，操作台面充裕，紧邻餐厅", rect: (0.80, 0.05, 0.15, 0.25)),
        TourRoom(id: 7, name: "阳台", position: "南", size: "7.5m × 2.0m",
                 features: "超长跑道式阳台，尽揽五指山壮丽山色", rect: (0.05, 0.75, 0.90, 0.15)),
    ]

    private var currentRooms: [TourRoom] {
        selectedUnitID == "type-a-100" ? rooms100 : rooms120
    }

    private var selectedUnit: UnitType? {
        unitTypes.first { $0.id == selectedUnitID }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 户型选择
                unitSelector

                // 模式切换
                modeSelector

                // 主体
                if mode == .explore3D {
                    explore3DView
                } else {
                    roomWalkView
                }
            }
            .background(AppTheme.background)
            .navigationTitle("3D 漫游")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                unitTypes = DataLoader.load("unit_types.json", as: [UnitType].self) ?? []
                if selectedUnitID.isEmpty, let first = unitTypes.first {
                    selectedUnitID = first.id
                }
            }
            .onChange(of: selectedUnitID) { _, _ in
                currentRoomIndex = 0
                withAnimation(.spring(response: 0.6)) {
                    rotationY = 25
                    tiltX = 55
                    dragRotation = 0
                    scale = 1.0
                }
            }
        }
    }

    // MARK: - 户型选择

    private var unitSelector: some View {
        Picker("户型", selection: $selectedUnitID) {
            ForEach(unitTypes) { unit in
                Text(unit.name).tag(unit.id)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    // MARK: - 模式切换

    private var modeSelector: some View {
        HStack(spacing: 12) {
            ForEach(TourMode.allCases, id: \.self) { m in
                Button {
                    withAnimation(.spring(response: 0.5)) { mode = m }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: m == .explore3D ? "cube.transparent.fill" : "figure.walk")
                            .font(.system(size: 13))
                        Text(m.rawValue)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(mode == m ? .white : AppTheme.textSecondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(mode == m ? AppTheme.primary : AppTheme.surface)
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    // MARK: - 3D 俯瞰模式

    private var explore3DView: some View {
        VStack(spacing: 0) {
            // 3D 视图
            GeometryReader { geometry in
                ZStack {
                    // 底座阴影
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.15))
                        .frame(width: geometry.size.width * 0.82, height: geometry.size.height * 0.65)
                        .offset(y: geometry.size.height * 0.08)
                        .blur(radius: 12)

                    // 3D 户型图
                    floorPlanImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.85)
                        .rotation3DEffect(
                            .degrees(tiltX),
                            axis: (x: 1, y: 0, z: 0),
                            perspective: 0.3
                        )
                        .rotation3DEffect(
                            .degrees(rotationY + dragRotation),
                            axis: (x: 0, y: 1, z: 0),
                            perspective: 0.3
                        )
                        .scaleEffect(scale)
                        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)

                    // 房间高亮
                    ForEach(currentRooms) { room in
                        roomHighlight(room, size: geometry.size)
                    }

                    // 指北针
                    compassOverlay(size: geometry.size)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            dragRotation = Double(value.translation.width) * 0.3
                        }
                        .onEnded { value in
                            rotationY += Double(value.translation.width) * 0.3
                            dragRotation = 0
                            isDragging = false
                            // 吸附到最近 45°
                            let nearest = round(rotationY / 45) * 45
                            withAnimation(.spring(response: 0.4)) {
                                rotationY = nearest
                            }
                        }
                )
            }
            .background(
                LinearGradient(
                    colors: [
                        AppTheme.background,
                        AppTheme.surface,
                        AppTheme.background
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            // 底部控制
            controlPanel
        }
    }

    private func roomHighlight(_ room: TourRoom, size: CGSize) -> some View {
        let imgW = size.width * 0.85
        let imgH = size.height * 0.65
        let offsetX = (size.width - imgW) / 2
        let offsetY = (size.height - imgH) / 2

        return RoundedRectangle(cornerRadius: 4)
            .stroke(
                currentRoomIndex + 1 == room.id ? AppTheme.wood : AppTheme.primary.opacity(0.3),
                lineWidth: currentRoomIndex + 1 == room.id ? 2 : 1
            )
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(currentRoomIndex + 1 == room.id
                          ? AppTheme.wood.opacity(0.15)
                          : Color.clear)
            )
            .frame(
                width: imgW * room.rect.2,
                height: imgH * room.rect.3
            )
            .position(
                x: offsetX + imgW * (room.rect.0 + room.rect.2 / 2),
                y: offsetY + imgH * (room.rect.1 + room.rect.3 / 2)
            )
            .rotation3DEffect(.degrees(tiltX), axis: (x: 1, y: 0, z: 0), perspective: 0.3)
            .rotation3DEffect(.degrees(rotationY + dragRotation), axis: (x: 0, y: 1, z: 0), perspective: 0.3)
            .allowsHitTesting(false)
    }

    private func compassOverlay(size: CGSize) -> some View {
        VStack(spacing: 2) {
            Image(systemName: "arrow.up")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(AppTheme.primary)
            Text("N")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(AppTheme.primary)
        }
        .rotation3DEffect(.degrees(-rotationY - dragRotation), axis: (x: 0, y: 1, z: 0))
        .position(x: size.width * 0.88, y: size.height * 0.12)
    }

    private var controlPanel: some View {
        VStack(spacing: 12) {
            // 旋转角度
            VStack(spacing: 4) {
                HStack {
                    Text("水平旋转")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                    Spacer()
                    Text("\(Int(rotationY + dragRotation))°")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(AppTheme.primary)
                }
                Slider(value: $rotationY, in: -90...90, step: 1)
                    .tint(AppTheme.primary)
            }

            // 俯仰角度
            VStack(spacing: 4) {
                HStack {
                    Text("俯仰视角")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                    Spacer()
                    Text("\(Int(tiltX))°")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(AppTheme.primary)
                }
                Slider(value: $tiltX, in: 10...80, step: 1)
                    .tint(AppTheme.primary)
            }

            // 快捷角度
            HStack(spacing: 8) {
                quickAngleButton("2D", rotation: 0, tilt: 0)
                quickAngleButton("等轴", rotation: 25, tilt: 55)
                quickAngleButton("前视", rotation: 0, tilt: 75)
                quickAngleButton("侧视", rotation: 75, tilt: 55)
                quickAngleButton("重置", rotation: 25, tilt: 55)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, y: -2)
        )
    }

    private func quickAngleButton(_ label: String, rotation: Double, tilt: Double) -> some View {
        Button {
            withAnimation(.spring(response: 0.5)) {
                rotationY = rotation
                tiltX = tilt
            }
        } label: {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(rotationY == rotation && tiltX == tilt ? .white : AppTheme.textSecondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(rotationY == rotation && tiltX == tilt
                              ? AppTheme.primary : AppTheme.surface)
                )
        }
    }

    // MARK: - 房间漫游模式

    private var roomWalkView: some View {
        VStack(spacing: 0) {
            // 带高亮的户型图
            GeometryReader { geometry in
                ZStack {
                    floorPlanImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.85)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .saturation(currentRoomIndex >= 0 ? 0.3 : 1)

                    // 当前房间高亮
                    let room = currentRooms[currentRoomIndex]
                    let imgW = geometry.size.width * 0.85
                    let imgH = geometry.size.height * 0.85
                    let imgAspect = imgW / imgH

                    RoundedRectangle(cornerRadius: 6)
                        .stroke(AppTheme.wood, lineWidth: 2.5)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(AppTheme.wood.opacity(0.2))
                        )
                        .frame(
                            width: imgW * room.rect.2,
                            height: imgH * room.rect.3 / imgAspect
                        )
                        .position(
                            x: (geometry.size.width - imgW) / 2 + imgW * (room.rect.0 + room.rect.2 / 2),
                            y: (geometry.size.height - imgH) / 2 + imgH * (room.rect.1 + room.rect.3 / 2) / imgAspect
                        )
                }
            }
            .frame(height: 240)
            .background(AppTheme.surface)

            // 房间详情卡片
            roomDetailCard
        }
    }

    private var roomDetailCard: some View {
        let room = currentRooms[currentRoomIndex]
        let total = currentRooms.count

        return VStack(spacing: 16) {
            // 进度条
            HStack(spacing: 4) {
                ForEach(0..<total, id: \.self) { i in
                    Capsule()
                        .fill(i <= currentRoomIndex ? AppTheme.primary : AppTheme.divider)
                        .frame(height: 3)
                }
            }

            // 房间信息
            VStack(spacing: 8) {
                HStack {
                    Text("\(currentRoomIndex + 1)/\(total)")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(AppTheme.textSecondary)
                    Spacer()
                    Text(room.position + "向")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(AppTheme.primary))
                }

                Text(room.name)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)

                HStack(spacing: 16) {
                    Label(room.size, systemImage: "ruler")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.textSecondary)
                }

                Text(room.features)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 8)
            }

            // 导航按钮
            HStack(spacing: 20) {
                Button {
                    withAnimation(.spring(response: 0.4)) {
                        currentRoomIndex = (currentRoomIndex - 1 + total) % total
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppTheme.primary)
                        .frame(width: 48, height: 48)
                        .background(Circle().fill(AppTheme.primaryLight))
                }

                Button {
                    withAnimation(.spring(response: 0.4)) {
                        currentRoomIndex = (currentRoomIndex + 1) % total
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text("下一个")
                            .font(.system(size: 15, weight: .medium))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(AppTheme.primary)
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.06), radius: 8, y: -4)
        )
    }

    // MARK: - 辅助

    private var floorPlanImage: Image {
        guard let unit = selectedUnit else {
            return Image(systemName: "house.lodge")
        }
        if !unit.floorPlanImage.isEmpty {
            return MediaHelper.image(named: unit.floorPlanImage)
        }
        let floorplans = MediaHelper.Floorplan.allCases
        let index = abs(unit.id.hashValue) % floorplans.count
        return floorplans[index].image
    }
}

#Preview {
    TourView()
}
