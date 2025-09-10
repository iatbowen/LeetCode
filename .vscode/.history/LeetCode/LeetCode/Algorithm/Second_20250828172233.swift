//
//  Second.swift
//  LeetCode
//
//  Created by 叶修 on 2025/8/18.
//

import Foundation

class Second {
    init() {
        print("11. 盛最多水的容器:\(maxArea([1,8,6,2,5,4,8,3,7]))")
        print("12. 整数转罗马数字:\(intToRoman(3749))")
        print("13. 罗马数字转整数:\(romanToInt("MCMXCIV"))")
        print("14. 最长公共前缀:\(longestCommonPrefix(["flower","flow","flight"]))")
        print("15. 三数之和:\(threeSum([-1,0,1,2,-1,-4]))")
        print("16. 最接近的三数之和:\(threeSumClosest([-1,2,1,-4], 1))")
        print("17. 电话号码的字母组合:\(letterCombinations("24"))")
        print("18. 四数之和:\(fourSum([1,0,-1,0,-2,2], 0))")
        let l1 = ListNode(2)
        l1.next = ListNode(3)
        l1.next?.next = ListNode(4)
        print("19. 删除链表的倒数第 N 个结点:\(String(describing: removeNthFromEnd(l1, 2)?.print()))")
        print("20. 有效的括号:\(isValid("{()[]{}}"))")
    }
    
    // 双指针法: 给定一个长度为 n 的整数数组 height 。有 n 条垂线，第 i 条线的两个端点是 (i, 0) 和 (i, height[i]) 。找出其中的两条线，使得它们与 x 轴共同构成的容器可以容纳最多的水。
    func maxArea(_ height: [Int]) -> Int {
        var left = 0
        var right = height.count - 1
        var maxWater = 0
        while left < right {
            let minHeight = min(height[left], height[right])
            let width = right - left
            let area = minHeight * width
            maxWater = max(maxWater, area)
            // 移动较短的一边
            if height[left] < height[right] {
                left += 1
            } else {
                right -= 1
            }
        }
        return maxWater
    }
    func intToRoman(_ num: Int) -> String {
        // 用元组表示数值和对应的罗马字母，从大到小排列
        let romanMap: [(Int, String)] = [
            (1000, "M"),
            (900, "CM"),
            (500, "D"),
            (400, "CD"),
            (100, "C"),
            (90, "XC"),
            (50, "L"),
            (40, "XL"),
            (10, "X"),
            (9, "IX"),
            (5, "V"),
            (4, "IV"),
            (1, "I")
        ]
        var num = num      // 剩下的整数
        var res = ""       // 结果字符串
        for (value, symbol) in romanMap {
            while num >= value {
                res += symbol    // 拼接罗马符号
                num -= value     // 数值减去对应大小
            }
        }
        return res
    }
    
    func romanToInt(_ s: String) -> Int {
        // 罗马字符与数字的映射
        let romanMap: [Character: Int] = [
            "I": 1,
            "V": 5,
            "X": 10,
            "L": 50,
            "C": 100,
            "D": 500,
            "M": 1000
        ]
        let chars = Array(s)      // 将字符串分解为字符数组
        var sum = 0
        for i in 0..<chars.count {
            let value = romanMap[chars[i]]!
            // 有下一个字符而且当前字符代表的数值比下一个小，则减当前值
            if i < chars.count - 1 && value < romanMap[chars[i + 1]]! {
                sum -= value
            } else {
                sum += value
            }
        }
        return sum
    }
    
    func longestCommonPrefix(_ strs: [String]) -> String {
        if strs.isEmpty { return "" }
        var prefix = strs[0]      // 以首个字符串为基准
        for str in strs.dropFirst() {
            while !str.hasPrefix(prefix) {
                prefix = String(prefix.dropLast())   // 逐步缩短公共前缀
                if prefix.isEmpty { return "" }
            }
        }
        return prefix
    }
    
    // 排序和双指针让查找高效：给你一个整数数组 nums ，判断是否存在三元组 [nums[i], nums[j], nums[k]] 满足 i != j、i != k 且 j != k ，同时还满足 nums[i] + nums[j] + nums[k] == 0 。请你返回所有和为 0 且不重复的三元组。
    func threeSum(_ nums: [Int]) -> [[Int]] {
        let numbers = nums.sorted(by: <)
        var result:[Array] = Array<Array<Int>>()
        for (k, _) in numbers.enumerated() {
            // 如果当前这一位已经是正数，后面的也必然是正数，不可能有和为0的三元组，提前结束遍历
            if numbers[k] > 0 {
                break
            }
            // 去重：如果和前一位一样，跳过，避免重复三元组
            if k > 0 && numbers[k] == numbers[k-1]  {
                continue
            }
            var i = k + 1, j = numbers.count - 1
            while i < j {
                let sum = numbers[k] + numbers[i] + numbers[j]
                if sum < 0 {
                    i += 1
                } else if sum > 0 {
                    j -= 1
                } else {
                    result.append([numbers[k], numbers[i] , numbers[j]])
                    // 左边去重
                    while i < j && numbers[i] == numbers[i+1] {
                        i += 1
                    }
                    // 右边去重
                    while i < j && numbers[j] == numbers[j-1] {
                        j -= 1
                    }
                    i += 1
                    j -= 1
                }
            }
        }
        return result
    }
    
