//
//  Todo.swift
//  Todo
//
//  Created by masato yoshida on 2025/01/31.
//
import Foundation

struct Todo:Hashable, Codable, Identifiable {
    let id: UUID
    let value: String
}
