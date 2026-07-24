//
//  SunlightView.swift
//  Ruyishanju
//
//  日照模拟 — 朝向、日轨、采光分析
//

import SwiftUI

struct SunlightView: View {
    @State private var selectedUnit: UnitTypePreset = .type120
    @State private var selectedSeason: Season = .summer
    @State private var hourOfDay: Double = 12  // 6-18 小时
    @State private var isPlaying = false
    @State private var timer: Timer?

    enum UnitTypePreset: String, CaseIterable {
        case type100 = "100㎡ 云栖"
        case type120 = "120㎡ 山语"

        var orientation: String {
            switch self {
            case .type100: return "南北通透"
            case .type120: return "南北通透"
            }
        }

        var rooms: [Room] {
            switch self {
            case .type100:
                return [
                    Room(name: "主卧", position: .south, size: (3.6, 4.2)),
                    Room(name: "次卧", position: .north, size: (3.2, 3.6)),
                    Room(name: "客厅", position: .south, size: (4.5, 5.4)),
                    Room(name: "餐厅", position: .north, size: (3.0, 3.6)),
                    Room(name: "厨房", position: .north, size: (2.4, 2.8)),
                    Room(name: "阳台", position: .south, size: (6.8, 1.8)),
                ]
            case .type120:
                return [
                    Room(name: "主卧", position: .south, size: (3.8, 4.5)),
                    Room(name: "次卧A", position: .south, size: (3.4, 3.8)),
                    Room(name: "次卧B", position: .north, size: (3.2, 3.6)),
                    Room(name: "客厅", position: .south, size: (4.8, 6.0)),
                    Room(name: "餐厅", position: .north, size: (3.2, 3.8)),
                    Room(name: "厨房", position: .north, size: (2.6, 3.0)),
                    Room(name: "阳台", position: .south, size: (7.5, 2.0)),
                ]
            }
        }
    }

    enum Season: String, CaseIterable {
        case spring = "春分"
        case summer = "夏至"
        case autumn = "秋分"
        case winter = "冬至"

        var sunrise: Double { 6 }   // 用整点简化 实际春分6:00 夏至5:00 冬至7:00
        var sunset: Double { 18 }
        var maxSunAngle: Double {    // 正午太阳高度角（五指山纬度约18.8°N）
            switch self {
            case .spring: return 71   // 春分: 90 - 18.8 ≈ 71°
            case .summer: return 85   // 夏至: 90 - 18.8 + 23.5 ≈ 85°（北回归线以北）
            case .autumn: return 71
            case .winter: return 48   // 冬至: 90 - 18.8 - 23.5 ≈ 48°
            }
        }
        var dayLength: Double {       // 日照时长（小时）
            switch self {
            case .spring: return 12
            case .summer: return 13.5
            case .autumn: return 12
            case .winter: return 10.5
            }
        }
        var label: String { rawValue }
    }

    struct Room: Identifiable {
        let id = UUID()
        let name: String
        let position: RoomPosition
        let size: (width: CGFloat, height: CGFloat)  // 米
    }

    enum RoomPosition: String {
        case north = "北"
        case south = "南"
        case east = "东"
        case west = "西"
    }

    // MARK: - 计算

    /// 当前时刻的太阳角度（弧度，0=东，π/2=南）
    private var sunAngle: Double {
        let progress = (hourOfDay - 6) / 12  // 6-18 → 0-1
        return .pi * progress  // 东→南→西
    }

    /// 房间日照小时（估算）
    private func sunlightHours(for room: Room) -> Double {
        let base = selectedSeason.dayLength
        switch room.position {
        case .south: return base * 0.85  // 南向全天采光好
        case .north: return base * 0.25  // 北向间接光
        case .east:  return base * 0.55  // 东向上午光
        case .west:  return base * 0.50  // 西向下午光
        }
    }

