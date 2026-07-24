//
//  DataLoader.swift
//  Ruyishanju
//
//  JSON 数据加载工具
//

import Foundation

/// 本地 JSON 数据加载器
enum DataLoader {
    /// 从 Bundle 加载并解码 JSON 数据
    static func load<T: Codable>(_ filename: String, as type: T.Type = T.self) -> T? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil),
              let data = try? Data(contentsOf: url) else {
            print("❌ DataLoader: 未找到文件 \(filename)")
            return nil
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("❌ DataLoader: 解析 \(filename) 失败 — \(error)")
            return nil
        }
    }
}
