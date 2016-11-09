//
//  ViewController.swift
//  ParticleEffectDemo
//
//  Created by ClavisJ on 2016/10/13.
//  Copyright © 2016年 JJ. All rights reserved.
//

/*
 
 1.计算的时候加锁
 2.atomic 属性
 3.用线程来实现  线程加同步锁
 
*/

import UIKit

class ViewController: UIViewController {

    let maxShowRedPacketNumber = 4 // 当前一次性最多显示的红包个数
    let maxPointY: CGFloat = 350.0
    let minCellMargin: CGFloat = 70.0
    var currentRedPacketNumber = 0
    
    var queueTaskArray : Array<[String]> = [] // 每个队列的任务
    var queueStateArray: Array<Bool> = [] // 每个红包队列当前状态  false 当前无任务 true 当前正在显示红包
    
    let lock = NSRecursiveLock.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
    }
    
    func setupData() {
        for _ in 1...maxShowRedPacketNumber {
            queueTaskArray.append([])
            queueStateArray.append(false)
        }
    }
    
    func getQueueIndex() -> Int {
        
        let queueCountArray = queueTaskArray.map { (array) -> Int in
            return array.count
        }
        
        let min = queueCountArray.min()!
        
        for (index, item) in queueCountArray.enumerated() {
            if min == item {
                return index
            }
        }
        
        return 0
    }
    
    // 加锁  NSRecursiveLock
    func handleTask(index: Int) {
        
        lock.lock()
        
        let specificQueueArray = queueTaskArray[index]
        // 队列当前的count大于1 说明有任务排在前面 就立即执行
        if specificQueueArray.count > 1 {
            return
        }
        
        self.handleNextTask(index: index)
        
        lock.unlock()
    }
    
    
    func handleNextTask(index: Int) {
        let specificQueueArray = queueTaskArray[index]
        
        // 队列没有任务
        if specificQueueArray.count == 0 {
            return
        }
        
        // 当前是否有正在执行的任务
        if queueStateArray[index] {
            return
        }
        
        // 执行任务
        let name =  specificQueueArray.first!
        self.sendRedPacket(index: index, name: name)
        
        // 修改队列当前状态
        queueStateArray[index] = true
    }
    
    func sendRedPacket(index: Int, name: String) {
        
        let amount: CGFloat = CGFloat(arc4random() % 10000) / 100.00
        let pointY = maxPointY - CGFloat(index) * minCellMargin
        
        let redPacketBox = RedPacketBoxView.init(name: name, amount: amount, pointY: pointY, index: index) { (index) in
            
            // 出队列
            var specificQueueArray = self.queueTaskArray[index]
            if specificQueueArray.count != 0 {
                specificQueueArray.removeFirst()
            }
            
            self.queueTaskArray[index] = specificQueueArray
            
            // 改状态
            self.queueStateArray[index] = false
            
            // 执行下个任务
            self.handleNextTask(index: index)
        }
        self.view.addSubview(redPacketBox)
        redPacketBox.appearAnimation()
    }
    
    @IBAction func sendButtonTap(_ sender: AnyObject) {
        // 直接将任务加入队列
        currentRedPacketNumber += 1
        let index = self.getQueueIndex()
        
        var specificQueueArray = queueTaskArray[index]
        specificQueueArray.append(String(currentRedPacketNumber))
        queueTaskArray[index] = specificQueueArray
        
        self.handleTask(index: index)
    }
}

