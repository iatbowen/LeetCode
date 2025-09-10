//
//  First.swift
//  LeetCode
//
//  Created by 叶修 on 2025/8/13.
//

import Foundation

class First {
    
    init() {
        print("1. 两数之和：\(twoSum([2,7,11,15], 9))")
        let l1 = ListNode(2)
        l1.next = ListNode(4)
        l1.next?.next = ListNode(3)
        let l2 = ListNode(5)
        l2.next = ListNode(6)
        l2.next?.next = ListNode(4)
        print("2. 两数相加：\(addTwoNumbers(l1, l2)!.print())")
        print("3. 无重复字符的最长子串：\(longestSubstring("abcabbb"))")
        print("4. 找出两个正序数组的中位数: \(findMedianSortedArrays([1,2], [3,4]))")
        print("5. 最长回文子串：\(longestPalindrome("babaab"))")
        print("6. Z 字形变换：\(convert("PAYPALISHIRING", 3))")
        print("7. 整数反转：\(reverse(-123))")
        print("8. 字符串转换整数:\(myAtoi("-1337c0d3"))")
        print("9. 回文数:\(isPalindrome(1221))")
        print("10. 正则表达式匹配:\(isMatch("mississppi", "mis*is*p*."))")
    }
    
    // 给定一个整数数组 nums 和一个整数目标值 target，请你在该数组中找出 和为目标值 target  的那 两个 整数，并返回它们的数组下标。
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var dict = Dictionary<Int, Int>()
        for (index, num1) in nums.enumerated() {
            let num2 = target - num1
            if let idx = dict[num2] {
                return [idx, index]
            }
            dict[num1] = index
        }
        return []
    }
    
    // 给你两个 非空 的链表，它们每位数字都是按照 逆序 的方式存储的，并且每个节点只能存储 一位 数字。请你将两个数相加，并以相同形式返回一个表示和的链表。
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var link1 = l1
        var link2 = l2
        let result = ListNode()
        var current = result
        var sum = 0
        while link1 != nil || link2 != nil {
            if let link = link1 {
                sum += link.val
                link1 = link.next
            }
            if let link = link2 {
                sum += link.val
                link2 = link.next
            }
            current.next = ListNode(sum % 10)
            sum /= 10
            current = current.next!
        }
        if (sum > 0) {
            current.next = ListNode(sum % 10)
        }
        return result.next
    }
    
    /*
    滑动窗口+哈希表：给定一个字符串 s ，请你找出其中不含有重复字符的 最长 子串 的长度
    原理：
    初始“窗口”就像一块色块覆盖着字符串，从左到右扩展，遇到重复字符后右移startIndex，窗口右边继续向右扩展。
    每次扩展时，窗口的内容是无重复的。遇到重复时，窗口的“左侧”跳到重复字符后一位，移除之前的重叠。
    当前窗口长度如果比最大长度大则记下来。
    */
    func longestSubstring(_ s: String) -> String {
        let chars = Array(s)
        var maxStart = 0, maxEnd = 0
        var maxLen = 0, startIndex = 0
        var map = Dictionary<Character, Int>()
        for (endIndex, c) in chars.enumerated() {
            if let pos = map[c] {
                // 防止回退，新窗口从重复字符的下一个位置开始
                startIndex = max(startIndex, pos + 1)
            }
            map[c] = endIndex
            if maxLen < endIndex - startIndex + 1 {
                maxLen = max(maxLen, endIndex - startIndex + 1)
                maxStart = startIndex;
                maxEnd = endIndex;
            }
        }
        return String(chars[maxStart...maxEnd])
    }
    
    // 给定两个大小分别为 m 和 n 的正序（从小到大）数组 nums1 和 nums2。请你找出并返回这两个正序数组的 中位数 。
    func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
        let array = (nums1 + nums2).sorted(by: { $0 < $1})
        if array.isEmpty {
            return 0
        }
        let count = array.count
        if count % 2 == 0 {
            let n1 = array[count / 2 - 1]
            let n2 = array[count / 2]
            let n = Double(n1 + n2) / 2
            return n
        } else {
            let n1 = array[count / 2]
            return Double(n1)
        }
    }
    
    // 中心扩散法：给你一个字符串 s，找到 s 中最长的 回文 子串。
    func longestPalindrome(_ s: String) -> String {
        let chars = Array(s)
        var start = 0, end = 0
        for (index, _) in chars.enumerated() {
            // 奇数长度回文串
            let (startIndex1, endIndex1) = expandAroundCenter(index, index, chars)
            // 偶数长度回文串
            let (startIndex2, endIndex2) = expandAroundCenter(index, index + 1, chars)
            if endIndex1 - startIndex1 > end - start {
                start = startIndex1
                end = endIndex1
            }
            if endIndex2 - startIndex2 > end - start {
                start = startIndex2
                end = endIndex2
            }
        }
        let result = String(chars[start...end])
        return result
    }
    
    // 从中心向两边扩散，找到回文串的边界
    func expandAroundCenter(_ left: Int, _ right: Int, _ chars: [Character]) -> (Int, Int) {
        var l = left, r = right
        while l >= 0 && r < chars.count && chars[l] == chars[r] {
            l -= 1
            r += 1
        }
        return (l + 1, r - 1)
    }
    
    // 将一个给定字符串 s 根据给定的行数 numRows ，以从上往下、从左到右进行 Z 字形排列,输出需要从左往右逐行读取，产生出一个新的字符串
    func convert(_ s: String, _ numRows: Int) -> String {
        if numRows < 2 {
            return s
        }
        var res = Array<String>()
        for _ in 0..<numRows {
            res.append(String())
        }
        let chars = Array(s)
        var row = 0
        var flag = -1
        for char in chars {
            res[row].append(char)
            if row == 0 || row == numRows - 1 {
                flag = -flag
            }
            row += flag
        }
        var string = String()
        for str in res {
            string += str
        }
        return string
    }
    
    // 给你一个 32 位的有符号整数 x ，返回将 x 中的数字部分反转后的结果。
    func reverse(_ x: Int) -> Int {
        var res = 0
        var temp = x
        if x < 0 {
            temp = -x
        }
        while temp > 0 {
            res = res * 10 + temp % 10;
            temp /= 10
        }
        if res > Int32.max || res < Int32.min {
            return 0
        }
        if x < 0 {
            return -res
        }
        return res
    }
    
    // 请你来实现一个 myAtoi(string s) 函数，使其能将字符串转换成一个 32 位有符号整数。
    func myAtoi(_ s: String) -> Int {
        let str = Array(s)
        var i = 0
        let n = str.count
        // 1. 跳过前面的空格
        while i < n && str[i] == " " {
            i += 1
        }
        // 2. 确定符号
        var sign = 1
        if i < n {
            if str[i] == "-" {
                sign = -1
                i += 1
            } else if str[i] == "+" {
                i += 1
            }
        }
        // 3. 读取数字
        var num = 0
        while i < n, let d = str[i].wholeNumberValue {
            num = num * 10 + d
            // 4. 检查溢出
            if sign == 1 && num >= Int32.max {
                return Int(Int32.max)
            }
            if sign == -1 && (sign * num) <= Int32.min {
                return Int(Int32.min)
            }
            i += 1
        }
        return sign * num
    }
    
    // 给你一个整数 x ，如果 x 是一个回文整数，返回 true ；否则，返回 false 。
    func isPalindrome(_ x: Int) -> Bool {
        var res = 0
        var temp = x;
        while temp > 0 {
            res = res * 10 + temp % 10;
            temp /= 10
        }
        return res == x
    }
    
    // 给你一个字符串 s 和一个字符规律 p，请你来实现一个支持 '.' 和 '*' 的正则表达式匹配。'.' 匹配任意单个字符，'*' 匹配零个或多个前面的那一个元素
    func isMatch(_ s: String, _ p: String) -> Bool {
        // 为了方便下标访问，将字符串转换为字符数组
        let sArr = Array(s)
        let pArr = Array(p)
        // 定义递归辅助函数
        func match(_ si: Int, _ pi: Int) -> Bool {
            // 如果模式字符串已经用完，看主串是否也用完
            if pi == pArr.count {
                return si == sArr.count
            }
            // 判断当前字符是否匹配：
            // 1. si 不能越界
            // 2. 模式字符等于字符串字符或为'.'
            let currMatch = (si < sArr.count) && (pArr[pi] == "." || sArr[si] == pArr[pi])
            // 判断模式串下一个是否为'*'
            if (pi + 1 < pArr.count) && (pArr[pi + 1] == "*") {
                // match(si, pi + 2)：匹配0次，跳过模式中的前一字符加'*'
                // (currMatch && match(si + 1, pi))：匹配1次或多次，当前匹配，则让字符串向后移动一位，但模式不动，继续尝试匹配当前模式（用'*'再匹配一次）
                return match(si, pi + 2) || (currMatch && match(si + 1, pi))
            } else {
                // 若不是'*'，那就一步一步地比较当前字符，然后递归到下一个
                return currMatch && match(si + 1, pi + 1)
            }
        }
        // 从头开始匹配
        return match(0, 0)
    }
}
