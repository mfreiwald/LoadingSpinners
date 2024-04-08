////
////  ViewVersion.swift
////  LoadingSpinners
////
////  Created by Michael on 26.03.24.
////
//
//import SwiftUI
//
//enum ViewVersion: CaseIterable, Identifiable, Equatable, Hashable, CustomStringConvertible {
//    case none
//    case disabled
//    case spinner
//    case animation
//    case deferred
//
//    var id: Self { self }
//
//    var description: String {
//        switch self {
//        case .none:
//            ""
//        case .disabled:
//            "Disable View"
//        case .spinner:
//            "Loading Spinner"
//        case .animation:
//            "With animation"
//        case .deferred:
//            "Deferred Loading"
//        }
//    }
//
//    var showLoadingSpinner: Bool {
//        switch self {
//        case .none, .disabled, .animation, .deferred:
//            false
//        case .spinner:
//            true
//        }
//    }
//
//    var useHash: Bool {
//        switch self {
//        case .none, .disabled, .animation, .spinner:
//            false
//        case .deferred:
//            true
//        }
//    }
//}
//
//extension ViewVersion: EnvironmentKey {
//    static var defaultValue: Self = .none
//}
//
//extension EnvironmentValues {
//    var viewVersion: ViewVersion {
//        get { self[ViewVersion.self] }
//        set { self[ViewVersion.self] = newValue }
//    }
//}
//
