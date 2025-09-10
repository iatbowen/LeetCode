//
//  Fourth.swift
//  LeetCode
//
//  Created by 叶修 on 2025/8/19.
//

import Foundation



class Fourth {
    init() {
        var nums = [1,2,3]
        nextPermutation(&nums)
        print("31. 下一个排列:\(nums)")
        print("32. 最长有效括号:\(longestValidParentheses("()(()())"))")
        print("33. 搜索旋转排序数组:\(search([4,5,6,7,0,1,2], 0))")
        print("34. 在排序数组中查找元素的第一个和最后一个位置:\(searchRange([5,7,7,8,8,8,10], 8))")
        print("35. 搜索插入位置:\(searchInsert([1,3,5,6], 5))")
        let board: [[Character]] =
        [["5","3",".",".","7",".",".",".","."]
         ,["6",".",".","1","9","5",".",".","."]
         ,[".","9","8",".",".",".",".","6","."]
         ,["8",".",".",".","6",".",".",".","3"]
         ,["4",".",".","8",".","3",".",".","1"]
         ,["7",".",".",".","2",".",".",".","6"]
         ,[".","6",".",".",".",".","2","8","."]
         ,[".",".",".","4","1","9",".",".","5"]
         ,[".",".",".",".","8",".",".","7","9"]]
        print("36. 有效的数独:\(isValidSudoku(board))")
        var board1: [[Character]] = [["5","3",".",".","7",".",".",".","."],["6",".",".","1","9","5",".",".","."],[".","9","8",".",".",".",".","6","."],["8",".",".",".","6",".",".",".","3"],["4",".",".","8",".","3",".",".","1"],["7",".",".",".","2",".",".",".","6"],[".","6",".",".",".",".","2","8","."],[".",".",".","4","1","9",".",".","5"],[".",".",".",".","8",".",".","7","9"]]
        solveSudoku(&board1)
        print("37. 解数独:\(board1)")
        print("38. 外观数列:\(countAndSay(1))")
        print("39. 组合总和:\(combinationSum([2,5,2,1,2], 5))")
        print("40. 组合总和2:\(combinationSum2([2,5,2,1,2], 5))")
    }
    
    // https://leetcode.cn/problems/next-permutation/solutions/80560/xia-yi-ge-pai-lie-suan-fa-xiang-jie-si-lu-tui-dao-/
    // 整数数组的一个 排列  就是将其所有成员以序列或线性顺序排列。整数数组的 下一个排列 是指其整数的下一个字典序更大的排列
    // 标准的 “下一个排列” 算法可以描述为：
    // 1. 从后向前 查找第一个 相邻升序 的元素对 (i,j)，满足 A[i] < A[j]。此时 [j,end) 必然是降序
    // 2. 在 [j,end) 从后向前 查找第一个满足 A[i] < A[k] 的 k。A[i]、A[k] 分别就是上文所说的「小数」、「大数」
    // 3. 将 A[i] 与 A[k] 交换
    // 4. 可以断定这时 [j,end) 必然是降序，逆置 [j,end)，使其升序
    // 5. 如果在步骤 1 找不到符合的相邻元素对，说明当前 [begin,end) 为一个降序顺序，则直接跳到步骤 4
    func nextPermutation(_ nums: inout [Int]) {
        var i = nums.count - 2
        // 1.从后向前查找，找到第一个升序
        while i >= 0 && nums[i] >= nums[i+1] {
            i -= 1;
        }
        // 2.在区间[i, end]之间查找第一个满足 A[i] < A[j]，然后交换
        if i >= 0 {
            var j = nums.count - 1
            while j >= 0 && nums[i] >= nums[j] {
                j -= 1
            }
            nums.swapAt(i, j)
        }
        // 3.这时 [i+1,end) 必然是降序，逆置 [j,end)，使其升序
        var left = i + 1
        var right = nums.count - 1
        while left < right {
            nums.swapAt(left, right)
            left += 1
            right -= 1
        }
    }
    
