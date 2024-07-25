import ComposableArchitecture
import Foundation

public struct SearchTextFieldReducer: Reducer, Sendable {
  public struct State: Equatable {
    @BindingState var text: String = ""
  }
  
  public enum Action: BindableAction, Equatable, Sendable {
    // OUTPUT
    case search(text: String)
    // private
    case binding(BindingAction<State>)
    case clearText
    case didTapClearTextButton
    case didTapCancelButton
    case didTapSearchButton
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .search(_):
        return .none
      case .binding:
        return .none
      case .clearText:
        state.text = ""
        return .none
      case .didTapClearTextButton:
        return .run { send in
          await send(.clearText)
        }
      case .didTapCancelButton:
        return .run { send in
          await send(.clearText)
        }
      case .didTapSearchButton:
        let query = state.text
        return .run { send in
          await send(.search(text: query))
        }
      }
    }
  }
}
