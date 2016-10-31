//
//  RedPacketBoxView.swift
//  ParticleEffectDemo
//
//  Created by ClavisJ on 2016/10/14.
//  Copyright © 2016年 JJ. All rights reserved.
//

import UIKit

class RedPacketBoxView: UIView {
    
    // 粒子发射器
    let snowEmitter = CAEmitterLayer.init()
    let grayGradientView = UIView.init()
    let redPacketView = UIImageView.init(image: UIImage.init(named: "red_packet"))
    var name: String = ""
    var amount: CGFloat = 0
    var overMax: Bool = false
    var queueNumber = 0
    
    // 动画完成闭包
    var completeClosure = { (index: Int) -> Void in
        
    }
    
    convenience init(name: String, amount: CGFloat, pointY: CGFloat, number: Int, completeClosure: @escaping (Int) -> Void) {
        self.init(frame: CGRect.init(x: -230, y: pointY, width: 220, height: 58))
        self.name = name
        self.amount = amount
        self.queueNumber = number
        self.completeClosure = completeClosure
        self.setupUI()
        self.appearAnimation()
    }
    
    func setupUI() {
        grayGradientView.frame = CGRect.init(x: 0, y: self.frame.height - 35, width: 160, height: 35)
        // 渐变背景
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = grayGradientView.bounds
        gradientLayer.colors = [UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.4).cgColor, UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0).cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0.5)
        grayGradientView.layer.addSublayer(gradientLayer)
        // 左圆右方的遮罩
        let filletShape = CAShapeLayer.init()
        let shape = UIBezierPath.init(roundedRect: gradientLayer.bounds, cornerRadius: 35/2.0)
        shape.append(UIBezierPath.init(rect: CGRect.init(x: 160-35, y: 0, width: 35, height: 35)))
        filletShape.path = shape.cgPath
        grayGradientView.layer.mask = filletShape
        self.addSubview(grayGradientView)
        
        let headImageview = UIImageView.init(image: UIImage.init(named: "head"))
        headImageview.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        headImageview.layer.cornerRadius = 35/2.0
        headImageview.clipsToBounds = true
        grayGradientView.addSubview(headImageview)
        
        let nameLabel = UILabel.init(frame: CGRect.init(x: 40, y: 0, width: 120, height: 17))
        nameLabel.text = name
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        grayGradientView.addSubview(nameLabel)
        
        let amountLabel = UILabel.init(frame: CGRect.init(x: 40, y: 17, width: 120, height: 17))
        amountLabel.text = "送了"+String(describing: amount)+"元红包"
        amountLabel.textColor = UIColor.white
        amountLabel.font = UIFont.systemFont(ofSize: 12)
        grayGradientView.addSubview(amountLabel)
        
        // 红包
        redPacketView.contentMode = .scaleAspectFit
        redPacketView.frame = CGRect.init(x: 150, y: 0, width: 50, height: 50)
        self.addSubview(redPacketView)
    }
    
    func appearAnimation() {
        redPacketView.alpha = 0
        grayGradientView.alpha = 1
        self.frame =  CGRect.init(x: -230, y: self.frame.origin.y, width: 220, height: 58)
        self.redPacketView.frame = CGRect.init(x: 100, y: 0, width: 50, height: 50)
        snowEmitter.removeFromSuperlayer()
        grayGradientView.frame = CGRect.init(x: 0, y: self.frame.height - 35, width: 160, height: 35)
        
        // dampingRatio：阻尼系数，范围为 0.0 ~ 1.0，数值越小，弹簧振动的越厉害，Spring 的效果越明显
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.frame = CGRect.init(x: 20, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
            }) { (bool) in
        
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
            self.redPacketView.alpha = 1
            }) { (bool) in
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.redPacketView.frame = CGRect.init(x: 150, y: 0, width: 50, height: 50)
        }) { (bool) in
            self.starEmitterEffect()
        }
    }

    
    func starEmitterEffect() {
        
        self.layer.insertSublayer(snowEmitter, at: 0)
        
        // 粒子发射的位置
        snowEmitter.emitterPosition = CGPoint.init(x: redPacketView.frame.origin.x + redPacketView.frame.size.width - 15, y: redPacketView.frame.origin.y + 20)
        // 发射源大小
        snowEmitter.emitterSize = CGSize.init(width: 8, height:8)
        // 发射模式
        snowEmitter.emitterMode = kCAEmitterLayerPoints
        // 发射源的形状
        snowEmitter.emitterShape = kCAEmitterLayerRectangle
        
        snowEmitter.renderMode = kCAEmitterLayerAdditive
        
        //snowEmitter.seed = (arc4random() % 100) + 1
        
        // 创建雪花粒子
        let snowflake = CAEmitterCell.init()
        // 粒子的名字
        snowflake.name = "snow"
        // 粒子参数的速度乘数因子 越大出现的越快
        snowflake.birthRate = 1
        
        // 存活时间
        snowflake.lifetime = 0.6
        snowflake.lifetimeRange = 0.2
        // 粒子速度
        snowflake.velocity = 70
        // 粒子速度范围
        snowflake.velocityRange = 30
        
        // 粒子的发射方向
        snowflake.emissionRange = CGFloat(0.2 * M_PI)
        // 发射角的纵向方向
        snowflake.emissionLongitude = -CGFloat(0.5 * M_PI)
        
        // 粒子y方向加速度分量
        //snowflake.yAcceleration = 2
        
        // 子旋转角度范围
        snowflake.spinRange = 0
        // 粒子图片 star-full
        snowflake.contents = UIImage.init(named: "diamond")?.cgImage
        snowflake.contentsScale = 2
        
        snowflake.alphaSpeed = -0.5
        snowflake.alphaRange = 1
        
        // 设置阴影
        snowEmitter.shadowOpacity = 1.0
        snowEmitter.shadowRadius  = 0.0
        snowEmitter.shadowOffset  = CGSize.init(width: 0.0, height: 1.0)
        snowEmitter.shadowColor   = UIColor.white.cgColor
        
        // 将粒子添加到发射器
        snowEmitter.emitterCells = [snowflake]
        
        
        self.perform(#selector(RedPacketBoxView.changeBirthRate), with: nil, afterDelay: 0)
        
//        // 设置粒子出现速度 先慢后快
//        UIView.animate(withDuration: 0.3, animations: { 
//            self.snowEmitter.birthRate = 10.0
//            }) { (_) in
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.snowEmitter.birthRate = 0
//                    }, completion: { (_) in
//                        self.disappearAnimation()
//                })
//        }
    }
    
    func changeBirthRate() {
        
        if snowEmitter.birthRate > 10 {
            overMax = true
        }
        
        // 如果超出最大值 就递减
        if overMax {
            snowEmitter.birthRate -= 1
            if snowEmitter.birthRate < 0 {
                snowEmitter.birthRate = 0
                // 退场动画
                overMax = false
                self.perform(#selector(RedPacketBoxView.disappearAnimation), with: nil, afterDelay: 0.5)
            } else {
                self.perform(#selector(RedPacketBoxView.changeBirthRate), with: nil, afterDelay: 0.1)
            }
        }
        // 没超出之前就递增
        else {
            snowEmitter.birthRate += 1
            self.perform(#selector(RedPacketBoxView.changeBirthRate), with: nil, afterDelay: 0.05)
        }
    }
    
    func disappearAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseIn, animations: {
            self.redPacketView.center = CGPoint.init(x: self.redPacketView.center.x, y: self.redPacketView.center.y - 50)
            self.redPacketView.alpha = 0
            }) { (_) in
                
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.6, options: .curveEaseIn, animations: {
            self.grayGradientView.center = CGPoint.init(x: self.grayGradientView.center.x, y: self.grayGradientView.center.y - 50)
            self.grayGradientView.alpha = 0
        }) { (_) in
            
            // 动画完成闭包
            self.completeClosure(self.queueNumber)
        }
    }
}
