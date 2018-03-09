//
//  Graph.swift
//  AnimState
//
//  Created by Downey, Eric on 3/8/18.
//  Copyright © 2018 Downey. All rights reserved.
//

struct Node<T: Hashable> {
    var data: T
    
    init(data: T) {
        self.data = data
    }
}

extension Node: Hashable {
    var hashValue: Int {
        return data.hashValue
    }
    
    static func ==<T>(lhs: Node<T>, rhs: Node<T>) -> Bool {
        return lhs.data == rhs.data
    }
}

struct Edge<T: Hashable> {
    var source: Node<T>
    var destination: Node<T>
}

extension Edge: Hashable {
    var hashValue: Int {
        return "\(source)\(destination)".hashValue
    }
    
    static func ==<T>(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
        return  lhs.source == rhs.source &&
            lhs.destination == rhs.destination
    }
}

class Graph<Element: Hashable> {
    var graphDict: [Node<Element>: [Edge<Element>]]
    
    init() {
        self.graphDict = [:]
    }
    
    func createNode(with data: Element) -> Node<Element> {
        let n = Node(data: data)
        if graphDict[n] == nil {
            graphDict[n] = []
        }
        return n
    }
    
    func addEdge(from source: Node<Element>, to destination: Node<Element>) {
        let edge = Edge(source: source, destination: destination)
        graphDict[source]?.append(edge)
    }
    
    func edges(from source: Node<Element>) -> [Edge<Element>]? {
        return graphDict[source]
    }
    
    func node(where predicate: (Node<Element>) -> Bool) -> Node<Element>? {
        let keys: [Node<Element>] = Array(graphDict.keys)
        return keys.filter(predicate).first
    }
}
