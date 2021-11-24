//
//  ComponentizedBuilder.swift
//  BookStore
//
//  Created by Elon on 2021/11/24.
//

import Foundation

class ComponentizedBuilder<Component, ViewControllable, DynamicComponentDependency> {

    private let componentBuilder: (DynamicComponentDependency) -> Component

    init(componentBuilder: @escaping (DynamicComponentDependency) -> Component) {
        self.componentBuilder = componentBuilder
    }

    deinit {
        print("deinit: \(type(of: self))")
    }

    final func build(
        withDynamicComponentDependency dynamicComponentDependency: DynamicComponentDependency
    ) -> ViewControllable {
        let component = componentBuilder(dynamicComponentDependency)
        return build(with: component)
    }

    func build(with component: Component) -> ViewControllable {
        fatalError("This method should be overridden by the subclass.")
    }
}
