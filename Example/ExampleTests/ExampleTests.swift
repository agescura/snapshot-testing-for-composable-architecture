//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by Albert Gil Escura on 25/9/22.
//

import XCTest
@testable import Example
import ComposableArchitecture
import SnapshotTesting
import SnapshotTestingComposableArchitecture

@MainActor
final class ExampleTests: XCTestCase {

    func testHappyPath() async throws {
        SnapshotTesting.diffTool = "ksdiff"

        
        let store = TestStore(
            initialState: .init(),
            reducer: counterReducer,
            environment: .init(
                mainQueue: .immediate
            )
        )
        
        await store.send(.incrementButtonTapped, view: CounterView.init(store:), as: .image(layout: .device(config: .iPhone13))) {
            $0.count = 1
            $0.status = .loading
        }
        
        await store.receive(.delaySideEffect, view: CounterView.init(store:), as: .image(layout: .device(config: .iPhone13))) {
            $0.status = .idle
        }
        
        await store.send(.decrementButtonTapped, view: CounterView.init(store:), as: .image(layout: .device(config: .iPhone13))) {
            $0.count = 0
            $0.status = .loading
        }
        
        await store.receive(.delaySideEffect, view: CounterView.init(store:), as: .image(layout: .device(config: .iPhone13))) {
            $0.status = .idle
        }
    }
}
