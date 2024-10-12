//
//  UIView+Preview.swift
//  Mashow
//
//  Created by Kai Lee on 7/18/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import SwiftUI

/// A `UIViewControllerRepresentable` SwiftUI `View` that wraps its `Content`
struct SwiftUIView<Content: UIView> {
    /// A closure that's invoked to construct the represented content view.
    var makeContent: () -> Content
    
    /// Creates a SwiftUI representation of the content view with the provided `makeContent` closure
    /// to construct it whenever `makeUIViewController(…)` is invoked.
    init(makeContent: @escaping () -> Content) {
        self.makeContent = makeContent
    }
}

// MARK: - UIViewRepresentable
extension SwiftUIView: UIViewRepresentable {
    func makeUIView(context: Context) -> Content {
        makeContent()
    }
    
    func updateUIView(_ uiView: Content, context: Context) {}
}

// MARK: - ViewType
/// A protocol that all `UIView`s conform to, enabling extensions that have a `Self` reference.
protocol ViewType: UIView {}

// MARK: - ViewType + ViewTypeProtocol
extension UIView: ViewType {}

// MARK: - ViewTypeProtocol + preview
extension ViewType {
    /// 주어진 `makeView` 클로저를 이용해 `UIView`를 나타내는 SwiftUI `View`를 반환합니다.
    ///
    /// ```
    /// MyUIView.preview {
    ///    return MyUIView()
    /// }
    /// ```
    static func preview(makeView: @escaping () -> Self) -> SwiftUIView<Self> {
        SwiftUIView(makeContent: makeView)
    }
    
    /// 초기화된 `UIView`를 기본 생성자로 생성하여 SwiftUI `View`를 반환합니다.
    ///
    /// `MyUIView.preview()`
    static func preview() -> SwiftUIView<Self> {
        let defaultMakeView = { Self.init() }
        return preview(makeView: defaultMakeView)
    }
}

