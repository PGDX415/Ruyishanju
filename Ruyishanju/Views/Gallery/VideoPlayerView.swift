//
//  VideoPlayerView.swift
//  Ruyishanju
//
//  宣传片播放器
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoName: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            if let url = Bundle.main.url(forResource: videoName, withExtension: nil) ??
               Bundle.main.url(forResource: videoName, withExtension: "mp4") ??
               Bundle.main.url(forResource: "Data/Media/video/\(videoName)", withExtension: nil) {
                VideoPlayer(player: AVPlayer(url: url))
                    .ignoresSafeArea()
                    .onAppear {
                        // 循环播放
                        NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: nil,
                            queue: .main
                        ) { _ in
                            // 可选：循环
                        }
                    }
            } else {
                ContentUnavailableView(
                    "视频暂不可用",
                    systemImage: "video.slash",
                    description: Text("请确认视频文件已正确导入")
                )
            }
        }
    }
}

/// 带缩略图的视频入口
struct VideoThumbnailCard: View {
    let title: String
    let duration: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(AppTheme.primary.opacity(0.08))
                    .frame(height: 180)

                VStack(spacing: 10) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(AppTheme.primary)

                    Text(title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)

                    Text(duration)
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VideoPlayerView(videoName: "promo.mp4")
}
