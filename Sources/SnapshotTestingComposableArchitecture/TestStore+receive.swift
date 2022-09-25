//
//  File.swift
//  
//
//  Created by Albert Gil Escura on 25/9/22.
//

import Foundation
import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import XCTest

extension TestStore where Action: Equatable, ScopedState: Equatable {
    @MainActor
    public func receive<V: View, Format>(
        _ action: Action,
        view: @escaping (Store<ScopedState, ScopedAction>) -> V,
        as snapshotting: Snapshotting<V, Format>,
        _ updateExpectingResult: ((inout ScopedState) throws -> Void)? = nil,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) async {
        await receive(action) { state in
            do {
                try updateExpectingResult?(&state)
            } catch {
                XCTFail("Threw error: \(error)", file: file, line: line)
            }
            let store = Store<ScopedState, ScopedAction>(initialState: state, reducer: .empty, environment: ())
            let view = view(store)
            assertSnapshot(matching: view, as: snapshotting, file: file, testName: testName, line: line)
        }
    }
}
