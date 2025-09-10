//
//  Ninth.swift
//  LeetCode
//
//  Created by 叶修 on 2025/8/22.
//

import Foundation

class Ninth {
    
    init() {
        print("81. 搜索旋转排序数组 II:\(search([2,5,6,0,0,1,2], 0))")
        let l1 = ListNode(2)
        l1.next = ListNode(3)
        l1.next?.next = ListNode(3)
        l1.next?.next?.next = ListNode(4)
        print("82. 删除排序链表中的重复元素 II:\(String(describing: deleteDuplicates(l1)?.print()))")
        let n1 = ListNode(2)
        n1.next = ListNode(3)
        n1.next?.next = ListNode(3)
        n1.next?.next?.next = ListNode(4)
        print("83. 删除排序链表中的重复元素:\(String(describing: deleteDuplicate(n1)?.print()))")
        print("84. 柱状图中最大的矩形:\(largestRectangleArea([2,1,5,6,2,3]))")
        print("85. 最大矩形:\(maximalRectangle([["1","0","1","0","0"],["1","0","1","1","1"],["1","1","1","1","1"],["1","0","0","1","0"]]))")
        let ln1 = ListNode(2)
        ln1.next = ListNode(5)
        ln1.next?.next = ListNode(3)
        ln1.next?.next?.next = ListNode(4)
        ln1.next?.next?.next?.next = ListNode(6)
        print("86. 分隔链表:\(String(describing: partition(ln1, 4)?.print()))")
        var nums1 = [1,2,3,0,0,0]
        merge(&nums1, 3, [2,5,6], 3)
        print("88. 合并两个有序数组:\(nums1)")
        print("90. 子集 II:\(subsetsWithDup([1,2,2]))")
    }
    
    // 已知存在一个按非降序排列的整数数组 nums ，数组中的值不必互不相同。给你 旋转后 的数组 nums 和一个整数 target ，请你编写一个函数来判断给定的目标值是否存在于数组中
    func search(_ nums: [Int], _ target: Int) -> Bool {
        var l = 0, r = nums.count - 1
        while l <= r {
            let mid = (l + r) / 2
            if nums[mid] == target {
                return true
            }
            if nums[l] == nums[mid] {
                l += 1
                continue
            }
            if nums[mid] >= nums[l] {
                if nums[l] <= target && target < nums[mid] {
                    r = mid - 1
                } else {
                    l = mid + 1
                }
            } else {
                if nums[mid] < target && target <= nums[nums.count-1] {
                    l = mid + 1
                } else {
                    r = mid - 1
                }
            }
        }
        return false
    }
    
    // 给定一个已排序的链表的头 head ， 删除原始链表中所有重复数字的节点，只留下不同的数字 。返回 已排序的链表 。
    func deleteDuplicates(_ head: ListNode?) -> ListNode? {
        let phead: ListNode? = ListNode(0 , head)
        var current = phead
        while current?.next != nil && current?.next?.next != nil {
            if current?.next?.val == current?.next?.next?.val {
                let value = current?.next?.val
                while current?.next != nil && current?.next?.val == value {
                    current?.next = current?.next?.next
                }
            } else {
                current = current?.next
            }
        }
        return phead?.next
    }
    
    // 给定一个已排序的链表的头 head ， 删除所有重复的元素，使每个元素只出现一次 。返回 已排序的链表 。
    func deleteDuplicate(_ head: ListNode?) -> ListNode? {
        var current: ListNode? = head
        while current != nil && current?.next != nil {
            if current?.val == current?.next?.val {
                current?.next = current?.next?.next
            } else {
                current = current?.next
            }
        }
        return head
    }
    
    /*
     单调栈（递增或递减）：给定 n 个非负整数，用来表示柱状图中各个柱子的高度。每个柱子彼此相邻，且宽度为 1 。求在该柱状图中，能够勾勒出来的矩形的最大面积。
     思路简述：
     用栈存储柱子的索引，当当前柱子的高度小于栈顶柱子的高度时，弹栈并计算矩形面积；
     处理到数组尾部时，为保证所有柱子都被处理，最后加个高度为0的柱子。
     */
    func largestRectangleArea(_ heights: [Int]) -> Int {
        var stack = [Int]()
        var maxArea = 0
        // 在末尾添加0，保证所有柱子都会被弹出
        let newHeights = heights + [0]
        for (i, h) in newHeights.enumerated() {
            // 遍历，当前柱子比栈顶的柱子矮，一直弹栈并计算面积
            while let last = stack.last, h < newHeights[last] {
                let height = newHeights[stack.removeLast()]
                // 如果栈为空，宽度就是i，否则宽度是 右边界 - (左边界 + 1)
                let width = stack.isEmpty ? i : i - (stack.last! + 1)
                maxArea = max(maxArea, height * width)
            }
            // 入栈当前柱子索引
            stack.append(i)
        }
        return maxArea
    }
    
