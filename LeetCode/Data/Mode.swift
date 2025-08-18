//
//  Mode.swift
//  LeetCode
//
//  Created by 叶修 on 2025/8/13.
//

import Foundation

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
    public func print() -> [Int] {
        var current: ListNode? = self
        var values: [Int] = []
        while current != nil {
            values.append(current!.val)
            current = current!.next
        }
        return values
    }
}
 