    // 栈法: 给你一个只包含 '(' 和 ')' 的字符串，找出最长有效（格式正确且连续）括号 子串 的长度。左右括号匹配，即每个左括号都有对应的右括号将其闭合的字符串是格式正确的，比如 "(()())"。
    func longestValidParentheses(_ s: String) -> Int {
        // 让第一个有效括号子串也能正确计算长度（例如"()"，如果没有-1，长度会出错）
        var stack: [Int] = [-1]
        var maxLen = 0
        for (i, ch) in s.enumerated() {
            if ch == "(" {
                stack.append(i)
            } else {
                stack.removeLast()
                if stack.isEmpty {
                    stack.append(i)
                } else {
                    maxLen = max(maxLen, i - stack.last!)
                }
            }
        }
        return maxLen
    }
    
    // 将数组从中间分开成左右两部分的时候，一定有一部分的数组是有序的，从有序的部分确定 target 在哪边
    func search(_ nums: [Int], _ target: Int) -> Int {
        var left = 0
        var right = nums.count - 1
        while left <= right {
            let mid = (left + right) / 2
            if nums[mid] == target {
                return mid
            }
            if nums[left] <= nums[mid] {
                if nums[left] <= target && target < nums[mid] {
                    right = mid - 1
                } else {
                    left = mid + 1
                }
            } else {
                if nums[mid] <= target && target <= nums[right] {
                    left = mid + 1
                } else {
                    right = mid - 1
                }
            }
        }
        return -1
    }
    
