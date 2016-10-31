//
//  ViewController.swift
//  ParticleEffectDemo
//
//  Created by ClavisJ on 2016/10/13.
//  Copyright © 2016年 JJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let maxShowRedPacketNumber = 4 // 当前一次性最多显示的红包个数
    let maxPointY: CGFloat = 350.0
    let minCellMargin: CGFloat = 70.0
    var currentRedPacketNumber = 0
    var serialQueueArray : Array<DispatchQueue> = [] // 串行队列数组
    var queueTaskNumber : Array<Int> = []
    var queueStateArray: Array<Bool> = [] // 每个红包队列当前状态  false 当前无任务 true 当前正在显示红包
    var waitTaskArray: Array<String> = [] // 待完成任务队列
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
    }
    
    func setupData() {
        for count in 1...maxShowRedPacketNumber {
            let queueLabel = "queue" + String(count)
            serialQueueArray.append(DispatchQueue.init(label: queueLabel))
            queueTaskNumber.append(0)
            queueStateArray.append(false)
        }
    }
    
    func getQueueIndex() -> Int? {
        let min = queueTaskNumber.min()!
        
        if min > 0 {
            return nil
        }
        
        for (index, item) in queueTaskNumber.enumerated() {
            if min == item {
                return index
            }
        }
        return 0
    }
    
    func handleTask() {
        if self.waitTaskArray.first == nil {
            //print("task finish")
            return
        }
        
        let name =  self.waitTaskArray.first!
        
        let index = self.getQueueIndex()
        
        if index == nil {
            return
        }
        
        self.sendRedPacket(index: index!, name: name)
        self.waitTaskArray.removeFirst()
    }
    
    func sendRedPacket(index: Int, name: String) {
        
        let amount: CGFloat = CGFloat(arc4random() % 10000) / 100.00
        let pointY = maxPointY - CGFloat(index) * minCellMargin
        
        let beforeNumber = queueTaskNumber[index]
        queueTaskNumber[index] = beforeNumber + 1
        
        let redPacketBox = RedPacketBoxView.init(name: name, amount: amount, pointY: pointY, number: index) { (index) in
            let beforeNumber = self.queueTaskNumber[index]
            self.queueTaskNumber[index] = beforeNumber - 1
            self.handleTask()
        }
        self.view.addSubview(redPacketBox)
        redPacketBox.appearAnimation()
    }
    
    @IBAction func sendButtonTap(_ sender: AnyObject) {
        
        let index = self.getQueueIndex()
        currentRedPacketNumber += 1
        
        // logic 2
        
        
        if index == nil {
            // 添加任务到待完成中
            self.waitTaskArray.append(String(currentRedPacketNumber))
            return
        }
        
        self.sendRedPacket(index: index!, name: String(currentRedPacketNumber))
    }

    func snowEffect() {
        // 粒子发射器
        let snowEmitter = CAEmitterLayer.init()
        // 粒子发射的位置
        snowEmitter.emitterPosition = CGPoint.init(x: self.view.bounds.size.width/2.0, y: self.view.bounds.size.height/2.0)
        // 发射源大小
        snowEmitter.emitterSize = CGSize.init(width: 0, height:0)
        // 发射模式
        snowEmitter.emitterMode = kCAEmitterLayerOutline
        // 发射源的形状
        snowEmitter.emitterShape = kCAEmitterLayerRectangle
        
        snowEmitter.renderMode = kCAEmitterLayerAdditive
        
        // 创建雪花粒子
        let snowflake = CAEmitterCell.init()
        // 粒子的名字
        snowflake.name = "snow"
        // 粒子参数的速度乘数因子 越大出现的越快
        snowflake.birthRate = 3.0
        // 存活时间
        snowflake.lifetime = 3.0
        snowflake.lifetimeRange = 1.0
        // 粒子速度
        snowflake.velocity = 300
        // 粒子速度范围
        snowflake.velocityRange = 5
        
        // 粒子的发射方向
        snowflake.emissionLatitude = CGFloat(90.0 * M_PI / 180.0)
        
        // 粒子y方向加速度分量
        snowflake.yAcceleration = 2
        // 周围发射角度

        
        snowflake.emissionRange = CGFloat(0.5 * M_PI)
        // snowflake.emissionRange = 0
        // 子旋转角度范围
        snowflake.spinRange = 0
        // 粒子图片
        snowflake.contents = UIImage.init(named: "star-full")?.cgImage
        // 粒子颜色
        snowflake.color = UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        
        snowflake.redRange = 1
        snowflake.blueRange = 1
        snowflake.greenRange = 1
        
        snowflake.redSpeed = -0.1
        snowflake.blueSpeed = -0.2
        snowflake.greenSpeed = -0.3
        
        snowflake.alphaSpeed = -0.1
        snowflake.alphaRange = 2
        
        // 设置阴影
        snowEmitter.shadowOpacity = 1.0
        snowEmitter.shadowRadius  = 0.0
        snowEmitter.shadowOffset  = CGSize.init(width: 0.0, height: 1.0)
        snowEmitter.shadowColor   = UIColor.white.cgColor
        
        // 将粒子添加到发射器
        snowEmitter.emitterCells = [snowflake]
        self.view.layer.insertSublayer(snowEmitter, at: 0)
    }
    
 
    func starEffect() {
        // 粒子发射器
        let snowEmitter = CAEmitterLayer.init()
        // 粒子发射的位置
        snowEmitter.emitterPosition = CGPoint.init(x: self.view.bounds.size.width/2.0, y: self.view.bounds.size.height/2.0)
        // 发射源大小
        snowEmitter.emitterSize = CGSize.init(width: 0, height:0)
        // 发射模式
        snowEmitter.emitterMode = kCAEmitterLayerOutline
        // 发射源的形状
        snowEmitter.emitterShape = kCAEmitterLayerRectangle
        
        snowEmitter.renderMode = kCAEmitterLayerAdditive
        
        snowEmitter.seed = (arc4random()%100)+1
        
        
//        CAEmitterCell* rocket  = [CAEmitterCell emitterCell];
//        rocket.birthRate = 1.0; //是每秒某个点产生的effectCell数量
//        rocket.emissionRange = 0.25 * M_PI; // 周围发射角度
//        rocket.velocity = 400; // 速度
//        rocket.velocityRange = 100; // 速度范围
//        rocket.yAcceleration = 75; // 粒子y方向的加速度分量
//        rocket.lifetime = 1.02;
        
        // 创建雪花粒子
        let snowflake = CAEmitterCell.init()
        // 粒子的名字
        snowflake.name = "snow"
        // 粒子参数的速度乘数因子 越大出现的越快
        snowflake.birthRate = 6.0
        // 存活时间
        snowflake.lifetime = 0.6
        snowflake.lifetimeRange = 0.1
        // 粒子速度
        snowflake.velocity = 170
        // 粒子速度范围
        snowflake.velocityRange = 5
        
        // 粒子的发射方向
        snowflake.emissionRange = CGFloat(0.1 * M_PI)
        // 发射角的维度方向 感觉没啥用
        // snowflake.emissionLatitude = CGFloat(0.1 * M_PI)
        // 发射角的纵向方向
        snowflake.emissionLongitude = CGFloat(0.5 * M_PI)
        
        // 粒子y方向加速度分量
        snowflake.yAcceleration = 2
        
        // 子旋转角度范围
        snowflake.spinRange = 0
        // 粒子图片
        snowflake.contents = UIImage.init(named: "star-full")?.cgImage
        // 粒子颜色
        snowflake.color = UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        
        snowflake.redRange = 1
        snowflake.blueRange = 1
        snowflake.greenRange = 1
        
        snowflake.redSpeed = -0.1
        snowflake.blueSpeed = -0.2
        snowflake.greenSpeed = -0.3
        
        snowflake.alphaSpeed = -0.5
        snowflake.alphaRange = 1
        
        // 设置阴影
        snowEmitter.shadowOpacity = 1.0
        snowEmitter.shadowRadius  = 0.0
        snowEmitter.shadowOffset  = CGSize.init(width: 0.0, height: 1.0)
        snowEmitter.shadowColor   = UIColor.white.cgColor
        
        // 将粒子添加到发射器
        snowEmitter.emitterCells = [snowflake]
        self.view.layer.insertSublayer(snowEmitter, at: 0)
    }
    

}

