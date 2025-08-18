//
//  Third.swift
//  LeetCode
//
//  Created by 叶修 on 2025/8/18.
//

import Foundation

class Third {
    init() {
        let l1 = ListNode(1)
        l1.next = ListNode(3)
        l1.next?.next = ListNode(5)
        let l2 = ListNode(2)
        l2.next = ListNode(4)
        l2.next?.next = ListNode(6)
        print("21.合并两个有序链表:\(String(describing: mergeTwoLists(l1, l2)?.print()))")
        print("22.括号生成:\(generateParenthesis(3))")
        let n1 = ListNode(1)
        n1.next = ListNode(3)
        n1.next?.next = ListNode(5)
        let n2 = ListNode(2)
        n2.next = ListNode(4)
        n2.next?.next = ListNode(6)
        let n3 = ListNode(7)
        n3.next = ListNode(8)
        n3.next?.next = ListNode(9)
        print("23.合并 K 个升序链表:\(String(describing: mergeKLists([n1, n2, n3])?.print()))")
    }
    
    // 将两个升序链表合并为一个新的 升序 链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。
    func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
        var l1 = list1, l2 = list2
        let phead = ListNode()
        var p = phead
        while l1 != nil && l2 != nil {
            if l1!.val <= l2!.val {
                p.next = l1
                l1 = l1!.next
            } else {
               p.next = l2
               l2 = l2!.next
            }
            p = p.next!
        }
        p.next = l1 == nil ? l2 : l1;
        return phead.next
    }
    
    // 回溯法：数字 n 代表生成括号的对数，请你设计一个函数，用于能够生成所有可能的并且 有效的 括号组合
    // 在解决有“约束条件”的组合/排列/分割等问题时，往往都要用回溯法（即加剪枝的DFS），这比纯DFS快很多。
    // 回溯 = DFS + 符合条件时才继续下去（剪枝），否则撤销选择
    func generateParenthesis(_ n: Int) -> [String] {
        var result: [String] = []
        // 定义递归函数
        func backtrack(_ current: String, _ left: Int, _ right: Int) {
            // 左右括号都用完，加入结果
            if left == 0 && right == 0 {
                result.append(current)
                return
            }
            // 还有左括号，可用就加左括号
            if left > 0 {
                backtrack(current + "(", left - 1, right)
            }
            // 右括号剩余多于左括号，说明可用来闭合
            if right > left {
                backtrack(current + ")", left, right - 1)
            }
        }
        // 从n个左括号和n个右括号开始
        backtrack("", n, n)
        return result
    }
    
    // K链表分治递归合并: 给你一个链表数组，每个链表都已经按升序排列。请你将所有链表合并到一个升序链表中，返回合并后的链表
    func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
        guard !lists.isEmpty else { return nil }
        func merge(_ left: Int, _ right: Int) -> ListNode? {
            if left == right { return lists[left] }
            let mid = (left + right) / 2
            let l = merge(left, mid)
            let r = merge(mid + 1, right)
            return mergeTwoLists(l, r)
        }
        return merge(0, lists.count - 1)
    }
}
