//
//  Router.swift
//  CryptoTracker
//
//  Created by Uziel Sabalza on 5/6/26.
//

import SwiftUI
import Combine

public class Router: ObservableObject {
    @Published public var path = NavigationPath()
    @Published public var activeSheet: Sheet?
    
    public init() {
        
    }
    
    public func push(to destination: Destination) {
        path.append(destination)
    }
    
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path = NavigationPath()
    }
    
    public func presentSheet(_ sheet: Sheet) {
        activeSheet = sheet
    }
    
    public func dismissSheet() {
        activeSheet = nil
    }
}
