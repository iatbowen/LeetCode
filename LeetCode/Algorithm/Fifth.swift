//
//  Fifth.swift
//  LeetCode
//
//  Created by 叶修 on 2025/8/19.
//

import Foundation

class Fifth {
    init() {
        print("41. 缺失的第一个正数:\(firstMissingPositive([3,2,1]))")
        print("42. 接雨水:\(trap([4,2,0,3,2,5]))")
        print("43. 字符串相乘:\(multiply("12", "12"))")
        print("44. 通配符匹配:\(isMatch("abcd", "a*d"))")
        print("45. 跳跃游戏 II:\(jump([2,3,1,1,4]))")
        print("46. 全排列:\(permute([1,2,3]))")
        print("47. 全排列 II:\(permuteUnique([1,1,2]))")
        var matrix = [[1,2,3],[4,5,6],[7,8,9]]
        print("48. 旋转图像:\(rotate(&matrix))")
        print("49. 字母异位词分组:\(groupAnagrams(["eat", "tea", "tan", "ate", "nat", "bat"]))")
        print("50. Pow(x, n):\(myPow(2, 4))")
    }
    
    // 给你一个未排序的整数数组 nums ，请你找出其中没有出现的最小的正整数。
    // 对于一个长度为 N 的数组，其中没有出现的最小正整数只能在 [1,N+1] 中。这是因为如果 [1,N] 都出现了，那么答案是 N+1
    func firstMissingPositive(_ nums: [Int]) -> Int {
        var nums = nums
        //！为了将负数剔除，我们优先将其置换成 越界的数，长度为n的数组，最小缺失正整数要么在[1, n]，要么刚好是n+1
        for i in 0..<nums.count {
            if nums[i] <= 0 {
                nums[i] = nums.count + 1
            }
        }
        //！已经出现过的 [1, n] 区间内的正数，使用index索引标记。使用绝对值即使后续的值被改动，也不影响后续位置的判断
        for i in 0..<nums.count {
            let num = Int(abs(nums[i]))
            if num <= nums.count {
                nums[num-1] = -abs(nums[num-1])
            }
        }
        //! 因为数组是有序的，所以坐标上的元素如果是正数，说明没被标记，是 缺失的第一个正数
        for i in 0..<nums.count {
            if nums[i] > 0 {
                return i + 1
            }
        }
        return nums.count + 1
    }
    
    // 给定 n 个非负整数表示每个宽度为 1 的柱子的高度图，计算按此排列的柱子，下雨之后能接多少雨水。
    func trap(_ height: [Int]) -> Int {
        var sum = 0   // 用于保存总共接住的雨水数量
        
        // 1. 预处理每个位置左边（不含本身）最高的柱子高度
        var leftMaxArray = Array(repeating: 0, count: height.count)
        var index = 1
        while index < height.count {
            // 当前 i 位置左边的最大高度 = max(左边第一个的最大，左边那根柱子的高度)
            leftMaxArray[index] = max(leftMaxArray[index-1], height[index-1])
            index += 1
        }
        
        // 2. 预处理每个位置右边（不含本身）最高的柱子高度
        var rightMaxArray = Array(repeating: 0, count: height.count)
        index = height.count - 2
        while index >= 0 {
            // 当前 i 位置右边的最大高度 = max(右边第一个的最大，右边那根柱子的高度)
            rightMaxArray[index] = max(rightMaxArray[index+1], height[index+1])
            index -= 1
        }
        
        // 3. 遍历每个柱子，计算当前位置能接多少水
        index = 0
        while index < height.count - 1 {
            // 取当前位置左右两边最大高度的较小者
            let minMax = min(leftMaxArray[index], rightMaxArray[index])
            // 如果当前位置高度低于两边较小高度，说明这里可以接水，计算并累加
            if height[index] < minMax {
                sum += minMax - height[index]
            }
            index += 1
        }
        return sum
    }
    
