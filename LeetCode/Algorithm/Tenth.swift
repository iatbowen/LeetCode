//
//  Tenth.swift
//  LeetCode
//
//  Created by 叶修 on 2025/8/25.
//

import Foundation

class Tenth {
    
    init() {
        let ln1 = ListNode(2)
        ln1.next = ListNode(3)
        ln1.next?.next = ListNode(4)
        ln1.next?.next?.next = ListNode(5)
        ln1.next?.next?.next?.next = ListNode(6)
        print("92. 反转链表 II:\(String(describing: reverseBetween(ln1, 2, 4)?.print()))")
        print("93. 复原 IP 地址:\(restoreIpAddresses("101023"))")
        let root = TreeNode(2)
        let tree1 = TreeNode(1)
        let tree2 = TreeNode(4)
        let tree4 = TreeNode(3)
        let tree5 = TreeNode(5)
        root.left = tree1
        root.right = tree2
        tree2.left = tree4
        tree2.right = tree5
        print("94. 二叉树的中序遍历:\(inorderTraversal1(root))")
        print("94. 二叉树的中序遍历:\(inorderTraversal2(root))")
        print("95. 不同的二叉搜索树 II:\(generateTrees(3))")
        print("96. 不同的二叉搜索树:\(numTrees(3))")
        print("97. 交错字符串:\(isInterleave("aabcc", "dbbca", "aadbbcbcac"))")
        print("98. 验证二叉搜索树:\(isValidBST(root))")
        print("100. 相同的树:\(isSameTree(nil, nil))")
    }
    
    // 给你单链表的头指针 head 和两个整数 left 和 right ，其中 left <= right 。请你反转从位置 left 到位置 right 的链表节点，返回 反转后的链表 。
    func reverseBetween(_ head: ListNode?, _ left: Int, _ right: Int) -> ListNode? {
        let pHead: ListNode? = ListNode(0, head)
        var pre = pHead
        var index = 0
        while index < left - 1 {
            pre = pre?.next
            index += 1
        }
        let current = pre?.next
        var next: ListNode?
        index = 0
        while index < right - left {
            next = current?.next
            current?.next = next?.next
            next?.next = pre?.next
            pre?.next = next
            index += 1
        }
        return pHead?.next
    }
    
    // 有效 IP 地址 正好由四个整数（每个整数位于 0 到 255 之间组成，且不能含有前导 0），整数之间用 '.' 分隔。
    // https://leetcode.cn/problems/restore-ip-addresses/solutions/1/hui-su-suan-fa-hua-tu-fen-xi-jian-zhi-tiao-jian-by/
    func restoreIpAddresses(_ s: String) -> [String] {
        var res = [String]()
        let sArr = Array(s)
        func dfs(_ idx: Int, _ path: [String]) {
            print(path)
            // 已经分成4段并且用完所有字符
            if path.count == 4 && idx == sArr.count {
                res.append(path.joined(separator: "."))
                return
            }
            // 剩余段数不够/多直接返回
            if path.count >= 4 { return }
            // 每段最大长度
            for len in 1...3 {
                if idx + len > sArr.count { break }
                let segment = String(sArr[idx..<(idx+len)])
                // 首位不能为0，除非单独一个"0"，且数字要 ≤ 255
                if (segment.count > 1 && segment.first == "0") || (Int(segment)! > 255) {
                    continue
                }
                dfs(idx+len, path + [segment])
            }
        }
        dfs(0, [])
        return res
    }
    
    // 左子树 → 根节点 → 右子树
    func inorderTraversal1(_ root: TreeNode?) -> [Int] {
        var result = [Int]()
        func inorder(_ node: TreeNode?) {
            guard let node = node else { return }
            inorder(node.left)          // 访问左子树
            result.append(node.val)     // 访问当前节点
            inorder(node.right)         // 访问右子树
        }
        inorder(root)
        return result
    }
    
    func inorderTraversal2(_ root: TreeNode?) -> [Int] {
        var result = [Int]()
        var stack = [TreeNode]()
        var curr = root
        while curr != nil || !stack.isEmpty {
            // 把左一路入栈
            while let node = curr {
                stack.append(node)
                curr = node.left
            }
            // 出栈访问节点
            let node = stack.removeLast()
            result.append(node.val)
            curr = node.right   // 访问右子树
        }
        return result
    }
    
