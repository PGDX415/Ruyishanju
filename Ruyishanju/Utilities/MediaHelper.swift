//
//  MediaHelper.swift
//  Ruyishanju
//
//  媒体资源加载工具 — 支持子目录路径加载
//

import SwiftUI

/// 媒体资源管理器
enum MediaHelper {

    /// 从 Bundle 根目录按文件名加载图片（PBXFileSystemSynchronizedRootGroup 会扁平化子目录）
    static func image(named filename: String) -> Image {
        guard !filename.isEmpty else {
            return Image(systemName: "house.lodge.fill")
        }
        if let uiImage = loadUIImage(filename) {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "photo.badge.exclamationmark")
    }

    /// 按文件名加载 UIImage（自动尝试扩展名，文件已在 Bundle 根目录）
    static func loadUIImage(_ filename: String) -> UIImage? {
        // 先尝试带扩展名的精确匹配
        let nameWithoutExt = (filename as NSString).deletingPathExtension
        let ext = (filename as NSString).pathExtension

        if !ext.isEmpty {
            if let url = Bundle.main.url(forResource: nameWithoutExt, withExtension: ext),
               let image = UIImage(contentsOfFile: url.path) {
                return image
            }
        }

        // 再尝试常见扩展名
        for extTry in ["png", "PNG", "jpg", "JPG", "jpeg", "JPEG"] {
            if let url = Bundle.main.url(forResource: nameWithoutExt, withExtension: extTry),
               let image = UIImage(contentsOfFile: url.path) {
                return image
            }
        }
        return nil
    }

    // MARK: - 户型图（4张，白底线稿）

    enum Floorplan: String, CaseIterable, Identifiable {
        case fp01 = "floorplan_01"
        case fp02 = "floorplan_02"
        case fp03 = "floorplan_03"
        case fp04 = "floorplan_04"

        var id: String { rawValue }
        var image: Image { MediaHelper.image(named: rawValue) }
    }

    // MARK: - 图库照片（20张实景/渲染）

    /// 所有图库照片枚举
    enum GalleryPhoto: String, CaseIterable, Identifiable {
        case photo01 = "photo_01"
        case photo02 = "photo_02"
        case photo03 = "photo_03"
        case photo04 = "photo_04"
        case photo05 = "photo_05"
        case photo06_hero = "photo_06_hero"
        case photo07 = "photo_07"
        case photo08 = "photo_08"
        case photo09 = "photo_09"
        case photo10 = "photo_10"
        case photo11 = "photo_11"
        case photo12 = "photo_12"
        case photo13 = "photo_13"
        case photo14 = "photo_14"
        case photo15 = "photo_15"
        case photo16 = "photo_16"
        case photo17 = "photo_17"
        case photo18_pano = "photo_18_pano"
        case photo19_pano = "photo_19_pano"
        case photo20 = "photo_20"

        var id: String { rawValue }
        var image: Image { MediaHelper.image(named: rawValue) }
        var displayName: String {
            if rawValue.contains("hero") { return "项目全景" }
            if rawValue.contains("pano") { return "全景视野" }
            return "实景 \(rawValue.replacingOccurrences(of: "photo_", with: "").prefix(2))"
        }
    }

    // MARK: - 常用快捷引用

    /// Hero 大图（首页 / 展厅背景）
    static var heroImage: Image { GalleryPhoto.photo06_hero.image }

    /// 获取一个随机图库图片
    static var randomGalleryImage: Image {
        let all = GalleryPhoto.allCases.filter { !$0.rawValue.contains("hero") }
        return all.randomElement()?.image ?? GalleryPhoto.photo01.image
    }

    /// 根据索引获取图库图片（用于循环展示）
    static func galleryImage(at index: Int) -> Image {
        let photos = GalleryPhoto.allCases
        return photos[index % photos.count].image
    }
}

/// 图库分类
enum GalleryCategory: String, CaseIterable, Identifiable {
    case all = "全部"
    case exterior = "建筑外观"
    case indoor = "室内空间"
    case render = "效果图"

    var id: String { rawValue }
}

