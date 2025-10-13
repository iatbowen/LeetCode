//
//  Eighth.swift
//  LeetCode
//
//  Created by 叶修 on 2025/8/21.
//

import Foundation

class Eighth {
    init() {
        print("71. 简化路径:\(simplifyPath("/home/user/Documents//../Pictures"))")
        print("72. 编辑距离:\(minDistance("horse", "ros"))")
        var matrix = [[1,1,1],[1,0,1],[1,1,1]]
        print("73. 矩阵置零:\(setZeroes(&matrix))")
        print("74. 搜索二维矩阵:\(searchMatrix([[1,3,5,7],[10,11,16,20],[23,30,34,60]], 16))")
        var nums = [2,0,2,1,1,0]
        sortColors(&nums)
        print("75. 颜色分类:\(nums)")
        print("76. 最小覆盖子串:\(minWindow("ADOBECODEBANC", "ABC"))")
        print("77. 组合:\(combine(4, 3))")
        print("78. 子集:\(subsets([1,2,3]))")
        print("79. 单词搜索:\(exist([["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], "ABCCED"))")
        var numlist = [1,1,1,2,2,3]
        print("80. 删除有序数组中的重复项 II:\(removeDuplicates(&numlist))")
    }
    
    /*
     栈：
     给你一个字符串 path ，表示指向某一文件或目录的 Unix 风格 绝对路径 （以 '/' 开头），请你将其转化为 更加简洁的规范路径。
     在 Unix 风格的文件系统中规则如下：
     一个点 '.' 表示当前目录本身。
     此外，两个点 '..' 表示将目录切换到上一级（指向父目录）。
     任意多个连续的斜杠（即，'//' 或 '///'）都被视为单个斜杠 '/'。
     任何其他格式的点（例如，'...' 或 '....'）均被视为有效的文件/目录名称。
     
     返回的 简化路径 必须遵循下述格式：
     始终以斜杠 '/' 开头。
     两个目录名之间必须只有一个斜杠 '/' 。
     最后一个目录名（如果存在）不能 以 '/' 结尾。
     此外，路径仅包含从根目录到目标文件或目录的路径上的目录（即，不含 '.' 或 '..'）。
     返回简化后得到的 规范路径 。
     */
    func simplifyPath(_ path: String) -> String {
        let paths = path.components(separatedBy: "/")
        var stack = Array<String>()
        for route in paths {
            if route == ".." {
                if stack.count > 0 {
                    stack.removeLast()
                }
            } else if route != "." && route.count > 0{
                stack.append(route)
            }
        }
        return "/" + stack.joined(separator: "/")
    }
    
    /*
     给你两个单词 word1 和 word2， 请返回将 word1 转换成 word2 所使用的最少操作数。
     你可以对一个单词进行如下三种操作：插入一个字符、删除一个字符、替换一个字符
     */
    func minDistance(_ word1: String, _ word2: String) -> Int {
        let m = word1.count + 1    // dp的行数（比word1多一行，考虑到空串情况）
        let n = word2.count + 1    // dp的列数（比word2多一列）
        // 初始化二维数组
        var dp = Array(repeating:Array(repeating: 0, count: n), count: m)
        // 初始化 dp[i][0]: word1 前 i 个字符变成空串的距离
        var i = 1
        while i < m {
            dp[i][0] = i
            i += 1
        }
        // 初始化 dp[0][j]: 空串变成 word2 前 j 个字符的距离
        var j = 1
        while j < n {
            dp[0][j] = j
            j += 1
        }
        // 将字符串变为字符数组，方便索引
        let chars1 = Array(word1)
        let chars2 = Array(word2)
        // 动态规划填表
        i = 1
        while i < m {
            j = 1
            while j < n {
                // 先三种操作都算一遍：替换、删除、插入
                dp[i][j] = min(
                    dp[i - 1][j - 1], // 替换
                    min(dp[i - 1][j], // 删除
                        dp[i][j - 1]) // 插入
                ) + 1
                // 如果字符相同，则不需要操作
                if (chars1[i - 1] == chars2[j - 1]) {
                    dp[i][j] = min(dp[i][j], dp[i - 1][j - 1])
                }
                j += 1
            }
            i += 1
        }
        // 返回最终答案：word1全部变成word2的最小编辑距离
        return dp[m-1][n-1]
    }
    
    // 给定一个 m x n 的矩阵，如果一个元素为 0 ，则将其所在行和列的所有元素都设为 0 。请使用 原地 算法。
    func setZeroes(_ matrix: inout [[Int]]) {
        let m = matrix.count
        let n = matrix[0].count
        var rows: [Bool] = Array<Bool>(repeating: false, count: m)
        var columns: [Bool] = Array<Bool>(repeating: false, count: n)
        // 第一次遍历：标记哪些行和列需要置零
        var i = 0
        while i < m {
            var j = 0
            while j < n {
                if matrix[i][j] == 0 {
                    rows[i] = true
                    columns[j] = true
                }
                j += 1
            }
            i += 1
        }
        
        i = 0
        while i < m {
            var j = 0
            while j < n {
                if rows[i] || columns[j] {
                    matrix[i][j] = 0
                }
                j += 1
            }
            i += 1
        }
    }
    
    /**
     两次二分查找：
     给你一个满足下述两条属性的 m x n 整数矩阵：
     每行中的整数从左到右按非严格递增顺序排列。
     每行的第一个整数大于前一行的最后一个整数。
     给你一个整数 target ，如果 target 在矩阵中，返回 true ；否则，返回 false 。
     */
    func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
        let rowNum = matrix.count
        var l = 0, r = rowNum - 1
        while l <= r {
            let mid = (l + r) / 2
            if matrix[mid][0] == target {
                return true
            }
            if matrix[mid][0] > target {
                r = mid - 1
            } else {
                l = mid + 1
            }
        }
        if r < 0  {
            return false
        }
        // r 指向最后一个小于等于 target 的行，l 指向第一个大于 target 的行
        let row = r
        let rowArray = matrix[row]
        if rowArray[0] == target {
            return true
        }
        if rowArray[0] > target {
            return false
        }
        l = 0
        r = rowArray.count - 1
        while l <= r {
            let mid = (l + r) / 2
            if rowArray[mid] == target {
                return true
            }
            if rowArray[mid] > target {
                r = mid - 1
            } else {
                l = mid + 1
            }
        }
        return false
    }
    
    // 给定一个包含红色、白色和蓝色、共 n 个元素的数组 nums ，原地 对它们进行排序，使得相同颜色的元素相邻，并按照红色、白色、蓝色顺序排列。
    func sortColors(_ nums: inout [Int]) {
        var i = 0
        while i < nums.count {
            var j = i + 1
            while j < nums.count {
                if nums[i] > nums[j] {
                    let temp = nums[j]
                    nums[j] = nums[i]
                    nums[i] = temp
                }
                j += 1
            }
            i += 1
        }
    }
    
    /*
     滑动窗口：给你一个字符串 s 、一个字符串 t 。返回 s 中涵盖 t 所有字符的最小子串。如果 s 中不存在涵盖 t 所有字符的子串，则返回空字符串 "" 。
     算法思想：滑动窗口+哈希表（双指针+频次统计+区间压缩）
     在 s 上维护一个区间 [left, right)，表示当前选中的子串。
     不断向右拓展 right，使窗口包含尽可能多 t 的字符。
     当窗口已包含所有 t 的字符后，开始收缩 left，去掉不必要的字符，尝试缩短窗口长度。
     整个过程中实时记录满足条件的最小窗口。
     */
    func minWindow(_ s: String, _ t: String) -> String {
        let sArr = [Character](s)
        // 窗口的字典
        var windowDict = [Character: Int]()
        // 所需字符的字典
        var needDict = [Character: Int]()
        for c in t {
            needDict[c, default: 0] += 1
        }
        
        // 当前窗口的左右两端
        var left = 0, right = 0
        // 匹配次数，等于needDict的key数量时代表已经匹配完成
        var matchCnt = 0
        // 用来记录最终的取值范围
        var start = 0, end = 0
        // 记录最小范围
        var minLen = Int.max
        
        while right < sArr.count {
            // 开始移动窗口右侧端点
            let rChar = sArr[right]
            right += 1
            // 右端点字符不是所需字符直接跳过
            if needDict[rChar] == nil { continue }
            // 窗口中对应字符数量+1
            windowDict[rChar, default: 0] += 1
            // 窗口中字符数量达到所需数量时，匹配数+1
            if windowDict[rChar] == needDict[rChar] {
                matchCnt += 1
            }
            
            // 如果匹配完成，开始移动窗口左侧断点, 目的是为了寻找当前窗口的最小长度
            while matchCnt == needDict.count {
                // 记录最小范围
                if right - left < minLen {
                    start = left
                    end = right
                    minLen = right - left
                }
                let lChar = sArr[left]
                left += 1
                if needDict[lChar] == nil { continue }
                // 如果当前左端字符的窗口中数量和所需数量相等，则后续移动就不满足匹配了，匹配数-1，退出循环
                if needDict[lChar] == windowDict[lChar] {
                    matchCnt -= 1
                }
                // 减少窗口字典中对应字符的数量
                windowDict[lChar]! -= 1
            }
        }
        return minLen == Int.max ? "" : String(sArr[start..<end])
    }
    
    // 给定两个整数 n 和 k，返回范围 [1, n] 中所有可能的 k 个数的组合。
    func combine(_ n: Int, _ k: Int) -> [[Int]] {
        var res = Array<Array<Int>>()
        var paths = Array<Int>()
        dfsNums(n, &paths, 1, &res);
        func dfsNums(_ n: Int, _ paths: inout [Int], _ depth: Int, _ res: inout [[Int]]) {
            if paths.count == k {
                res.append(paths)
                return
            }
            var i = depth
            while i <= n {
                paths.append(i)
                dfsNums(n, &paths, i + 1, &res)
                paths.removeLast()
                i += 1
            }
        }
        return res
    }
    
    /*
     给你一个整数数组 nums ，数组中的元素 互不相同 。返回该数组所有可能的子集（幂集）。
     解集 不能 包含重复的子集。你可以按 任意顺序 返回解集。
     */
    func subsets(_ nums: [Int]) -> [[Int]] {
        var res = Array<Array<Int>>()
        var path = Array<Int>()
        dfsSubsets(nums, &path, &res, 0)
        func dfsSubsets(_ nums: [Int], _ paths: inout [Int], _ res: inout [[Int]], _ start: Int) {
            res.append(paths)
            var index = start
            while index < nums.count {
                paths.append(nums[index])
                dfsSubsets(nums, &paths, &res, index + 1)
                paths.removeLast()
                index += 1
            }
        }
        return res
    }
    
    /*
     给定一个 m x n 二维字符网格 board 和一个字符串单词 word 。如果 word 存在于网格中，返回 true ；否则，返回 false 。
     单词必须按照字母顺序，通过相邻的单元格内的字母构成，其中“相邻”单元格是那些水平相邻或垂直相邻的单元格。同一个单元格内的字母不允许被重复使用
     */
    func exist(_ board: [[Character]], _ word: String) -> Bool {
        let rows = board.count
        let cols = board[0].count
        let wordArray = Array(word)
        var board = board  // 创建可变副本
        
        // 遍历每个位置作为起点
        for i in 0..<rows {
            for j in 0..<cols {
                if dfs(&board, i, j, wordArray, 0) {
                    return true
                }
            }
        }
        // DFS 搜索函数
        func dfs(_ board: inout [[Character]],
                 _ row: Int, _ col: Int,
                 _ word: [Character], _ index: Int) -> Bool {
            
            // 1. 找到完整单词
            if index == word.count {
                return true
            }
            
            // 2. 边界检查
            if row < 0 || row >= board.count ||
                col < 0 || col >= board[0].count {
                return false
            }
            
            // 3. 字符不匹配或已访问
            if board[row][col] != word[index] {
                return false
            }
            
            // 4. 标记当前位置为已访问
            let temp = board[row][col]
            board[row][col] = "#"  // 标记为已访问
            
            // 5. 搜索四个方向
            let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
            for (dr, dc) in directions {
                let newRow = row + dr
                let newCol = col + dc
                
                if dfs(&board, newRow, newCol, word, index + 1) {
                    board[row][col] = temp  // 恢复现场
                    return true
                }
            }
            
            // 6. 回溯：恢复当前位置
            board[row][col] = temp
            return false
        }
        return false
    }
    
    // 给你一个有序数组 nums ，请你 原地 删除重复出现的元素，使得出现次数超过两次的元素只出现两次 ，返回删除后数组的新长度。
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        if nums.count <= 2 {
            return nums.count
        }
        func process(_ nums: inout [Int], _ k:Int) -> Int {
            var length = k
            var index = k
            while index < nums.count {
                let num = nums[index]
                if nums[length-k] != num {
                    nums[length] = num
                    length += 1
                }
                index += 1
            }
            return length
        }
        return process(&nums, 2)
    }
    
}
