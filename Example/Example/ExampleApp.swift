//
//  ExampleApp.swift
//  Example
//
//  Created by Albert Gil Escura on 25/9/22.
//

import SwiftUI
import ComposableArchitecture

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: .init(
                    initialState: .init(),
                    reducer: counterReducer,
                    environment: .init(
                        mainQueue: .main
                    )
                )
            )
        }
    }
}
