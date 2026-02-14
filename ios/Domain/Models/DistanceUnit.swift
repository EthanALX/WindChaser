//  DistanceUnit.swift
//  RunningOS
//
//  Distance unit enumeration for metric and imperial measurements
//

import Foundation

enum DistanceUnit: Int, Codable, CaseIterable {
    case miles
    case kilometers

    var abbreviation: String {
        switch self {
        case .miles:
            return "mi"
        case .kilometers:
            return "km"
        }
    }

    var speedAbbreviation: String {
        switch self {
        case .miles:
            return "mph"
        case .kilometers:
            return "km/h"
        }
    }

    var fullName: String {
        switch self {
        case .miles:
            return "miles"
        case .kilometers:
            return "kilometers"
        }
    }

    var fullNameSingular: String {
        switch self {
        case .miles:
            return "mile"
        case .kilometers:
            return "kilometer"
        }
    }
    
    /// Converts meters to the current unit
    func convert(meters: Double) -> Double {
        switch self {
        case .miles:
            return meters / 1609.34
        case .kilometers:
            return meters / 1000.0
        }
    }
    
    /// Converts from current unit to meters
    func toMeters(value: Double) -> Double {
        switch self {
        case .miles:
            return value * 1609.34
        case .kilometers:
            return value * 1000.0
        }
    }
}