    // 给你一个按照非递减顺序排列的整数数组 nums，和一个目标值 target。请你找出给定目标值在数组中的开始位置和结束位置。
    func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
        var result:[Int] = Array<Int>()
        var left = 0
        var right = nums.count - 1
        while left <= right {
            var mid = (left + right) / 2
            if nums[mid] == target {
                while mid > left && nums[mid] == nums[mid-1] {
                    mid -= 1
                }
                result.append(mid)
                while mid < right && nums[mid] == nums[mid+1] {
                    mid += 1
                }
                result.append(mid)
                return result
            }
            if nums[mid] < target {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        if result.count != 0 {
            return result
        }
        return [-1, -1]
    }
    
    // 给定一个排序数组和一个目标值，在数组中找到目标值，并返回其索引。如果目标值不存在于数组中，返回它将会被按顺序插入的位置。
    func searchInsert(_ nums: [Int], _ target: Int) -> Int {
        var left = 0
        var right = nums.count - 1
        var index = nums.count
        while left <= right {
            let mid = (left + right) / 2
            if nums[mid] >= target {
                index = mid
                right = mid - 1
            } else {
                left = mid + 1
            }
        }
        return index
    }
    
    // 请你判断一个 9 x 9 的数独是否有效。只需要 根据以下规则 ，验证已经填入的数字是否有效即可。
    // 数字 1-9 在每一行只能出现一次。
    // 数字 1-9 在每一列只能出现一次。
    // 数字 1-9 在每一个以粗实线分隔的 3x3 宫内只能出现一次。（请参考示例图）
    func isValidSudoku(_ board: [[Character]]) -> Bool {
        var rowSets: [Set<Character>] = Array(repeating: Set<Character>(), count: 9)
        var columnSets: [Set<Character>] = Array(repeating: Set<Character>(), count: 9)
        var boxSets: [Set<Character>] = Array(repeating: Set<Character>(), count: 9)
        for (row, chars) in board.enumerated() {
            for (column, char) in chars.enumerated() {
                if char == "." {
                    continue
                }
                if rowSets[row].contains(char) {
                    return false
                } else {
                    rowSets[row].insert(char)
                }
                if columnSets[column].contains(char) {
                    return false
                } else {
                    columnSets[column].insert(char)
                }
                if boxSets[column / 3 + row / 3 * 3].contains(char) {
                    return false
                } else {
                    boxSets[column / 3 + row / 3 * 3].insert(char)
                }
            }
        }
        return true
    }
    
    /**
     https://zhuanlan.zhihu.com/p/310286600
    编写一个程序，通过填充空格来解决数独问题。
    数独的解法需 遵循如下规则：
    数字 1-9 在每一行只能出现一次。
    数字 1-9 在每一列只能出现一次。
    数字 1-9 在每一个以粗实线分隔的 3x3 宫内只能出现一次。（请参考示例图）
    数独部分空格内已填入了数字，空白格用 '.' 表示。
     */
    func solveSudoku(_ board: inout [[Character]]) {
        // 简单回溯函数：从左到右、从上到下找空格，尝试填 '1'~'9'
        func backtrack(_ board: inout [[Character]]) -> Bool {
            for i in 0..<9 {
                for j in 0..<9 {
                    if board[i][j] == "." {
                        for num in "123456789" {
                            if isValid(board, i, j, num) {
                                board[i][j] = num
                                if backtrack(&board) {
                                    return true      // 递归能补完，成功！
                                }
                                board[i][j] = "."   // 回溯：试错撤销
                            }
                        }
                        return false                 // 1~9都不行，需要回溯上层
                    }
                }
            }
            return true  // 没有空格了，说明成功填好！
        }
        // 判合法：行/列/宫格都不能重复
        func isValid(_ board: [[Character]], _ row: Int, _ col: Int, _ num: Character) -> Bool {
            for k in 0..<9 {
                if board[row][k] == num { return false }
                if board[k][col] == num { return false }
                let boxRow = 3 * (row/3) + k/3
                let boxCol = 3 * (col/3) + k%3
                if board[boxRow][boxCol] == num { return false }
            }
            return true
        }
        _ = backtrack(&board)
    }
    
    // 将连续相同字符（重复两次或更多次）替换为字符重复次数（运行长度）和字符的串联
    // 给定一个整数 n ，返回 外观数列 的第 n 个元素。
    func countAndSay(_ n: Int) -> String {
        var result = "1"
        if n == 1 {
            return result
        }
        // 从第2项开始，每次都"读出"当前项
        for _ in 2...n {
            result = readNumber(result)
        }
        // 读出数字：统计连续相同字符的个数
        func readNumber(_ s: String) -> String {
            var result = ""
            let chars = Array(s)
            var i = 0
            while i < chars.count {
                let currentChar = chars[i]
                var count = 1
                // 统计连续相同字符
                while i + count < chars.count && chars[i + count] == currentChar {
                    count += 1
                }
                // 格式：个数 + 字符
                result += "\(count)\(currentChar)"
                i += count
            }
            return result
        }
        return result
    }
    
    // 给你一个 无重复元素 的整数数组 candidates 和一个目标整数 target ，找出 candidates 中可以使数字和为目标数 target 的 所有 不同组合 ，并以列表形式返回。你可以按 任意顺序 返回这些组合。
    func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
        if candidates.count == 0 {
            return []
        }
        var result = Array<Array<Int>>()
        var path = Array<Int>()
        dfs(candidates, target, 0, candidates.count, &result, &path)
        func dfs(_ candidates:[Int], _ target: Int, _ begin:Int, _ len: Int, _ result: inout [[Int]], _ path: inout [Int]) {
            if target < 0 {
                return
            }
            if target == 0 {
                // 由于 Swift 中的 Array 是值类型，所以每次 append 的时候都会创建一个新的副本
                result.append(path)
                return
            }
            var index = begin
            while index < len {
                path.append(candidates[index])
                dfs(candidates, target - candidates[index], index, len, &result, &path)
                path.removeLast()
                index += 1
            }
        }
        return result
    }
    /*
     给定一个候选人编号的集合 candidates 和一个目标数 target ，找出 candidates 中所有可以使数字和为 target 的组合。
     candidates 中的每个数字在每个组合中只能使用 一次 。
     */
    func combinationSum2(_ candidates: [Int], _ target: Int) -> [[Int]] {
        if candidates.count == 0 {
            return []
        }
        var result = Array<Array<Int>>()
        var path = Array<Int>()
        dfs2(candidates.sorted(), target, 0, candidates.count, &result, &path)
        func dfs2(_ candidates: [Int], _ target: Int, _ begin: Int, _ len: Int, _ result: inout [[Int]], _ path: inout [Int]) {
            // 大剪枝：减去 candidates[i] 小于 0，减去后面的 candidates[i + 1]、candidates[i + 2] 肯定也小于 0，因此用 return
            if target < 0 {
                return
            }
            if target == 0 {
                result.append(path)
                return
            }
            var index = begin
            while index < len {
                // 小剪枝：同一层相同数值的结点，从第 2 个开始，候选数更少，结果一定发生重复，因此跳过，用 continue
                if index > begin && candidates[index] == candidates[index - 1] {
                    index += 1
                    continue
                }
                path.append(candidates[index])
                dfs2(candidates, target - candidates[index], index + 1, len, &result, &path)
                path.removeLast()
                index += 1
            }
        }
        return Array(result)
    }
}
