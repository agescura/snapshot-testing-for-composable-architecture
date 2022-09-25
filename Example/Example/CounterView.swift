//
//  ContentView.swift
//  Example
//
//  Created by Albert Gil Escura on 25/9/22.
//

import SwiftUI
import ComposableArchitecture

struct CounterState: Equatable {
    var count = 0
    var status: Status = .idle
    
    enum Status: String {
        case idle = "Idle"
        case loading = "Loading"
        
        var isLoading: Bool {
            return self == .loading
        }
    }
}

enum CounterAction: Equatable {
    case incrementButtonTapped
    case decrementButtonTapped
    case delaySideEffect
}

struct CounterEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let counterReducer = Reducer<
    CounterState,
    CounterAction,
    CounterEnvironment
> { state, action, environment in
    switch action {
    case .decrementButtonTapped:
        state.count -= 1
        state.status = .loading
        return Effect(value: .delaySideEffect)
            .delay(for: 1, scheduler: environment.mainQueue)
            .eraseToEffect()
        
    case .incrementButtonTapped:
        state.count += 1
        state.status = .loading
        return Effect(value: .delaySideEffect)
            .delay(for: 1, scheduler: environment.mainQueue)
            .eraseToEffect()
        
    case .delaySideEffect:
        state.status = .idle
        return .none
    }
}

struct CounterView: View {
    let store: Store<CounterState, CounterAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Text(viewStore.status.rawValue)
                HStack {
                    Button("-") { viewStore.send(.decrementButtonTapped) }
                        .disabled(viewStore.status.isLoading)
                    Text("\(viewStore.count)")
                    Button("+") { viewStore.send(.incrementButtonTapped) }
                        .disabled(viewStore.status.isLoading)
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
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
