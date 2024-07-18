//
//  Preview.swift
//  MashowKit
//
//  Created by Kai Lee on 7/18/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import SwiftUI

/// A `UIViewControllerRepresentable` SwiftUI `View` that wraps its `Content`
struct SwiftUIViewController<Content: UIViewController> {
    /// A closure that's invoked to construct the represented content view.
    var makeContent: () -> Content
    
    /// Creates a SwiftUI representation of the content view with the provided `makeContent` closure
    /// to construct it whenever `makeUIViewController(…)` is invoked.
    init(makeContent: @escaping () -> Content) {
        self.makeContent = makeContent
    }
}

// MARK: - UIViewControllerRepresentable
extension SwiftUIViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> Content {
        makeContent()
    }
    
    func updateUIViewController(_ viewController: Content, context: Context) {}
}

// MARK: - ViewControllerType
/// A protocol that all `UIViewController`s conform to, enabling extensions that have a `Self` reference.
protocol ViewControllerType: UIViewController {}

// MARK: - ViewType + ViewTypeProtocol
extension UIViewController: ViewControllerType {}

// MARK: - ViewControllerTypeProtocol + preview
extension ViewControllerType {
    /// 주어진 `makeView` 클로저를 이용해 `UIViewController`를 나타내는 SwiftUI `View`를 반환합니다.
    ///
    /// ```
    /// MyUIViewController.preview {
    ///    return MyUIViewController()
    /// }
    /// ```
    static func preview(makeView: @escaping () -> Self) -> SwiftUIViewController<Self> {
        SwiftUIViewController(makeContent: makeView)
    }
    
    /// 초기화된 `UIViewController`를 기본 생성자로 생성하여 SwiftUI `View`를 반환합니다.
    ///
    /// `MyUIViewController.preview()`
    static func preview() -> SwiftUIViewController<Self> {
        let defaultMakeView = { Self.init() }
        return preview(makeView: defaultMakeView)
    }
}