    /*
     二叉搜索树是一种特殊的二叉树，满足如下性质：
     - 每个节点最多有两个子树：左子树和右子树。
     - 对于任意节点：
        - 它的左子树上所有节点的值都小于当前节点的值。
        - 它的右子树上所有节点的值都大于当前节点的值。
        - 左子树和右子树本身也是二叉搜索树。
     给你一个整数 n ，请你生成并返回所有由 n 个节点组成且节点值从 1 到 n 互不相同的不同 二叉搜索树 。可以按 任意顺序 返回答案。
     */
    func generateTrees(_ n: Int) -> [TreeNode?] {
        if n == 0 {
            return []
        }
        func generateTrees(from start: Int, to end: Int) -> [TreeNode?] {
            if start > end {
                return [nil]  // 返回包含一个nil的数组，表示空树
            }
            
            var allTrees = [TreeNode?]()
            
            // 以每个i作为根节点
            for i in start...end {
                // 生成所有可能的左子树
                let leftTrees = generateTrees(from: start, to: i - 1)
                // 生成所有可能的右子树
                let rightTrees = generateTrees(from: i + 1, to: end)
                
                // 组合左右子树到当前根节点
                for left in leftTrees {
                    for right in rightTrees {
                        let root = TreeNode(i)
                        root.left = left
                        root.right = right
                        allTrees.append(root)
                    }
                }
            }
            
            return allTrees
        }
        return generateTrees(from: 1, to: n)
    }
    
    // 给你一个整数 n ，求恰由 n 个节点组成且节点值从 1 到 n 互不相同的 二叉搜索树 有多少种？返回满足题意的二叉搜索树的种数。
    func numTrees(_ n: Int) -> Int {
        // dp[i]表示有i个节点的BST个数
        var dp = [Int](repeating: 0, count: n+1)
        dp[0] = 1
        dp[1] = 1
        if n <= 1 { return 1 }
        for i in 2...n {
            // 每个以j为根的组合数：左子树j-1个，右子树i-j个
            for j in 1...i {
                dp[i] += dp[j-1] * dp[i-j]
            }
        }
        return dp[n]
    }
    
    // 给定三个字符串 s1、s2、s3，请你帮忙验证 s3 是否是由 s1 和 s2 交错 组成的。
    func isInterleave(_ s1: String, _ s2: String, _ s3: String) -> Bool {
        let m = s1.count, n = s2.count
        if m + n != s3.count { return false }
        let s1 = Array(s1), s2 = Array(s2), s3 = Array(s3)
        // dp[i][j]: s1前i, s2前j, 能否组成s3前i+j
        var dp = Array(repeating: Array(repeating: false, count: n+1), count: m+1)
        dp[0][0] = true
        for i in 0...m {
            for j in 0...n {
                if i > 0 {
                    dp[i][j] = dp[i][j] || (dp[i-1][j] && s1[i-1] == s3[i+j-1])
                }
                if j > 0 {
                    dp[i][j] = dp[i][j] || (dp[i][j-1] && s2[j-1] == s3[i+j-1])
                }
            }
        }
        return dp[m][n]
    }
    
    // 给你一个二叉树的根节点 root ，判断其是否是一个有效的二叉搜索树。
    func isValidBST(_ root: TreeNode?) -> Bool {
        var cur = root
        var stack = [TreeNode]()
        var result = [Int]()
        while(!stack.isEmpty || cur != nil) {
            if cur != nil {
            //当前非空，入栈并继续访问左边
                stack.append(cur!)
                cur = cur?.left
            } else {
                //核心：
                //1. 上一结点的左边已经无结点，则弹出该结点，记录值，开始访问该结点右边
                //2. 1中被弹出结点右侧访问结束，当前栈顶结点左访问同时结束，可以弹出
                result.append(stack.last!.val)
                cur = stack.removeLast().right
            }
        }
        var index = 0
        while(index + 1 < result.count) {
            if result[index] >= result[index + 1] {
                return false
            }
            index += 1
        }
        return true
    }
    
    // 给你两棵二叉树的根节点 p 和 q ，编写一个函数来检验这两棵树是否相同。
    func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
        if p == nil && q == nil { return true }
        if p == nil || q == nil { return false }
        if p!.val != q!.val { return false }
        return isSameTree(p!.left, q!.left) && isSameTree(p!.right, q!.right)
    }
}
