//
//  SinglyLinkedList.swift
//  Pods
//
//  Created by Davide Russo on 06/10/2019.
//

import Foundation

struct SinglyLinkedList<Element> : Sequence {
    
    typealias Iterator = SinglyLinkedListIterator
    
    private var _head: SinglyLinkedListNode?    = nil
    private var _tail: SinglyLinkedListNode?    = nil
    private var _size: Int                      = 0
    
    init(elems: Element...) {
        elems.forEach { append($0) }
    }
    
    init(elems: [Element]) {
        elems.forEach { append($0) }
    }
    
    __consuming func makeIterator() -> SinglyLinkedList<Element>.SinglyLinkedListIterator {
        return SinglyLinkedListIterator(initial: _head)
    }
    
    @inlinable public mutating func append(_ newElement: Element) {
        let newNode = SinglyLinkedListNode(item: newElement)
        if let tail = _tail {
            tail.nextItem = newNode
        } else {
            _head = newNode
        }
        _tail = newNode
        _size += 1
    }
    
    @inlinable public func dropLast(_ k: Int = 1) -> SinglyLinkedList<Element> {
        var other = SinglyLinkedList()
        var it = makeIterator(), i = 0, limit = _size - k
        while i < limit, let item = it.next() {
            other.append(item)
            i += 1
        }
        return other
    }
    
    fileprivate class SinglyLinkedListNode {
        var item: Element
        var nextItem: SinglyLinkedListNode?
        
        init(item: Element, nextItem: SinglyLinkedListNode? = nil) {
            self.item = item
            self.nextItem = nextItem
        }
    }
    
    struct SinglyLinkedListIterator : IteratorProtocol {
        
        private var current: SinglyLinkedListNode?
        
        fileprivate init(initial: SinglyLinkedListNode?) {
            self.current = initial
        }
        
        mutating func next() -> Element? {
            defer { current = current?.nextItem }
            return current?.item
        }
    }
    
}
