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
        print("21. 合并两个有序链表:\(String(describing: mergeTwoLists(l1, l2)?.print()))")
        print("22. 括号生成:\(generateParenthesis(3))")
        let n1 = ListNode(1)
        n1.next = ListNode(3)
        n1.next?.next = ListNode(5)
        n1.next?.next?.next = ListNode(10)
        let n2 = ListNode(2)
        n2.next = ListNode(4)
        n2.next?.next = ListNode(6)
        let n3 = ListNode(7)
        n3.next = ListNode(8)
        n3.next?.next = ListNode(9)
        print("23. 合并 K 个升序链表:\(String(describing: mergeKLists([n1, n2, n3])?.print()))")
        let ln = ListNode(1)
        ln.next = ListNode(2)
        ln.next?.next = ListNode(3)
        ln.next?.next?.next = ListNode(4)
        print("24. 两两交换链表中的节点:\(String(describing: swapPairs(ln)?.print()))")
        var array = [1,2,3,4,1,2,3,4]
        _ = removeDuplicates(&array)
        print("26. 删除有序数组中的重复项:\(array)")
        _ = removeElement(&array, 2)
        print("27. 移除元素:\(array)")
        print("28. 找出字符串中第一个匹配项的下标:\(String(describing: findFirstMatchIndex("sadbutsad", "sad")))")
        print("29. 两数相除:\(divide(10, 3))")
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
    // 数字 n 代表生成括号的对数，请你设计一个函数，用于能够生成所有可能的并且 有效的 括号组合。
    func generateParenthesis(_ n: Int) -> [String] {
        var result: [String] = []
        // 定义递归函数
        func backtrack(_ current: String, _ left: Int, _ right: Int) {
            // 左右括号都用完，加入结果
            if left == 0 && right == 0 {
                result.append(current)
                return
            }
            // 约束条件：防止左括号过多
            if left > 0 {
                backtrack(current + "(", left - 1, right)
            }
            // 约束条件：防止右括号过多（核心剪枝！）
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
    
    // 给你一个链表，两两交换其中相邻的节点，并返回交换后链表的头节点。你必须在不修改节点内部的值的情况下完成本题（即，只能进行节点交换）。
    func swapPairs(_ head: ListNode?) -> ListNode? {
        let h = ListNode(0, head)
        var p: ListNode? = h
        while p?.next != nil && p?.next?.next != nil {
            let n1 = p?.next
            let n2 = p?.next?.next
            p?.next = n2
            n1?.next = n2?.next
            n2?.next = n1
            p = n1
        }
        return h.next
    }
    
    // 删除有序数组中的重复项
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        var array = Array<Int>()
        for num in nums {
            if (array.contains(num)) {
                continue
            }
            array.append(num)
        }
        nums = array
        return nums.count
    }
    
    // 给你一个数组 nums 和一个值 val，你需要 原地 移除所有数值等于 val 的元素。元素的顺序可能发生改变。然后返回 nums 中与 val 不同的元素的数量。
    // 假设 nums 中不等于 val 的元素数量为 k，要通过此题，您需要执行以下操作：
    // 更改 nums 数组，使 nums 的前 k 个元素包含不等于 val 的元素。nums 的其余元素和 nums 的大小并不重要。
    // 返回 k
    func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
        var index = 0
        for num in nums {
            if num != val {
                nums[index] = num
                index += 1
            }
        }
        return index
    }
    
    // 给你两个字符串 haystack 和 needle ，请你在 haystack 字符串中找出 needle 字符串的第一个匹配项的下标（下标从 0 开始）。如果 needle 不是 haystack 的一部分，则返回  -1 。
    func findFirstMatchIndex(_ haystack: String, _ needle: String) -> Int? {
        // 如果needle为空，返回0
        if needle.isEmpty {
            return 0
        }
        // 如果haystack长度小于needle，肯定不匹配
        if haystack.count < needle.count {
            return -1
        }
        let haystackChars = Array(haystack)
        let needleChars = Array(needle)
        // 遍历haystack
        for i in 0...(haystackChars.count - needleChars.count) {
            var match = true
            // 检查当前位置开始的子串是否匹配needle
            for j in 0..<needleChars.count {
                if haystackChars[i + j] != needleChars[j] {
                    match = false
                    break
                }
            }
            if match {
                return i
            }
        }
        return -1
    }
    
    /*
     给你两个整数，被除数 dividend 和除数 divisor。将两数相除，要求 不使用 乘法、除法和取余运算。
     整数除法应该向零截断，也就是截去（truncate）其小数部分。例如，8.345 将被截断为 8 ，-2.7335 将被截断至 -2 。
     返回被除数 dividend 除以除数 divisor 得到的 商 。
     */
    func divide(_ dividend: Int, _ divisor: Int) -> Int {
        // 处理除数为0的情况
        if divisor == 0 {
            fatalError("除数不能为0")
        }
        
        // 处理被除数为0的情况
        if dividend == 0 {
            return 0
        }
        
        // 判断结果的正负号
        let isNegative = (dividend < 0) != (divisor < 0)
        
        // 转换为正数处理
        var absDividend = abs(dividend)
        let absDivisor = abs(divisor)
        
        var result = 0
        
        // 通过减法实现除法
        while absDividend >= absDivisor {
            absDividend -= absDivisor
            result += 1
        }
        
        // 应用符号
        result = isNegative ? -result : result
        
        // 处理32位整数溢出情况
        // Swift中Int是平台相关的，这里假设题目要求32位范围
        if result > Int32.max {
            return Int(Int32.max)
        }
        if result < Int32.min {
            return Int(Int32.min)
        }
        return result
    }


}
