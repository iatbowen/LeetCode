//
//  Sixth.swift
//  LeetCode
//
//  Created by 叶修 on 2025/8/20.
//

import Foundation

class Sixth {
    init() {
        print("51. N 皇后:\(solveNQueens(4))")
        print("52. N 皇后 II:\(totalNQueens(5))")
        print("53. 最大子数组和:\(maxSubArray1([-2,1,-3,4,-1,2,1,-5,4]))")
        print("53. 最大子数组和:\(maxSubArray2([-2,1,-3,4,-1,2,1,-5,4]))")
        print("54. 螺旋矩阵:\(spiralOrder([[1,2,3],[4,5,6],[7,8,9]]))")
        print("55. 跳跃游戏:\(canJump([3,2,1,0,4]))")
        print("56. 合并区间:\(merge([[1,3],[2,6],[8,10],[15,18]]))")
        print("57. 插入区间:\(insert([[1,2],[3,5],[6,7],[8,10],[12,16]], [4,8]))")
        print("58. 最后一个单词的长度:\(lengthOfLastWord("   fly me   to   the moon  "))")
        print("59. 螺旋矩阵 II:\(generateMatrix(3))")
        print("60. 排列序列:\(getPermutation(3, 3))")
    }
    
    // 按照国际象棋的规则，皇后可以攻击与之处在同一行或同一列或同一斜线上的棋子。
    //  回溯算法：n 皇后问题 研究的是如何将 n 个皇后放置在 n × n 的棋盘上，并且使皇后彼此之间不能相互攻击。
    func solveNQueens(_ n: Int) -> [[String]] {
        var board = Array(repeating: Array(repeating: ".", count: n), count: n)
        var result = [[String]]()
        func isValid(_ row: Int, _ col: Int) -> Bool {
            // 检查列
            for i in 0..<row {
                if board[i][col] == "Q" { return false }
            }
            // 检查左上对角线
            var i = row - 1, j = col - 1
            while i >= 0 && j >= 0 {
                if board[i][j] == "Q" { return false }
                i -= 1; j -= 1
            }
            // 检查右上对角线
            i = row - 1; j = col + 1
            while i >= 0 && j < n {
                if board[i][j] == "Q" { return false }
                i -= 1; j += 1
            }
            return true
        }
        func backtrack(_ row: Int) {
            if row == n {
                result.append(board.map { $0.joined() })
                return
            }
            for col in 0..<n {
                if isValid(row, col) {
                    board[row][col] = "Q"
                    backtrack(row + 1)
                    board[row][col] = "."
                }
            }
        }
        backtrack(0)
        return result
    }
    
    // 回溯算法：给你一个整数 n ，返回 n 皇后问题 不同的解决方案的数量。
    func totalNQueens(_ n: Int) -> Int {
         var count = 0
         
         // 用三个集合记录攻击位置
         var columns = Set<Int>()      // 列
         var diag1 = Set<Int>()        // 主对角线
         var diag2 = Set<Int>()        // 副对角线
         
         func backtrack(_ row: Int) {
             if row == n {
                 count += 1
                 return
             }
             for col in 0..<n {
                 // 主对角线 row - col, 副对角线 row + col
                 if columns.contains(col) || diag1.contains(row - col) || diag2.contains(row + col) {
                     continue
                 }
                 // 选择
                 columns.insert(col)
                 diag1.insert(row - col)
                 diag2.insert(row + col)
                 backtrack(row + 1)
                 // 撤销
                 columns.remove(col)
                 diag1.remove(row - col)
                 diag2.remove(row + col)
             }
         }
         backtrack(0)
         return count
     }
    
    // 动态规划、贪心法和分治法
    // 给你一个整数数组 nums ，请你找出一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。子数组是数组中的一个连续部分。
    // 思想：每步都计算以这个数结尾的最大连续和——如果上一步能让当前更大就带上，否则从头开始。
    func maxSubArray1(_ nums: [Int]) -> Int {
        var dp:[Int] = Array(repeating: 0, count: nums.count)
        dp[0] = nums[0]
        var index = 1
        while index < nums.count {
            let value = nums[index]
            if dp[index - 1] > 0 {
                dp[index] = dp[index - 1] + value
            } else {
                dp[index] = value
            }
            index += 1
        }
        var res = dp[0]
        for num in dp {
            res = max(res, num)
        }
        return res
    }
    
    // 贪心法
    func maxSubArray2(_ nums: [Int]) -> Int {
        var currentSum = nums[0]
        var maxSum = nums[0]
        for i in 1..<nums.count {
            currentSum = max(currentSum + nums[i], nums[i])
            maxSum = max(maxSum, currentSum)
        }
        return maxSum
    }
    
