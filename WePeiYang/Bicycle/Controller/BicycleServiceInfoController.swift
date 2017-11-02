//
//  BicycleServiceInfoController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/7.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation
import JBChartView
import SnapKit
import UIKit

class BicycleServiceInfoController: UIViewController, UITableViewDelegate, UITableViewDataSource, JBLineChartViewDelegate, JBLineChartViewDataSource {
    /**
     *  Returns the number of lines for the line chart.
     *
     *  @param lineChartView    The line chart object requesting this information.
     *
     *  @return The number of lines in the line chart.
     */
    public func numberOfLines(in lineChartView: JBLineChartView!) -> UInt {
        return 0
    }
    
    var chartView: JBChartView!
    var infoLabel = UILabel()
    @IBOutlet weak var tableView: UITableView!
    
    var user = timeStampTransfer()
    
    //iOS 8 fucking bug
    init(){
        super.init(nibName: "BicycleServiceInfoController", bundle: nil)
        print("haha")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.frame.size.width = (UIApplication.shared.keyWindow?.frame.size.width)!
        
        navigationController?.navigationBar.tintColor = .white
        
        //self.tableView.bounces = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置delegate, dataSource
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if BicycleUser.sharedInstance.status == 1 {
            BicycleUser.sharedInstance.getUserInfo(doSomething: {
                self.updateUI()
            })
            
        }
    }
    
    func updateUI() {
        /*
         //UI
         //chartViewBackground
         let background = UIImage(named: "BicyleChartBackgroundImage")
         let backgroundView = UIView(frame: CGRect(x: 8, y: 116, width: (UIApplication.sharedApplication().keyWindow?.frame.size.width)!-16, height: 220))
         backgroundView.layer.cornerRadius = 8.0
         backgroundView.backgroundColor = UIColor(patternImage: background!)
         self.view.addSubview(backgroundView)
         
         //chartView
         let chartView = JBLineChartView(frame: self.calculateChartViewFrame())
         chartView.delegate = self
         chartView.dataSource = self
         chartView.backgroundColor = UIColor.clearColor()
         self.view.addSubview(chartView)
         chartView.reloadData()
         
         
         let lastHour = BicycleUser.sharedInstance.recent![BicycleUser.sharedInstance.recent!.count-1][0]
         let lastDuration = BicycleUser.sharedInstance.recent![BicycleUser.sharedInstance.recent!.count-1][1]
         self.infoLabel!.text = "\(lastHour):00  骑行时间：\(lastDuration)s"
         */
        
        //tableView
        tableView.reloadData()
        
        //chartView
        chartView.reloadData()
    }
    
    func calculateChartViewFrame() -> CGRect {
        let x = CGFloat(24)
        let y = CGFloat(24)
        let width = CGFloat((UIApplication.shared.keyWindow?.frame.size.width)!-48)
        let height = CGFloat(188)
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshInfo() {
        if BicycleUser.sharedInstance.status == 1 {
            BicycleUser.sharedInstance.getUserInfo(doSomething: {
                self.updateUI()
            })
        } else {
            //MsgDisplay.showErrorMsg("未绑定自行车卡信息")
            infoLabel.text = "未绑定自行车卡信息"
        }
    }
    
    //dataScoure of chartView
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        
        return UInt(BicycleUser.sharedInstance.recent.count)
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        
        //let res = data[Int(horizontalIndex)]["dist"] as! CGFloat
        let res = BicycleUser.sharedInstance.recent[Int(horizontalIndex)][1] as? CGFloat
        return res!
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, dotRadiusForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return 4.0
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return 2.0
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, lineStyleForLineAtLineIndex lineIndex: UInt) -> JBLineChartViewLineStyle {
        return JBLineChartViewLineStyle.dashed
    }
    
    //delegate of chartView
    func lineChartView(_ lineChartView: JBLineChartView!, didSelectLineAt lineIndex: UInt, horizontalIndex: UInt) {
        let date = BicycleUser.sharedInstance.recent[Int(horizontalIndex)][0]
        var time = BicycleUser.sharedInstance.recent[Int(horizontalIndex)][1] as! Int
        var minute: Int
        var second: Int
        var hour: Int
        
        hour = time / 3600
        time %= 3600
        minute = time / 60
        time %= 60
        second = time
        
        var hourString = String(hour)
        if hour < 10 {
            hourString = "0\(String(hour))"
        }
        var minuteString = String(minute)
        if minute < 10 {
            minuteString = "0\(String(minute))"
        }
        var secondString = String(second)
        if second < 10 {
            secondString = "0\(String(second))"
        }
        
        self.infoLabel.text = "\(date)  骑行时间：\(hourString):\(minuteString):\(secondString)"
    }
    
