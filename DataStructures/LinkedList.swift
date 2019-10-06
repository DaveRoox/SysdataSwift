//
//  SinglyLinkedList.swift
//  Pods
//
//  Created by Davide Russo on 06/10/2019.
//

import Foundation

/*-------------------------------- Node --------------------------------*/

fileprivate protocol LinkedListNode {
    associatedtype Element
    associatedtype Node : LinkedListNode
    var elem: Element { get }
    var next: Node? { get }
}

fileprivate class SinglyLinkedListNode<Element> : LinkedListNode {
    typealias Node = SinglyLinkedListNode
    var elem: Element
    var next: SinglyLinkedListNode<Element>?
    init(elem: Element, next: SinglyLinkedListNode? = nil) {
        self.elem = elem
        self.next = next
    }
}

fileprivate class DoublyLinkedListNode<Element> : LinkedListNode {
    typealias Node = DoublyLinkedListNode
    var elem: Element
    var next: DoublyLinkedListNode<Element>?
    var prev: DoublyLinkedListNode<Element>?
    init(elem: Element, prev: DoublyLinkedListNode? = nil, next: DoublyLinkedListNode? = nil) {
        self.elem = elem
        self.prev = prev
        self.next = next
    }
}

/*-------------------------------- Iterator --------------------------------*/

fileprivate protocol LinkedListIterator : IteratorProtocol {
    associatedtype Node : LinkedListNode
    var current: Node? { get }
}

struct SinglyLinkedListIterator<Element> : LinkedListIterator {
    fileprivate typealias Node = SinglyLinkedListNode<Element>
    fileprivate var current: Node?
    fileprivate init(initial: Node?) {
        self.current = initial
    }
    mutating func next() -> Element? {
        defer { current = current?.next }
        return current?.elem
    }
}

struct DoublyLinkedListIterator<Element> : LinkedListIterator {
    fileprivate typealias Node = DoublyLinkedListNode<Element>
    fileprivate var current: Node?
    fileprivate init(initial: Node?) {
        self.current = initial
    }
    mutating func next() -> Element? {
        defer { current = current?.next }
        return current?.elem
    }
}

struct DoublyLinkedListReverseIterator<Element> : LinkedListIterator {
    fileprivate typealias Node = DoublyLinkedListNode<Element>
    fileprivate var current: Node?
    fileprivate init(final: Node?) {
        self.current = final
    }
    mutating func next() -> Element? {
        defer { current = current?.prev }
        return current?.elem
    }
}

/*-------------------------------- LinkedList --------------------------------*/

fileprivate protocol LinkedList : Sequence where Iterator : LinkedListIterator {
    associatedtype Element
    associatedtype Node : LinkedListNode
    var head: Node? { get }
    var tail: Node? { get }
    var size: Int { get }
    __consuming func makeIterator() -> Self.Iterator
    mutating func append(_ newElement: Element)
    mutating func prepend(_ newElement: Element)
}

struct SinglyLinkedList<Element> : LinkedList {
    
    typealias Element = Element
    typealias Iterator = SinglyLinkedListIterator<Element>
    fileprivate typealias Node = SinglyLinkedListNode<Element>
    
    fileprivate var head: SinglyLinkedListNode<Element>?    = nil
    fileprivate var tail: SinglyLinkedListNode<Element>?    = nil
    var size            : Int                               = 0
    
    init(elems: Element...) {
        elems.forEach { append($0) }
    }
    
    init(elems: [Element]) {
        elems.forEach { append($0) }
    }
    
    func makeIterator() -> Self.Iterator {
        return SinglyLinkedListIterator(initial: head)
    }
    
    @inlinable public mutating func append(_ newElement: Element) {
        let newNode = SinglyLinkedListNode(elem: newElement)
        if let tail = tail {
            tail.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
        size += 1
    }
    
    @inlinable public mutating func prepend(_ newElement: Element) {
        head = SinglyLinkedListNode(elem: newElement, next: head)
        if tail == nil {
            tail = head
        }
        size += 1
    }
    
    @inlinable public func dropLast(_ k: Int = 1) -> SinglyLinkedList<Element> {
        var other = SinglyLinkedList()
        var it = makeIterator(), i = 0, limit = size - k
        while i < limit, let item = it.next() {
            other.append(item)
            i += 1
        }
        return other
    }
}

struct DoublyLinkedList<Element> : LinkedList {
    
    typealias Element = Element
    typealias Iterator = DoublyLinkedListIterator<Element>
    typealias ReverseIterator = DoublyLinkedListReverseIterator<Element>
    fileprivate typealias Node = DoublyLinkedListNode<Element>
    
    fileprivate var head: DoublyLinkedListNode<Element>?    = nil
    fileprivate var tail: DoublyLinkedListNode<Element>?    = nil
    var size            : Int                               = 0
    
    init(elems: Element...) {
        elems.forEach { append($0) }
    }
    
    init(elems: [Element]) {
        elems.forEach { append($0) }
    }
    
    func makeIterator() -> DoublyLinkedList<Element>.Iterator {
        return DoublyLinkedListIterator(initial: head)
    }
    
    func makeReverseIterator() -> DoublyLinkedList<Element>.ReverseIterator {
        return DoublyLinkedListReverseIterator(final: tail)
    }
    
    @inlinable public mutating func append(_ newElement: Element) {
        tail = DoublyLinkedListNode(elem: newElement, prev: tail)
        if let prev = tail?.prev {
            prev.next = tail
        }
        if head == nil {
            head = tail
        }
        size += 1
    }
    
    @inlinable public mutating func prepend(_ newElement: Element) {
        head = DoublyLinkedListNode(elem: newElement, next: head)
        if let next = head?.next {
            next.prev = head
        }
        if tail == nil {
            tail = head
        }
        size += 1
    }
}