    // 给定两个以字符串形式表示的非负整数 num1 和 num2，返回 num1 和 num2 的乘积，它们的乘积也表示为字符串形式。
    func multiply(_ num1: String, _ num2: String) -> String {
        // 把字符串转成字符数组，方便按位操作
        let chars1 = Array(num1)
        let chars2 = Array(num2)
        // 用数组保存每一位的数字，长度等于两个原数字长度相加（最多乘积有这么多位）
        var array = Array(repeating: 0, count: num1.count + num2.count)
        // 从个位（最右）开始，倒着遍历num1每一位
        var i = chars1.count - 1
        while i >= 0 {
            let num1 = chars1[i].wholeNumberValue! // 取当前位的数字
            // 同样从个位开始，遍历num2每一位
            var j = chars2.count - 1
            while j >= 0 {
                let num2 = chars2[j].wholeNumberValue! // 取当前位的数字
                // 乘积结果要加到 i+j+1 位（这是竖式的规律）
                let sum = array[i + j + 1] + num1 * num2
                // 当前位保存个位
                array[i + j + 1] = sum % 10
                // 左边一位累加进位
                array[i + j] += sum / 10
                j -= 1
            }
            i -= 1
        }
        // 去掉前导零，拼成字符串
        var string = String()
        for (index, num) in array.enumerated() {
            // 前导零不加（除了最后一位可以是0）
            if array[index] == 0 && string.count == 0 && index != array.count - 1 {
                continue
            }
            string.append(String(num))
        }
        return string
    }
    
    /*
     给你一个输入字符串 (s) 和一个字符模式 (p) ，请你实现一个支持 '?' 和 '*' 匹配规则的通配符匹配：
     '?' 可以匹配任何单个字符。
     '*' 可以匹配任意字符序列（包括空字符序列）。
     判定匹配成功的充要条件是：字符模式必须能够 完全匹配 输入字符串（而不是部分匹配）。
     */
    func isMatch(_ s: String, _ p: String) -> Bool {
        guard !p.isEmpty else {
            return s.isEmpty
        }
        let sChars = Array(s)                                // 将原字符串s转换为字符数组，便于下标访问
        let pChars = Array(p)                                // 将模式串p转换为字符数组
        let m = sChars.count, n = pChars.count               // 分别记录两个字符串的长度
        
        // 创建DP表，dp[i][j]表示s的前i个字符和p的前j个字符是否可以匹配
        var dp = Array(repeating: Array(repeating: false, count: n + 1), count: m + 1)
        dp[0][0] = true                                     // 空字符串和空模式可以匹配
        
        // 处理p以若干'*'开头的特殊情况：p的前j个字符都是*时，可以匹配空串
        for j in 1...n {
            if pChars[j-1] == "*" {
                dp[0][j] = true                      // 空串和前j-1个*能匹配，只要本轮也是*就也能匹配
            }
        }
        
        guard !s.isEmpty else {
            return dp[0][n]
        }
        
        // 填写DP表
        for i in 1...m {                                   // 遍历s的每个前缀
            for j in 1...n {                               // 遍历p的每个前缀
                if pChars[j-1] == "?" || pChars[j-1] == sChars[i-1] {
                    // 如果当前p是?，或与当前s字符完全一致，则沿用左上角值（即i-1长度和j-1长度的匹配结果）
                    dp[i][j] = dp[i-1][j-1]
                } else if pChars[j-1] == "*" {
                    // 如果当前p是*号，有两种情况：
                    // 1. * 匹配0个字符（即dp[i][j-1]，模式右移，源串不动）
                    // 2. * 匹配当前s[i-1]字符（即dp[i-1][j]，源串右移，模式不动）
                    dp[i][j] = dp[i][j-1] || dp[i-1][j]
                }
                // 否则（字符不匹配且不是?或*），dp[i][j]保持默认false
            }
        }
        return dp[m][n]                                     // 返回s字符串和p模式串是否完全匹配
    }
    
    /*
     贪心算法：
     给定一个长度为 n 的 0 索引整数数组 nums。初始位置为 nums[0]。
     每个元素 nums[i] 表示从索引 i 向后跳转的最大长度。换句话说，如果你在索引 i 处，你可以跳转到任意 (i + j) 处：
     0 <= j <= nums[i] 且 i + j < n
     返回到达 n - 1 的最小跳跃次数。测试用例保证可以到达 n - 1。
     */
    func jump(_ nums: [Int]) -> Int {
        var count = 0
        var start = 0
        var end = 1
        while end < nums.count {
            var maxNum = 0
            var index = start
            while index < end {
                // 能跳到最远的距离
                maxNum = max(maxNum, index + nums[index])
                index += 1
            }
            // 下一次起跳点范围开始的格子
            start = end
            // 下一次起跳点范围结束的格子
            end = maxNum + 1
            // 跳跃次数
            count += 1
        }
        return count
    }
    
