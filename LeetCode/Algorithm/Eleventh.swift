//
//  Eleventh.swift
//  LeetCode
//
//  Created by 叶修 on 2025/9/9.
//

import Foundation

// 树的遍历和构建
// 最小公共祖先
// 链表有环
// LRU 缓存

class Eleventh {
    init() {
        let root = TreeNode(3)
        root.left = TreeNode(9)
        root.right = TreeNode(20)
        root.right?.left = TreeNode(15)
        root.right?.right = TreeNode(7)
        print("102. 二叉树的层序遍历: \(levelOrder(root))")
        print("104. 二叉树的最大深度:\(maxDepth(root))")
        print("105. 从前序与中序遍历序列构造二叉树:\(preorderTraversal(buildTree([3,9,20,15,7], [9,3,15,20,7])))")
        print("106. 从中序与后序遍历序列构造二叉树:\(preorderTraversal(buildTreeOptimized([9,3,15,20,7], [9,15,7,20,3])))")
        print("144. 二叉树的前序遍历: \(preorderTraversalStack(root))")
        print("145. 二叉树的后序遍历: \(postorderTraversalIterative(root))")
        print("146. LRU 缓存: \(cache())")
        print("198. 打家劫舍:\(rob([1,2,3,1]))")
        print("225. 用队列实现栈:")
        print("232. 用栈实现队列:")
        print("236. 二叉树的最近公共祖先:")
    }
    
    /*
     给你二叉树的根节点 root ，返回其节点值的 层序遍历 。 （即逐层地，从左到右访问所有节点）。
     层序遍历（Level Order Traversal）是一种广度优先搜索（BFS）的遍历方式，它按照树的层级从上到下、从左到右依次访问每个节点。
     
     */
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        // 如果根节点为空，返回空数组
        guard let root = root else { return [] }
        
        var result: [[Int]] = []
        var queue: [TreeNode] = [root]  // 使用队列存储当前层的节点
        
        while !queue.isEmpty {
            let levelSize = queue.count  // 当前层的节点数量
            var currentLevel: [Int] = []  // 存储当前层的值
            // 遍历当前层的所有节点
            for _ in 0..<levelSize {
                let node = queue.removeFirst()  // 取出队列第一个节点
                currentLevel.append(node.val)   // 将节点值加入当前层
                // 将子节点加入队列（下一层）
                if let left = node.left {
                    queue.append(left)
                }
                if let right = node.right {
                    queue.append(right)
                }
            }
            result.append(currentLevel)  // 将当前层加入结果
        }
        
