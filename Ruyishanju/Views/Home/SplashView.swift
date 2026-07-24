//
//  SplashView.swift
//  Ruyishanju
//
//  启动页 — 品牌展示，淡入主界面
//

import SwiftUI

struct SplashView: View {
    @State private var opacity: Double = 0
    @State private var textOffset: CGFloat = 30
    var onComplete: () -> Void

    var body: some View {
        ZStack {
            // 品牌渐变背景
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.16, blue: 0.12),
                    AppTheme.primary,
                    Color(red: 0.12, green: 0.22, blue: 0.18),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // 山形装饰（底部）
            VStack {
                Spacer()
                MountainSilhouette()
                    .fill(
                        LinearGradient(
                            colors: [
                                AppTheme.primaryLight.opacity(0.3),
                                AppTheme.primaryLight.opacity(0.05),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 300)
            }
            .ignoresSafeArea()

            // 品牌内容
            VStack(spacing: 24) {
                Spacer()

                // 图标
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.1))
                        .frame(width: 100, height: 100)

                    Image(systemName: "building.columns.fill")
                        .font(.system(size: 44, weight: .light))
                        .foregroundColor(.white)
                }
                .shadow(color: .white.opacity(0.2), radius: 20)

                // 项目名
                Text("绿城如意山居")
                    .font(.system(size: 34, weight: .semibold, design: .serif))
                    .foregroundColor(.white)
                    .tracking(2)

                // Slogan
                Text("人生如意 自在山")
                    .font(.system(size: 18, weight: .light, design: .serif))
                    .foregroundColor(.white.opacity(0.7))
                    .tracking(6)

                Spacer()

                // 底部加载提示
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white.opacity(0.6)))
                    .scaleEffect(0.8)

                Spacer().frame(height: 120)
            }
            .opacity(opacity)
            .offset(y: textOffset)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                opacity = 1
                textOffset = 0
            }
            // 2 秒后进入主界面
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    onComplete()
                }
            }
        }
    }
}

/// 山形背景剪影
struct MountainSilhouette: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        path.move(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: 0, y: h * 0.6))
        path.addLine(to: CGPoint(x: w * 0.15, y: h * 0.2))
        path.addLine(to: CGPoint(x: w * 0.3, y: 0))
        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.1))
        path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.25))
        path.addLine(to: CGPoint(x: w * 0.85, y: 0))
        path.addLine(to: CGPoint(x: w, y: h * 0.4))
        path.addLine(to: CGPoint(x: w, y: h))
        path.closeSubpath()
        return path
    }
}

#Preview {
    SplashView(onComplete: {})
}
