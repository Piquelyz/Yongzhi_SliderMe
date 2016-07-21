//
//  ViewController.swift
//  Yongzhi_CheapThrills
//
//  Created by Yongzhi on 7/13/16.
//  Copyright © 2016 Yongzhi. All rights reserved.
//
//在onAlert方法中加入 curValue = lroundf(mySlider.value)//加入此句，防止用户在没有改变mySlider值时发生错误

import UIKit

class ViewController: UIViewController {
    
    //目标滑块
    @IBOutlet weak var sliderTarget: UISlider!
    //操作滑块
    @IBOutlet weak var mySlider: UISlider!
    //分数
    @IBOutlet weak var labScore: UILabel!
    //回合数
    @IBOutlet weak var labRound: UILabel!

    //目标数字
    var tarValue:Int = 0
    //拖到的数字
    var curValue:Int = 0
    //总分数
    var score:Int = 0
    //总回合数
    var round:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         NSThread.sleepForTimeInterval(2.0)//延长3秒
        onUpdate()
        onCreateSlider()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //关联value Changed 想应拖动滑块产生的数值变化
    @IBAction func sliderChange(sender: AnyObject) {
        //将mySlider的值从float四舍五入转换成float并赋值给curValue，lroundf方法
        curValue = lroundf(mySlider.value)
    }

    //关联Touch Up Inside 判断第二个与第一个滑块有多接近，给出分数
    @IBAction func onAlert(sender: AnyObject) {
        //后先算出两个slider的差值，如果负数转为整数，再用100减去，就是最终的得分
        curValue = lroundf(mySlider.value)//加入此句，放置用户在没有改变mySlider值时发生错误
        var diff:Int = curValue - tarValue
        if diff < 0 {
            diff *= -1
        }
        let points = 100 - diff
        //计入总分
        score += points
        
        //增加趣味性，依据分数给出不同的Alert
        var message = ""
        switch(points){
        case 100:
            message = "太牛了,闪电侠得了满分"
        case 90..<100:
            message = "厉害,闪电侠的得分是：\(points)"
        case 80..<90:
            message = "闪电侠，您的眼里还差点，得分:\(points)"
        default:
            message = "你瞎吗，才得了\(points)分，快不及格了"
        }
        //警告信息进行弹窗
        let alertController = UIAlertController(title: "Coucou,闪电侠", message: message, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okButton)
        self.presentViewController(alertController, animated: true, completion: nil)
        onUpdate()
    }

    //关联Touch Up Inside 重置所有数据，重新开始游戏
    @IBAction func reSet(sender: AnyObject) {
        curValue = 50
        score = 0
        round = 0
        onUpdate()
    }
    
    //关联Touch Up Inside 显示帮助信息
    @IBAction func onShowInfo(sender: AnyObject) {
        //实例化一个得分规则界面
        let controller = InfoViewController(nibName: "InfoViewController",bundle: nil)
        //设置界面的动画方式
        controller.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        //界面跳转
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    //显示界面的更新函数
    func onUpdate(){
        //生成随机目标值
        tarValue = Int(1+arc4random()%100)
        //给目标滑块进行赋值,Slider的value为float，需转换
        sliderTarget.value = Float(tarValue)
        //给总分label赋值
        labScore.text = String(self.score)
        //回合+1
        round += 1
        //对总回合数进行赋值
        labRound.text = String(self.round)
        //重置滑块
        mySlider.value = 50
        
    }
    func onCreateSlider(){
        //设置滑块图片
        let imgThumbNormal  = UIImage(named: "SliderThumb-Normal")
        self.mySlider.setThumbImage(imgThumbNormal, forState: UIControlState.Normal)
        self.sliderTarget.setThumbImage(imgThumbNormal, forState: .Normal)
        
        //设置滑块高亮图片
        let imgThumbHighlighted = UIImage(named: "SliiderThumb-Highlighted")
        self.mySlider.setThumbImage(imgThumbHighlighted, forState: .Highlighted)
        self.sliderTarget.setThumbImage(imgThumbHighlighted, forState: .Highlighted)
        
        //设置滑块左边轨道图片
        let imgTrackLeft = UIImage(named: "SliderTrackLeft")
        //设置图片为三宫缩放形式，从左14像素，从右开始14像素不变形，中间部分拉伸
        let imgLeft = imgTrackLeft?.stretchableImageWithLeftCapWidth(14, topCapHeight: 0)
        self.mySlider.setMinimumTrackImage(imgLeft, forState: .Normal)
        self.sliderTarget.setMinimumTrackImage(imgLeft, forState: .Normal)
        
        //设置右边轨道图片
        let imgTrackRight = UIImage(named: "sliderTrackRight")
        let imgRight = imgTrackRight?.stretchableImageWithLeftCapWidth(14, topCapHeight: 0)
        self.mySlider.setMaximumTrackImage(imgRight, forState: .Normal)
        self.sliderTarget.setMaximumTrackImage(imgRight, forState: .Normal)
        
    }
}