    /*
     定一个仅包含 0 和 1 、大小为 rows x cols 的二维二进制矩阵，找出只包含 1 的最大矩形，并返回其面积。
     解题思路：将每一行看作直方图底部，转化为最大矩形面积问题
     */
    func maximalRectangle(_ matrix: [[Character]]) -> Int {
        guard !matrix.isEmpty else { return 0 }
        let rows = matrix.count
        let cols = matrix[0].count
        var heights = [Int](repeating: 0, count: cols)
        var maxArea = 0
        for i in 0..<rows {
            // 更新高度数组
            for j in 0..<cols {
                if matrix[i][j] == "1" {
                    heights[j] += 1
                } else {
                    heights[j] = 0
                }
            }
            // 计算当前行的最大矩形面积
            maxArea = max(maxArea, largestArea(heights))
        }
        func largestArea(_ heights: [Int]) -> Int {
            var stack = [Int]()
            let heights = [0] + heights + [0]  // 前后添加哨兵
            var maxArea = 0
            for i in 0..<heights.count {
                // 当当前高度小于栈顶高度时，计算面积
                while !stack.isEmpty && heights[i] < heights[stack.last!] {
                    let height = heights[stack.removeLast()]
                    let width = i - stack.last! - 1
                    maxArea = max(maxArea, height * width)
                }
                stack.append(i)
            }
            
            return maxArea
        }
        return maxArea
    }
    
    /*
     给你一个链表的头节点 head 和一个特定值 x ，请你对链表进行分隔，使得所有 小于 x 的节点都出现在 大于或等于 x 的节点之前。
     你应当 保留 两个分区中每个节点的初始相对位置。
     */
    func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
        let smallList: ListNode? = ListNode()
        let bigList: ListNode? = ListNode()
        var s = smallList
        var b = bigList
        var p = head
        while p != nil {
            let value = p?.val ?? 0
            if value >= x {
                b?.next = p
                b = b?.next
            } else {
                s?.next = p
                s = s?.next
            }
            p = p?.next
        }
        b?.next = nil
        s?.next = bigList?.next
        return smallList?.next
    }
    
    /*
     逆向双指针：
     给你两个按 非递减顺序 排列的整数数组 nums1 和 nums2，另有两个整数 m 和 n ，分别表示 nums1 和 nums2 中的元素数目。
     请你 合并 nums2 到 nums1 中，使合并后的数组同样按 非递减顺序 排列。
     */
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        var i = m - 1, j = n - 1;
        while (i >= 0 || j >= 0) {
            if j < 0 || (i >= 0 && nums1[i] > nums2[j]) {
                nums1[i + j + 1] = nums1[i]
                i -= 1
            } else {
                nums1[i + j + 1] = nums2[j]
                j -= 1
            }
        }
    }
    
    /*
     https://leetcode.cn/problems/subsets-ii/solutions/690866/90-zi-ji-iiche-di-li-jie-zi-ji-wen-ti-ru-djmf/
     给你一个整数数组 nums ，其中可能包含重复元素，请你返回该数组所有可能的 子集（幂集）。
     解集 不能 包含重复的子集。返回的解集中，子集可以按 任意顺序 排列。
     */
    func subsetsWithDup(_ nums: [Int]) -> [[Int]] {
        var res = Array<Array<Int>>()
        var path = Array<Int>()
        var used = Array(repeating: false, count: nums.count)
        dfsSet(nums.sorted(by: <), 0, &res, &path, &used)
        func dfsSet(_ nums:[Int], _ index: Int, _ res: inout [[Int]], _ path: inout [Int], _ used: inout [Bool]) {
            res.append(path)
            var begin = index
            while begin < nums.count {
                // used[i - 1] == true，说明同一树枝candidates[i - 1]使用过
                // used[i - 1] == false，说明同一树层candidates[i - 1]使用过
                // 而我们要对同一树层使用过的元素进行跳过
                if begin > 0 && nums[begin] == nums[begin-1] && used[begin - 1] == false {
                    begin += 1
                    continue
                }
                used[begin] = true
                path.append(nums[begin])
                dfsSet(nums, begin+1, &res, &path, &used)
                used[begin] = false
                path.removeLast()
                begin += 1
            }
        }
        return res
    }
    
    
}