    //dataSource of tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "BicycleInfoCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "BicycleInfoCell")
        }
        
        if indexPath.section == 0 {
            //未完成
            cell!.textLabel?.text = "用户："
            if let name = BicycleUser.sharedInstance.name {
                cell!.textLabel?.text = "用户：\(name)"
            }
            //For demo
            //cell!.textLabel?.text = "用户：鲍一心"
            cell!.imageView?.image = UIImage(named: "ic_account_circle")
            cell!.selectionStyle = .none
        } else if indexPath.section == 1 {
            cell!.textLabel?.text = "余额："
            if let balance = BicycleUser.sharedInstance.balance {
                cell!.textLabel?.text = "余额：¥\(balance)"
            }
            cell!.imageView?.image = UIImage(named: "ic_account_balance_wallet")
            cell!.selectionStyle = .none
        } else if indexPath.section == 2 {
            cell!.textLabel?.text = "最近记录："
            if let foo = BicycleUser.sharedInstance.record {
                var timeStampString = foo.object(forKey: "arr_time") as! String
                
                //借了车，没还车
                if Int(timeStampString) == 0 {
                    cell?.textLabel?.text = "最近记录：借车"
                    timeStampString = foo.object(forKey: "dep_time") as! String
                    cell?.detailTextLabel?.text = "时间：\(timeStampTransfer.stringFromTimeStampWithFormat(format: "yyyy-MM-dd HH:mm", timeStampString: timeStampString))"
                } else {
                    cell?.textLabel?.text = "最近记录：还车"
                    cell?.detailTextLabel?.text = "时间：\(timeStampTransfer.stringFromTimeStampWithFormat(format: "yyyy-MM-dd HH:mm", timeStampString: timeStampString))"
                }
            }
            cell!.imageView?.image = UIImage(named: "ic_schedule")
            cell!.selectionStyle = .none
        } else if indexPath.section == 3 {
            cell!.imageView?.image = UIImage(named: "ic_history")
            cell!.textLabel?.text = "查询记录"
        } else if indexPath.section == 4 {
            cell!.imageView?.image = UIImage(named: "ic_history")
            cell!.textLabel?.text = "数据分析"
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 264
        }
        return 4
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section != 0 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 4))
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
        
        //log.word("drawing header view")
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 250))
        
        //infoLabel
        infoLabel = UILabel()
        headerView.addSubview(infoLabel)
        infoLabel.text = "骑行时间："
        infoLabel.snp.makeConstraints {
            make in
            make.centerX.equalTo(headerView)
            make.top.equalTo(headerView).offset(8)
        }
        
        let bicycleIconView = UIImageView(imageName: "ic_bike", desiredSize: CGSize(width: 30, height: 30))
        headerView.addSubview(bicycleIconView!)
        bicycleIconView?.snp.makeConstraints { make in
            make.centerY.equalTo(infoLabel)
            make.right.equalTo(infoLabel.snp.left).offset(-8)
        }
        
        
        //chartViewBackground
        let chartBackground = UIImageView(imageName: "BicyleChartBackgroundImage", desiredSize: CGSize(width: (UIApplication.shared.keyWindow?.frame.size.width)!-16, height: 220))
        headerView.addSubview(chartBackground!)
        
        chartBackground?.snp.makeConstraints {
            make in
            make.top.equalTo(infoLabel.snp_bottom).offset(8)
            make.left.equalTo(headerView).offset(8)
            make.right.equalTo(headerView).offset(-8)
            make.bottom.equalTo(headerView).offset(-8)
        }
        
        chartBackground!.clipsToBounds = true
        chartBackground!.layer.cornerRadius = 8
        for subview in chartBackground!.subviews {
            subview.layer.cornerRadius = 8
        }
        
        /*
         let background = UIImage(named: "BicyleChartBackgroundImage")
         let backgroundView = UIView(frame: CGRect(x: 8, y: 8, width: (UIApplication.sharedApplication().keyWindow?.frame.size.width)!-16, height: 220))
         backgroundView.layer.cornerRadius = 8.0
         backgroundView.backgroundColor = UIColor(patternImage: background!)
         view.addSubview(backgroundView)*/
        
        
        //chartView
        chartView = JBLineChartView(frame: CGRect(x: 16, y: 53, width: (UIApplication.shared.keyWindow?.frame.size.width)!-32, height: 188))
        //chartView = JBLineChartView(frame: CGRectMake(8, 8, 300, 220))
        chartView.delegate = self
        chartView.dataSource = self
        chartView.backgroundColor = UIColor.clear
        headerView.addSubview(chartView)
        chartView.reloadData()
        
        /*
         chartView.snp_makeConstraints {
         make in
         make.left.equalTo(chartBackground!).offset(8)
         make.right.equalTo(chartBackground!).offset(-8)
         make.top.equalTo(chartBackground!).offset(8)
         make.bottom.equalTo(chartBackground!).offset(-8)
         }*/
        
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 4))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    
    //delegate of tableView
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3 {
            //            MsgDisplay.showErrorMsg("暂时没有这个功能哦")
        }
        
        if indexPath.section == 4 {
            if #available(iOS 9.3, *) {
                let fitnessVC = BicycleFitnessTrackerViewController()
                self.navigationController?.pushViewController(fitnessVC, animated: true)
                tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            } else {
                // Fallback on earlier versions
            }
            
        }
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    
}