        return result
    }
    
    func maxDepth(_ root: TreeNode?) -> Int {
        // 基础情况：空节点深度为0
        guard let root = root else { return 0 }
        
        // 递归计算左右子树的最大深度
        let leftDepth = maxDepth(root.left)
        let rightDepth = maxDepth(root.right)
        
        // 当前节点深度 = 1 + 左右子树的最大深度
        return 1 + max(leftDepth, rightDepth)
    }
    
    // 迭代（深度优先搜索）
    func maxDepthStack(_ root: TreeNode?) -> Int {
        guard let root = root else { return 0 }
        
        var stack: [(TreeNode, Int)] = [(root, 1)]  // (节点, 当前深度)
        var maxDepth = 0
        
        while !stack.isEmpty {
            let (node, currentDepth) = stack.removeLast()
            maxDepth = max(maxDepth, currentDepth)
            
            // 将子节点加入栈，深度+1
            if let right = node.right {
                stack.append((right, currentDepth + 1))
            }
            if let left = node.left {
                stack.append((left, currentDepth + 1))
            }
        }
        
        return maxDepth
    }
    
    /*
     关键理解点：
     前序遍历确定根节点：每次取前序遍历的第一个元素作为当前子树的根
     中序遍历确定子树范围：根据根节点在中序遍历中的位置，分割左右子树
     递归构造：对左右子树分别递归执行相同过程
     
     buildTree(0, 4)
     ├── preIndex=0, rootVal=3, rootIndex=1
     ├── buildTree(0, 0)  // 左子树
     │   ├── preIndex=1, rootVal=9, rootIndex=0
     │   ├── buildTree(0, -1) → nil
     │   └── buildTree(1, 0) → nil
     └── buildTree(2, 4)  // 右子树
         ├── preIndex=2, rootVal=20, rootIndex=3
         ├── buildTree(2, 2)  // 左子树
         │   ├── preIndex=3, rootVal=15, rootIndex=2
         │   ├── buildTree(2, 1) → nil
         │   └── buildTree(3, 2) → nil
         └── buildTree(4, 4)  // 右子树
             ├── preIndex=4, rootVal=7, rootIndex=4
             ├── buildTree(4, 3) → nil
             └── buildTree(5, 4) → nil
          
     给定两个整数数组 preorder 和 inorder ，其中 preorder 是二叉树的先序遍历， inorder 是同一棵树的中序遍历，请构造二叉树并返回其根节点。
     */
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        guard !preorder.isEmpty else { return nil }
        
        // 创建中序遍历的索引映射
        var inorderIndexMap: [Int: Int] = [:]
        for (i, val) in inorder.enumerated() {
            inorderIndexMap[val] = i
        }
        
        var preIndex = 0  // 前序遍历的当前索引
        
        func build(_ inStart: Int, _ inEnd: Int) -> TreeNode? {
            // 如果中序遍历范围无效，返回nil
            if inStart > inEnd { return nil }
            
            // 创建根节点（前序遍历的下一个元素）
            let rootVal = preorder[preIndex]
            let root = TreeNode(rootVal)
            preIndex += 1  // 移动到下一个前序遍历元素
            
            // 在中序遍历中找到根节点位置
            let rootIndex = inorderIndexMap[rootVal]!
            
            // 先构造左子树，再构造右子树
            root.left = build(inStart, rootIndex - 1)
            root.right = build(rootIndex + 1, inEnd)
            
            return root
        }
        return build(0, inorder.count - 1)
    }
    
    /*
     给定两个整数数组 inorder 和 postorder ，其中 inorder 是二叉树的中序遍历， postorder 是同一棵树的后序遍历，请你构造并返回这颗 二叉树 。
     */
    func buildTreeOptimized(_ inorder: [Int], _ postorder: [Int]) -> TreeNode? {
        guard !inorder.isEmpty else { return nil }
        
        // 创建中序遍历的索引映射
        var inorderIndexMap: [Int: Int] = [:]
        for (i, val) in inorder.enumerated() {
            inorderIndexMap[val] = i
        }
        
        var postIndex = postorder.count - 1  // 后序遍历的当前索引（从后往前）
        
        func build(_ inStart: Int, _ inEnd: Int) -> TreeNode? {
            // 如果中序遍历范围无效，返回nil
            if inStart > inEnd { return nil }
            
            // 创建根节点（后序遍历的下一个元素）
            let rootVal = postorder[postIndex]
            let root = TreeNode(rootVal)
            postIndex -= 1  // 移动到前一个后序遍历元素
            
            // 在中序遍历中找到根节点位置
            let rootIndex = inorderIndexMap[rootVal]!
            
            // 先构造右子树，再构造左子树（注意顺序！）
            root.right = build(rootIndex + 1, inEnd)
            root.left = build(inStart, rootIndex - 1)
            
            return root
        }
        
        return build(0, inorder.count - 1)
    }
    
    /*
     前序遍历：根节点 → 左子树 → 右子树
     栈实现
     给你二叉树的根节点 root ，返回它节点值的 前序遍历。
     */
    func preorderTraversalStack(_ root: TreeNode?) -> [Int] {
        guard let root = root else { return [] }
        
        var result: [Int] = []
        var stack: [TreeNode] = []
        var current: TreeNode? = root
        
        while current != nil || !stack.isEmpty {
            // 一直向左走，边走边访问
            while current != nil {
                result.append(current!.val)  // 访问根节点
                stack.append(current!)        // 压入栈中
                current = current?.left       // 转向左子树
            }
            // 左子树访问完毕，转向右子树
            current = stack.removeLast()
            current = current?.right
        }
        
        return result
    }
    
    /*
     栈法
     后续遍历：左子树 -> 右子树 -> 根节点
     
     给你一棵二叉树的根节点 root ，返回其节点值的 后序遍历 。
     */
    func postorderTraversalIterative(_ root: TreeNode?) -> [Int] {
        guard let root = root else { return [] }
        
        var result: [Int] = []
        var stack: [TreeNode] = [root]
        
        while !stack.isEmpty {
            let node = stack.removeLast()
            result.insert(node.val, at: 0)  // 在结果数组开头插入
            
            // 先压入左子树，再压入右子树
            // 因为我们要在结果开头插入，所以顺序相反
            if let left = node.left {
                stack.append(left)
            }
            if let right = node.right {
                stack.append(right)
            }
        }
        return result
    }
    
    func cache() -> [Int] {
        // 简化版本 - 使用数组实现
        class LRUCache {
            private var capacity: Int
            private var cache: [(key: Int, value: Int)] = []
            
            init(_ capacity: Int) {
                self.capacity = capacity
            }
            
            func get(_ key: Int) -> Int {
                // 查找key对应的值
                for (index, item) in cache.enumerated() {
                    if item.key == key {
                        // 找到后移到数组末尾（最近使用）
                        let value = item.value
                        cache.remove(at: index)
                        cache.append((key: key, value: value))
                        return value
                    }
                }
                return -1
            }
            
            func put(_ key: Int, _ value: Int) {
                // 检查key是否已存在
                for (index, item) in cache.enumerated() {
                    if item.key == key {
                        // 更新已存在的key
                        cache.remove(at: index)
                        cache.append((key: key, value: value))
                        return
                    }
                }
                
                // 添加新的key-value
                if cache.count >= capacity {
                    // 删除最久未使用的元素（数组第一个）
                    cache.removeFirst()
                }
                cache.append((key: key, value: value))
            }
            
            func objects() -> [Int] {
                return cache.map { key, value in
                    value
                }
            }
        }
        
        let lru = LRUCache(2)
        lru.put(1, 1)
        lru.put(2, 2)
        lru.put(3, 3)
        return lru.objects()
    }
        
    /*
     你是一个专业的小偷，计划偷窃沿街的房屋。每间房内都藏有一定的现金，影响你偷窃的唯一制约因素就是相邻的房屋装有相互连通的防盗系统，如果两间相邻的房屋在同一晚上被小偷闯入，系统会自动报警。
     给定一个代表每个房屋存放金额的非负整数数组，计算你 不触动警报装置的情况下 ，一夜之内能够偷窃到的最高金额。
     */
    func rob(_ nums: [Int]) -> Int {
        guard !nums.isEmpty else { return 0 }
        guard nums.count > 1 else { return nums[0] }
        
        // dp[i] 表示偷窃到第i个房屋时能获得的最大金额
        var dp = Array(repeating: 0, count: nums.count)
        
        // 初始化
        dp[0] = nums[0]
        dp[1] = max(nums[0], nums[1])
        
        // 状态转移
        for i in 2..<nums.count {
            // 选择：偷当前房屋 + 前前个房屋的最大金额
            // 或者：不偷当前房屋，保持前一个房屋的最大金额
            dp[i] = max(dp[i-1], dp[i-2] + nums[i])
        }
        
        return dp[nums.count - 1]
    }
    
    func stack() {
        // 用队列实现栈
        class MyStack {
            private var queue1: [Int] = []
            private var queue2: [Int] = []
            
            init() {}
            
            func push(_ x: Int) {
                // 将新元素加入非空队列
                if !queue1.isEmpty {
                    queue1.append(x)
                } else {
                    queue2.append(x)
                }
            }
            
            func pop() -> Int {
                // 将非空队列的元素（除最后一个）移到空队列
                if !queue1.isEmpty {
                    while queue1.count > 1 {
                        queue2.append(queue1.removeFirst())
                    }
                    return queue1.removeFirst()
                } else {
                    while queue2.count > 1 {
                        queue1.append(queue2.removeFirst())
                    }
                    return queue2.removeFirst()
                }
            }
            
            func top() -> Int {
                // 获取栈顶元素（最后一个元素）
                if !queue1.isEmpty {
                    return queue1.last!
                } else {
                    return queue2.last!
                }
            }
            
            func empty() -> Bool {
                return queue1.isEmpty && queue2.isEmpty
            }
        }
    }
    
    func queue() {
        // 延迟移动版本 - 只在需要时才移动元素
        class MyQueueLazy {
            private var inputStack: [Int] = []
            private var outputStack: [Int] = []
            
            init() {}
            
            func push(_ x: Int) {
                inputStack.append(x)
            }
            
            func pop() -> Int {
                // 确保输出栈有元素
                ensureOutputStack()
                return outputStack.removeLast()
            }
            
            func peek() -> Int {
                // 确保输出栈有元素
                ensureOutputStack()
                return outputStack.last!
            }
            
            func empty() -> Bool {
                return inputStack.isEmpty && outputStack.isEmpty
            }
            
            // 辅助函数：确保输出栈有元素
            private func ensureOutputStack() {
                if outputStack.isEmpty {
                    while !inputStack.isEmpty {
                        outputStack.append(inputStack.removeLast())
                    }
                }
            }
        }
    }
    
    /*
     给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。
     */
    func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        guard let root = root, let p = p, let q = q else { return nil }
        
        // 如果当前节点是p或q，直接返回
        if root === p || root === q {
            return root
        }
        
        // 递归查找左右子树
        let left = lowestCommonAncestor(root.left, p, q)
        let right = lowestCommonAncestor(root.right, p, q)
        
        // 如果左右子树都找到了，说明当前节点是LCA
        if left != nil && right != nil {
            return root
        }
        
        // 如果只有一边找到了，返回找到的那一边
        return left != nil ? left : right
    }

}
