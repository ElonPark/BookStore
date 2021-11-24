

import Foundation
import NeedleFoundation
import UIKit

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->SearchComponent") { component in
        return SearchDependencyf947dc409bd44ace18e0Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->SearchComponent->BookDetailsComponent") { component in
        return BookDetailsDependency099220a05e4493d9bd9fProvider(component: component)
    }
    
}

// MARK: - Providers

private class SearchDependencyf947dc409bd44ace18e0BaseProvider: SearchDependency {


    init() {

    }
}
/// ^->RootComponent->SearchComponent
private class SearchDependencyf947dc409bd44ace18e0Provider: SearchDependencyf947dc409bd44ace18e0BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class BookDetailsDependency099220a05e4493d9bd9fBaseProvider: BookDetailsDependency {
    var isbn13Validator: ISBN13validating {
        return searchComponent.isbn13Validator
    }
    private let searchComponent: SearchComponent
    init(searchComponent: SearchComponent) {
        self.searchComponent = searchComponent
    }
}
/// ^->RootComponent->SearchComponent->BookDetailsComponent
private class BookDetailsDependency099220a05e4493d9bd9fProvider: BookDetailsDependency099220a05e4493d9bd9fBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(searchComponent: component.parent as! SearchComponent)
    }
}