    // 给你一个长度为 n 的整数数组 nums 和 一个目标值 target。请你从 nums 中选出三个整数，使它们的和与 target 最接近。
    func threeSumClosest(_ nums: [Int], _ target: Int) -> Int {
        let numbers = nums.sorted(by: <)
        var sum = numbers[0] + numbers[1] + numbers[2]
        for (k, _) in numbers.enumerated() {
            var i = k + 1, j = numbers.count - 1
            while i < j {
                let res = numbers[k] + numbers[i] + numbers[j]
                if abs(target - sum) > abs(target - res) {
                    sum = res
                }
                if res > target {
                    j -= 1
                } else if res < target {
                    i += 1
                } else {
                    return res
                }
            }
        }
        return sum
    }
    
    // 深度优先递归(DFS):给定一个仅包含数字 2-9 的字符串，返回所有它能表示的字母组合。答案可以按 任意顺序 返回。给出数字到字母的映射如下（与电话按键相同）。注意 1 不对应任何字母。
    // 一种遍历树结构或图结构的方法，每次沿一条路径“往深处走到底”，再回退到上一步试别的分支，直到所有点都访问完。常用场景：图遍历、组合枚举、路径探索等
    func letterCombinations(_ digits: String) -> [String] {
        if digits.isEmpty { return [] }
        let map: [Character: [Character]] = [
            "2": ["a","b","c"],
            "3": ["d","e","f"],
            "4": ["g","h","i"],
            "5": ["j","k","l"],
            "6": ["m","n","o"],
            "7": ["p","q","r","s"],
            "8": ["t","u","v"],
            "9": ["w","x","y","z"]
        ]
        var res = [String]()
        var path = ""
        let digitsArr = Array(digits)
        func dfs(_ index: Int) {
            if index == digitsArr.count {
                res.append(path)
                return
            }
            let digit = digitsArr[index]
            guard let letters = map[digit] else { return }
            for letter in letters {
                path.append(letter)
                dfs(index + 1)
                path.removeLast() // 回溯
            }
        }
        dfs(0)
        return res
    }
    
    // 给你一个由 n 个整数组成的数组 nums ，和一个目标值 target 。请你找出并返回满足下述全部条件且不重复的四元组 [nums[a], nums[b], nums[c], nums[d]] （若两个四元组元素一一对应，则认为两个四元组重复）：
    func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
        let numbers = nums.sorted(by: <)
        var set = Set<Array<Int>>()
        for (i, _) in numbers.enumerated() {
            var j = i + 1
            while j < numbers.count {
                var l = j + 1, r = numbers.count - 1
                while l < r {
                    let sum = numbers[i] + numbers[j] + numbers[l] + numbers[r]
                    if sum > target {
                        r -= 1
                    } else if sum < target {
                        l += 1
                    } else {
                        set.insert([numbers[i], numbers[j], numbers[l], numbers[r]])
                        l += 1
                        r -= 1
                    }
                }
                j += 1
            }
        }
        return Array(set)
    }
    
    // 给你一个链表，删除链表的倒数第 n 个结点，并且返回链表的头结点。
    func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
        let h = ListNode(0, head)
        var length = 0
        var temp:ListNode? = h
        while temp != nil {
            length += 1
            temp = temp?.next
        }
        var p:ListNode? = h
        var i = 1
        while i < length - n {
            p = p?.next
            i += 1
        }
        p?.next = p?.next?.next
        return h.next
    }
    
    // 给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串 s ，判断字符串是否有效。
    func isValid(_ s: String) -> Bool {
        let pairs:[Character: Character] = ["(": ")", "[": "]", "{": "}"]
        let letters = Array(s)
        var stack = Array<Character>()
        for letter in letters {
            if pairs[letter] != nil {
                stack.append(letter)
            } else {
                if stack.isEmpty {
                    return false
                }
                if pairs[stack.removeLast()] != letter {
                    return false
                }
            }
        }
        return stack.isEmpty
    }
    
}
