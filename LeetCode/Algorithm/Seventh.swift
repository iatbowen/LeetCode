//
//  Seventh.swift
//  LeetCode
//
//  Created by 叶修 on 2025/8/20.
//

import Foundation

class Seventh {
    init() {
        let ln = ListNode(1)
        ln.next = ListNode(2)
        ln.next?.next = ListNode(3)
        ln.next?.next?.next = ListNode(4)
        ln.next?.next?.next?.next = ListNode(5)
        print("61. 旋转链表:\(String(describing: rotateRight(ln, 2)?.print()))")
        print("62. 不同路径:\(uniquePaths(3, 4))")
        print("63. 不同路径 II:\(uniquePathsWithObstacles([[0,0,0],[0,1,0],[0,0,0]]))")
        print("64. 最小路径和:\(minPathSum([[1,3,1],[1,5,1],[4,2,1]]))")
        print("66. 加一:\(plusOne([1,2,9]))")
        print("67. 二进制求和:\(addBinary("1010", "1011"))")
        print("69. x 的平方根:\(mySqrt(9))")
        print("70. 爬楼梯:\(climbStairs(10))")
    }
    
    // https://leetcode.cn/problems/rotate-list/
    // 给你一个链表的头节点 head ，旋转链表，将链表每个节点向右移动 k 个位置。
    func rotateRight(_ head: ListNode?, _ k: Int) -> ListNode? {
        if k == 0 || head == nil || head?.next == nil {
            return head
        }
        var head = head
        var count = 0
        var p = head
        var tail: ListNode?
        while p != nil {
            tail = p
            p = p?.next
            count += 1
        }
        let k = k % count
        var index = 0
        p = head
        while index < count - k - 1 {
            p = p?.next
            index += 1
        }
        tail?.next = head
        head = p?.next
        p?.next = nil
        return head
    }
    
    /*
     一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为 “Start” ）。
     机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为 “Finish” ）。
     问总共有多少条不同的路径？
     */
    func uniquePaths(_ m: Int, _ n: Int) -> Int {
        var dp = Array(repeating: Array(repeating: 0, count: n), count: m)
        // 将所有的 dp[0][j], dp[i][0] 都设置为边界条件，它们的值均为 1
        var index = 0
        while index < m {
            dp[index][0] = 1
            index += 1
        }
        index = 0
        while index < n {
            dp[0][index] = 1
            index += 1
        }
        var i = 1
        while i < m {
            var j = 1
            while j < n {
                dp[i][j] = dp[i-1][j] + dp[i][j-1]
                j += 1
            }
            i += 1
        }
        return dp[m-1][n-1]
    }
    /**
     给定一个 m x n 的整数数组 grid。一个机器人初始位于 左上角（即 grid[0][0]）。机器人尝试移动到 右下角（即 grid[m - 1][n - 1]）。机器人每次只能向下或者向右移动一步。
     网格中的障碍物和空位置分别用 1 和 0 来表示。机器人的移动路径中不能包含 任何 有障碍物的方格。
     返回机器人能够到达右下角的不同路径数量。
     */
    func uniquePathsWithObstacles(_ obstacleGrid: [[Int]]) -> Int {
        let m = obstacleGrid.count
        let n = obstacleGrid.first?.count ?? 0
        var dp = Array(repeating: Array(repeating: 0, count: n), count: m)
        var index = 0
        while index < m && obstacleGrid[index][0] == 0 {
            dp[index][0] = 1
            index += 1
        }
        index = 0
        while index < n && obstacleGrid[0][index] == 0 {
            //只遍历初始第一行没有石子的情况，即obstacleGrid[i][0] == 0的情况
            dp[0][index] = 1
            index += 1
        }
        var i = 1
        while i < m {
            var j = 1
            while j < n {
                //如果当前网格状态为 0，则说明当前位置没有石子
                if obstacleGrid[i][j] == 0 {
                    dp[i][j] = dp[i-1][j] + dp[i][j-1]
                }
                j += 1
            }
            i += 1
        }
        return dp[m-1][n-1]
    }
    
    /*
     给定一个包含非负整数的 m x n 网格 grid ，请找出一条从左上角到右下角的路径，使得路径上的数字总和为最小。
     说明：每次只能向下或者向右移动一步。
     */
    func minPathSum(_ grid: [[Int]]) -> Int {
        let m = grid.count
        let n = grid.first?.count ?? 0
        if m == 0 && n == 0 {
            return 0
        }
        var dp = Array(repeating: Array(repeating: 0, count: n), count: m)
        dp[0][0] = grid[0][0]
        var index = 1
        while index < m {
            dp[index][0] = dp[index-1][0] + grid[index][0]
            index += 1
        }
        index = 1
        while index < n {
            dp[0][index] = dp[0][index-1] + grid[0][index]
            index += 1
        }
        var i = 1
        while i < m {
            var j = 1
            while j < n {
                dp[i][j] = min(dp[i-1][j], dp[i][j-1]) + grid[i][j]
                j += 1
            }
            i += 1
        }
        return dp[m-1][n-1]
    }
    
    // 给定一个表示 大整数 的整数数组 digits，其中 digits[i] 是整数的第 i 位数字。这些数字按从左到右，从最高位到最低位排列。这个大整数不包含任何前导 0。
    // 将大整数加 1，并返回结果的数字数组。
    func plusOne(_ digits: [Int]) -> [Int] {
        var digits = digits
        var end = digits.count - 1
        var res = 1
        while end >= 0 {
            let num = digits[end] + res
            digits[end] = num % 10
            res = num / 10
            end -= 1
        }
        if res == 1 {
            digits.insert(res, at: 0)
        }
        return digits
    }

    // 给你两个二进制字符串 a 和 b ，以二进制字符串的形式返回它们的和。
    func addBinary(_ a: String, _ b: String) -> String {
        let aChars = Array(a)
        let bChars = Array(b)
        var m = aChars.count - 1, n = bChars.count - 1
        var res = Array<Int>()
        var flag = 0
        while m >= 0 || n >= 0{
            var sum = flag
            if m >= 0 {
                sum += aChars[m].wholeNumberValue!
            }
            if n >= 0 {
                sum += bChars[n].wholeNumberValue!
            }
            res.append(sum % 2)
            flag = sum / 2
            m -= 1
            n -= 1
        }
        if flag == 1 {
            res.append(flag)
        }
        var string = String()
        for num in res.reversed() {
            string += String(num)
        }
        return string
    }
    
    // 给你一个非负整数 x ，计算并返回 x 的 算术平方根 。
    func mySqrt(_ x: Int) -> Int {
        if x == 0 || x == 1 {
            return x
        }
        var left = 0, right = x, ans = -1
        while left <= right {
            let mid = (left + right) / 2
            if mid * mid <= x {
                ans = mid
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        return ans
    }
    
    /*
     假设你正在爬楼梯。需要 n 阶你才能到达楼顶。
     每次你可以爬 1 或 2 个台阶。你有多少种不同的方法可以爬到楼顶呢？
     */
    func climbStairs(_ n: Int) -> Int {
        if n == 1 {
            return 1
        }
        var dp = Array(repeating: 0, count: n+1)
        dp[0] = 1
        dp[1] = 1
        dp[2] = 2
        var index = 3
        while index < dp.count {
            dp[index] = dp[index - 1] + dp[index - 2]
            index += 1
        }
        return dp[n]
    }

    
}
