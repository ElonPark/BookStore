//
//  RootComponent.swift
//  BookStore
//
//  Created by Elon on 2021/11/24.
//

import NeedleFoundation

final class RootComponent: BootstrapComponent, SearchDependency {

    var searchBuilder: SearchBuildable {
        return SearchBuilder {
            SearchComponent(parent: self)
        }
    }
}