    private func sunlightQuality(for room: Room) -> (String, Color) {
        let hours = sunlightHours(for: room)
        switch hours {
        case ..<4:  return ("较弱", .orange.opacity(0.5))
        case ..<7:  return ("一般", .yellow.opacity(0.6))
        case ..<10: return ("充足", .yellow)
        default:    return ("极佳", Color(red: 1, green: 0.85, blue: 0.2))
        }
    }

    private func roomColor(for room: Room) -> Color {
        switch room.position {
        case .south:
            // 根据时间模拟南向采光变化
            let t = (hourOfDay - 6) / 12
            let brightness = 0.55 + 0.35 * sin(.pi * t)
            return Color(red: 1, green: 0.95 * brightness + 0.75 * (1 - brightness),
                         blue: 0.6 * brightness + 0.45 * (1 - brightness))
        case .north:
            return Color(red: 0.78, green: 0.82, blue: 0.88)
        case .east:
            let t = (hourOfDay - 6) / 12
            let brightness = t < 0.5 ? (0.85 * (1 - 2 * t) + 0.3) : 0.3
            return Color(red: 1, green: 0.95 * brightness + 0.7 * (1 - brightness),
                         blue: 0.65 * brightness + 0.5 * (1 - brightness))
        case .west:
            let t = (hourOfDay - 6) / 12
            let brightness = t > 0.5 ? (0.85 * (2 * t - 1) + 0.3) : 0.3
            return Color(red: 1, green: 0.95 * brightness + 0.7 * (1 - brightness),
                         blue: 0.65 * brightness + 0.5 * (1 - brightness))
        }
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    unitSelector
                    compassSection
                    floorPlanSection
                    timeControl
                    sunlightTable
                }
                .padding(16)
            }
            .background(AppTheme.background)
            .navigationTitle("日照模拟")
            .navigationBarTitleDisplayMode(.large)
            .onDisappear { stopTimer() }
        }
    }

    // MARK: - 户型选择

    private var unitSelector: some View {
        Picker("户型", selection: $selectedUnit) {
            ForEach(UnitTypePreset.allCases, id: \.self) { unit in
                Text(unit.rawValue).tag(unit)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 4)
    }

    // MARK: - 罗盘 + 日轨

    private var compassSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 18)
                Text("朝向与日轨")
                    .font(.brandSubtitle)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Text("\(selectedUnit.orientation) · \(selectedSeason.label)")
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
            }

            ZStack {
                // 罗盘背景
                Circle()
                    .stroke(AppTheme.divider, lineWidth: 1)
                    .background(Circle().fill(AppTheme.cardBackground))

                // 方向标识
                compassLabel("N", at: 0, yOffset: -95)
                compassLabel("S", at: .pi, yOffset: 95)
                compassLabel("E", at: .pi/2, xOffset: 95)
                compassLabel("W", at: -.pi/2, xOffset: -95)

                // 十字线
                Path { path in
                    path.move(to: CGPoint(x: 0, y: -100))
                    path.addLine(to: CGPoint(x: 0, y: 100))
                    path.move(to: CGPoint(x: -100, y: 0))
                    path.addLine(to: CGPoint(x: 100, y: 0))
                }
                .stroke(AppTheme.divider.opacity(0.5), lineWidth: 0.5)

                // 日轨弧线（东→南→西）
                SunPathArc(season: selectedSeason)
                    .stroke(
                        LinearGradient(
                            colors: [.orange.opacity(0.2), .yellow, .orange.opacity(0.2)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [6, 3])
                    )
                    .frame(width: 140, height: 140)

                // 太阳
                Circle()
                    .fill(Color.orange)
                    .frame(width: 18, height: 18)
                    .overlay(Circle().fill(Color.yellow).frame(width: 8, height: 8).offset(x: -2, y: -2))
                    .shadow(color: .orange.opacity(0.6), radius: 12)
                    .offset(sunPosition)

                // 建筑朝向指示
                buildingIndicator
            }
            .frame(width: 220, height: 220)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    private var sunPosition: CGSize {
        let radius: CGFloat = 70
        let adjustedAngle = sunAngle + .pi  // 东在左，南在下
        return CGSize(
            width: radius * CGFloat(cos(adjustedAngle)),
            height: radius * CGFloat(sin(adjustedAngle))
        )
    }

    private var buildingIndicator: some View {
        // 南北通透建筑示意
        VStack(spacing: 2) {
            RoundedRectangle(cornerRadius: 3)
                .fill(AppTheme.primary.opacity(0.3))
                .frame(width: 40, height: 16)
            Text("N")
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(AppTheme.primary.opacity(0.5))
        }
        .rotationEffect(.degrees(0))
    }

    // MARK: - 户型采光平面图

    private var floorPlanSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 18)
                Text("户型采光模拟")
                    .font(.brandSubtitle)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                HStack(spacing: 6) {
                    Circle().fill(Color(red: 1, green: 0.9, blue: 0.5)).frame(width: 8, height: 8)
                    Text("直射光").font(.system(size: 10)).foregroundColor(AppTheme.textSecondary)
                    Circle().fill(Color(red: 0.78, green: 0.82, blue: 0.88)).frame(width: 8, height: 8)
                    Text("间接光").font(.system(size: 10)).foregroundColor(AppTheme.textSecondary)
                }
            }

            VStack(spacing: 3) {
                // 北侧标识
                HStack {
                    Spacer()
                    Text("↑ 北")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(red: 0.4, green: 0.5, blue: 0.6))
                    Spacer()
                }
                .padding(.bottom, 4)

                // 房间布局示意
                VStack(spacing: 4) {
                    ForEach(["north", "middle", "south"], id: \.self) { zone in
                        HStack(spacing: 4) {
                            ForEach(roomsInZone(zone)) { room in
                                roomBlock(room)
                            }
                        }
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.97, green: 0.96, blue: 0.94))
                )

                // 南侧标识
                HStack {
                    Spacer()
                    Text("↓ 南")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(red: 0.9, green: 0.65, blue: 0.2))
                    Spacer()
                }
                .padding(.top, 4)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    private func roomsInZone(_ zone: String) -> [Room] {
        let rooms = selectedUnit.rooms
        switch zone {
        case "north": return rooms.filter { $0.position == .north }
        case "south": return rooms.filter { $0.position == .south }
        case "middle": return rooms.filter { $0.position == .east || $0.position == .west }
        default: return []
        }
    }

    private func roomBlock(_ room: Room) -> some View {
        let w = max(room.size.width * 12, 40)
        let h: CGFloat = 36

        return VStack(spacing: 2) {
            Text(room.name)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)
            Text("\(String(format: "%.1f", room.size.width))×\(String(format: "%.1f", room.size.height))m")
                .font(.system(size: 8))
                .foregroundColor(AppTheme.textSecondary.opacity(0.6))
        }
        .frame(width: w, height: h)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(roomColor(for: room).opacity(0.7))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(AppTheme.divider, lineWidth: 0.5)
        )
    }

    // MARK: - 时间控制

    private var timeControl: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 18)
                Text("时刻调节")
                    .font(.brandSubtitle)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()

                // 季节切换
                Picker("", selection: $selectedSeason) {
                    ForEach(Season.allCases, id: \.self) { season in
                        Text(season.label).tag(season)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 200)
            }

            VStack(spacing: 8) {
                HStack {
                    Text("06:00")
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textSecondary)
                    Spacer()
                    Text(timeString)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(AppTheme.primary)
                    Spacer()
                    Text("18:00")
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textSecondary)
                }

                Slider(value: $hourOfDay, in: 6...18, step: 0.5)
                    .tint(
                        LinearGradient(
                            colors: [.orange.opacity(0.5), .yellow, .orange, .red.opacity(0.6)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                HStack(spacing: 12) {
                    Button {
                        hourOfDay = 8
                    } label: {
                        Text("早晨")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(hourOfDay == 8 ? .white : AppTheme.textSecondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(hourOfDay == 8 ? .orange : AppTheme.surface)
                            )
                    }
                    .buttonStyle(.plain)

                    Button {
                        hourOfDay = 12
                    } label: {
                        Text("正午")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(hourOfDay == 12 ? .white : AppTheme.textSecondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(hourOfDay == 12 ? .yellow : AppTheme.surface)
                            )
                    }
                    .buttonStyle(.plain)

                    Button {
                        hourOfDay = 16
                    } label: {
                        Text("傍晚")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(hourOfDay == 16 ? .white : AppTheme.textSecondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(hourOfDay == 16 ? .orange.opacity(0.7) : AppTheme.surface)
                            )
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    // 播放/暂停
                    Button {
                        isPlaying.toggle()
                        if isPlaying { startTimer() } else { stopTimer() }
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(AppTheme.primary))
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    private var timeString: String {
        let h = Int(hourOfDay)
        let m = Int((hourOfDay - Double(h)) * 60)
        return String(format: "%02d:%02d", h, m)
    }

    // MARK: - 日照表格

    private var sunlightTable: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 18)
                Text("各房间日照分析")
                    .font(.brandSubtitle)
                    .foregroundColor(AppTheme.textPrimary)
            }

            VStack(spacing: 0) {
                // 表头
                HStack(spacing: 0) {
                    tableHeader("房间", width: 70)
                    tableHeader("朝向", width: 50)
                    tableHeader("日照时长", width: 90)
                    tableHeader("采光评价", width: nil)
                }
                .padding(.vertical, 10)
                .background(AppTheme.surface)

                Divider().background(AppTheme.divider)

                // 数据行
                ForEach(Array(selectedUnit.rooms.enumerated()), id: \.element.id) { _, room in
                    let quality = sunlightQuality(for: room)
                    HStack(spacing: 0) {
                        tableCell(room.name, width: 70, bold: true)
                        tableCell(room.position.rawValue, width: 50)
                        tableCell(String(format: "%.1f h", sunlightHours(for: room)), width: 90)
                        HStack {
                            Circle()
                                .fill(quality.1)
                                .frame(width: 8, height: 8)
                            Text(quality.0)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(AppTheme.textPrimary)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 8)

                    if room.id != selectedUnit.rooms.last?.id {
                        Divider().background(AppTheme.divider)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.bottom, 24)
    }

    // MARK: - 辅助

    private func compassLabel(_ text: String, at angle: Double, xOffset: CGFloat = 0, yOffset: CGFloat = 0) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(AppTheme.textSecondary)
            .offset(x: xOffset, y: yOffset)
    }

    private func tableHeader(_ text: String, width: CGFloat?) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(AppTheme.textSecondary)
            .frame(width: width, alignment: .leading)
    }

    private func tableCell(_ text: String, width: CGFloat, bold: Bool = false) -> some View {
        Text(text)
            .font(.system(size: 13, weight: bold ? .semibold : .regular))
            .foregroundColor(AppTheme.textPrimary)
            .frame(width: width, alignment: .leading)
    }

    // MARK: - 定时器

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
            hourOfDay += 0.15
            if hourOfDay > 18 {
                hourOfDay = 6
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isPlaying = false
    }
}

// MARK: - 日轨弧线 Shape

struct SunPathArc: Shape {
    let season: SunlightView.Season

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2 - 30

        // 夏季太阳更高，弧线更扁平；冬季更低，弧线更弯
        let controlYOffset: CGFloat = {
            switch season {
            case .summer: return -radius * 0.15  // 高弧线
            case .winter: return radius * 0.35   // 低弧线
            default:      return radius * 0.05
            }
        }()

        let startAngle = Angle.degrees(180)
        let endAngle = Angle.degrees(0)

        path.addArc(
            center: CGPoint(x: center.x, y: center.y + controlYOffset),
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )

        return path
    }
}

#Preview {
    SunlightView()
}