    // https://leetcode.cn/problems/permutations/solutions/9914/hui-su-suan-fa-python-dai-ma-java-dai-ma-by-liweiw/
    // 回溯法: 给定一个不含重复数字的数组 nums ，返回其 所有可能的全排列 。你可以 按任意顺序 返回答案。
    func permute(_ nums: [Int]) -> [[Int]] {
        var paths = Array<Array<Int>>()
        var current = Array<Int>()
        var useds = Array(repeating: false, count: nums.count)
        dfsNums(nums, 0, &paths, &current, &useds)
        func dfsNums(_ nums: [Int], _ depth: Int, _ paths: inout [[Int]], _ current: inout [Int], _ useds: inout [Bool]) {
            if depth > nums.count {
                return
            }
            if depth == nums.count {
                paths.append(current)
            }
            var index = 0
            while index < nums.count {
                if useds[index] {
                    index += 1
                    continue
                }
                useds[index] = true
                current.append(nums[index])
                dfsNums(nums, depth + 1, &paths, &current, &useds)
                useds[index] = false
                current.removeLast()
                index += 1
            }
        }
        return paths
    }
    
    // 给定一个可包含重复数字的序列 nums ，按任意顺序 返回所有不重复的全排列。
    func permuteUnique(_ nums: [Int]) -> [[Int]] {
        var path = Array<Array<Int>>()
        var current = Array<Int>()
        var used = Array(repeating: false, count: nums.count)
        dfsNums(nums.sorted(), 0, &path, &current, &used)
        func dfsNums(_ nums: [Int], _ depth: Int, _ path: inout [[Int]], _ current: inout [Int], _ used: inout [Bool]) {
            if depth > nums.count {
                return
            }
            if depth == nums.count {
                path.append(current)
            }
            var index = 0
            while index < nums.count {
                // 写 !used[index - 1] 是因为 nums[index - 1] 在深度优先遍历的过程中刚刚被撤销选择
                if used[index] || (index > 0 && nums[index] == nums[index - 1] && !used[index - 1]) {
                    index += 1
                    continue
                }
                current.append(nums[index])
                used[index] = true
                dfsNums(nums, depth + 1, &path, &current, &used)
                used[index] = false
                current.removeLast()
                index += 1
            }
        }
        return Array(path)
    }
    
    // 给定一个 n × n 的二维矩阵 matrix 表示一个图像。请你将图像顺时针旋转 90 度。
    func rotate(_ matrix: inout [[Int]]) {
        let n = matrix.count
        // 水平翻转
        for i in 0..<n {
            for j in i..<n {
                let temp = matrix[i][j]
                matrix[i][j] = matrix[j][i]
                matrix[j][i] = temp
            }
        }
        // 主对角线翻转
        for i in 0..<n {
            for j in 0..<n/2 {
                let temp = matrix[i][j]
                matrix[i][j] = matrix[i][n-j-1]
                matrix[i][n-j-1] = temp
            }
        }
    }
    
    // 给你一个字符串数组，请你将 字母异位词 组合在一起。可以按任意顺序返回结果列表。
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        // 排序+map
        var map: [String: Array<String>] = Dictionary<String, Array<String>>()
        for str in strs {
            let chars = Array(str)
            let sortString = String(chars.sorted())
            var array = map[sortString]
            if array == nil {
                array = [str]
            } else {
                array?.append(str)
            }
            map[sortString] = array
        }
        return Array(map.values)
    }
    
    // https://leetcode.cn/problems/powx-n/solutions/241471/50-powx-n-kuai-su-mi-qing-xi-tu-jie-by-jyd/
    // 实现 pow(x, n) ，即计算 x 的整数 n 次幂函数（即，xn ）。
    func myPow(_ x: Double, _ n: Int) -> Double {
        var result: Double = 1           // 用于保存最终结果，初始化为1
        var x = x                        // 因为x后面会修改，所以用变量
        var n = n                        // 因为n后面会修改，所以也用变量
        // 如果指数n是负数
        if n < 0 {
            // x变为1/x，同时n取相反数（变为正），相当于把x倒数，n变正
            x = 1 / x
            n = -n
        }
        // 二分法进行快速幂运算
        while n > 0 {
            // 如果n是奇数，当前这个x要乘到结果上
            if n % 2 == 1 {
                result = result * x
            }
            // x翻倍，相当于x的二倍幂
            x *= x
            // n减半，只需要计算高位
            n /= 2
        }
        return result
    }

}
