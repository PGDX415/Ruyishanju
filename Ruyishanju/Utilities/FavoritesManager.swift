//
//  FavoritesManager.swift
//  Ruyishanju
//
//  收藏管理 — UserDefaults 持久化
//

import SwiftUI

@Observable
final class FavoritesManager {
    private let key = "favorite_unit_ids"

    private(set) var favoritedIDs: Set<String> = []

    init() {
        load()
    }

    func isFavorited(_ unitTypeID: String) -> Bool {
        favoritedIDs.contains(unitTypeID)
    }

    func toggle(_ unitTypeID: String) {
        if favoritedIDs.contains(unitTypeID) {
            favoritedIDs.remove(unitTypeID)
        } else {
            favoritedIDs.insert(unitTypeID)
        }
        save()
    }

    func add(_ unitTypeID: String) {
        favoritedIDs.insert(unitTypeID)
        save()
    }

    func remove(_ unitTypeID: String) {
        favoritedIDs.remove(unitTypeID)
        save()
    }

    private func save() {
        UserDefaults.standard.set(Array(favoritedIDs), forKey: key)
    }

    private func load() {
        if let ids = UserDefaults.standard.array(forKey: key) as? [String] {
            favoritedIDs = Set(ids)
        }
    }
}