    // 给你一个 m 行 n 列的矩阵 matrix ，请按照 顺时针螺旋顺序 ，返回矩阵中的所有元素。
    func spiralOrder(_ matrix: [[Int]]) -> [Int] {
        var u = 0                  // 上边界
        var d = matrix.count - 1    // 下边界
        var l = 0                  // 左边界
        var r = matrix[0].count - 1 // 右边界
        var res = Array<Int>()
        while true {
            // 从左到右遍历
            var index = l
            while index <= r {
                res.append(matrix[u][index])
                index += 1
            }
            u += 1
            if u > d {
                break
            }
            // 从上往下遍历
            index = u
            while index <= d {
                res.append(matrix[index][r])
                index += 1
            }
            r -= 1
            if l > r {
                break
            }
            // 从左往右遍历
            index = r
            while index >= l {
                res.append(matrix[d][index])
                index -= 1
            }
            d -= 1
            if u > d {
                break
            }
            // 从下往上遍历
            index = d
            while index >= u {
                res.append(matrix[index][l])
                index -= 1
            }
            l += 1
            if l > r {
                break
            }
        }
        return res
    }
    
    /*
     贪心:
     给你一个非负整数数组 nums ，你最初位于数组的 第一个下标 。数组中的每个元素代表你在该位置可以跳跃的最大长度。
     判断你是否能够到达最后一个下标，如果可以，返回 true ；否则，返回 false 。
     */
    func canJump(_ nums: [Int]) -> Bool {
        var index = 0
        var length = 0
        while index < nums.count {
            if index > length {
                return false
            }
            length = max(length, index+nums[index])
            index += 1
        }
        return true
    }
    
    // 给你一个 无重叠的 ，按照区间起始端点排序的区间列表 intervals，其中 intervals[i] = [starti, endi] 表示第 i 个区间的开始和结束，并且 intervals 按照 starti 升序排列。同样给定一个区间 newInterval = [start, end] 表示另一个区间的开始和结束。
    func merge(_ intervals: [[Int]]) -> [[Int]] {
        let sortedArray:[[Int]] = intervals.sorted { a, b in
            a.first! < b.first!
        }
        var res = Array<Array<Int>>()
        var index = 0
        while index < sortedArray.count {
            let interval = sortedArray[index]
            let left = interval[0]
            var right = interval[1]
            var next = index + 1
            while next < sortedArray.count && right >= sortedArray[next][0] {
                right = max(right, sortedArray[next][1])
                next += 1
            }
            res.append([left, right])
            index = next
        }
        return res
    }
    
    /*
     插入区间
     示例 1：
     输入：intervals = [[1,3],[6,9]], newInterval = [2,5]
     输出：[[1,5],[6,9]]
     */
    func insert(_ intervals: [[Int]], _ newInterval: [Int]) -> [[Int]] {
        var sortedArray = intervals
        sortedArray.append(newInterval)
        sortedArray.sort { a, b in
            a.first! < b.first!
        }
        var res = Array<Array<Int>>()
        var index = 0
        while index < sortedArray.count {
            let interval = sortedArray[index]
            let left = interval[0]
            var right = interval[1]
            var next = index + 1
            while next < sortedArray.count && right >= sortedArray[next][0] {
                right = max(right, sortedArray[next][1])
                next += 1
            }
            res.append([left, right])
            index = next
        }
        return res
    }
    
    // 给你一个字符串 s，由若干单词组成，单词前后用一些空格字符隔开。返回字符串中 最后一个 单词的长度。
    func lengthOfLastWord(_ s: String) -> Int {
        var end = s.count - 1
        var chars = Array(s)
        while end >= 0 && chars[end] == " " {
            end -= 1
        }
        if end < 0 {
            return 0
        }
        var start = end
        while start >= 0 && chars[start] != " " {
            start -= 1
        }
        return end - start
    }
    
    // 给你一个正整数 n ，生成一个包含 1 到 n2 所有元素，且元素按顺时针顺序螺旋排列的 n x n 正方形矩阵 matrix
    func generateMatrix(_ n: Int) -> [[Int]] {
        var res = Array(repeating: Array(repeating: 0, count: n), count: n)
        var u = 0
        var d = n - 1
        var l = 0
        var r = n - 1
        var num = 1
        while true {
            // 从左到右
            var index = l
            while index <= r {
                res[u][index] = num
                num += 1
                index += 1
            }
            u += 1
            if u > d {
                break
            }
            // 从上到下
            index = u
            while index <= d {
                res[index][r] = num
                num += 1
                index += 1
            }
            r -= 1
            if l > r {
                break
            }
            // 从右到左
            index = r
            while index >= l {
                res[d][index] = num
                num += 1
                index -= 1
            }
            d -= 1
            if u > d {
                break
            }
            // 从下到上
            index = d
            while index >= u {
                res[index][l] = num
                num += 1
                index -= 1
            }
            l += 1
            if l > r {
                break
            }
        }
        return res
    }
    
    // 回溯算法：给出集合 [1,2,3,...,n]，其所有元素共有 n! 种排列。给定 n 和 k，返回第 k 个排列。
    func getPermutation(_ n: Int, _ k: Int) -> String {
        var used = [Bool](repeating: false, count: n + 1)
        var path = [Int]()
        var count = 0
        var ans = ""
        func backtrack() {
            if path.count == n {
                count += 1
                if count == k {
                    ans = path.map { String($0) }.joined()
                }
                return
            }
            for i in 1...n {
                if used[i] { continue }
                used[i] = true
                path.append(i)
                backtrack()
                path.removeLast()
                used[i] = false
                if !ans.isEmpty { return } // 找到第k个就提前停止
            }
        }
        backtrack()
        return ans
    }
}
