//
//  MarkCustomCell.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class MarkCustomCell: UITableViewCell {
    
    var delegate: PublishLostViewController?
    
    
    
    
    let buttonArray = ["身份证","饭卡","手机","钥匙","书包","手表&饰品","U盘&硬盘","水杯","钱包","银行卡","书","伞","其他"]
    let types = ["1", "2", "3","4","5","6","7","8","9","10","11","12","13"]
    var functionDic:[Int : Array<String>] = [:]
    var buttonAllArray:[UIButton] = []
    let label = UILabel()
    
    let currenWidth: CGFloat = 40
    
//    var totalLength: CGFloat = 0
    var currentLength: CGFloat = 0
    
    var buttonSeccen = 0
    
    var currentY: CGFloat = 50
    var currentX: CGFloat = 10
    
//    func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
//        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName : font], context: nil).size
//    }

    
    

        func enumerated() {
        
        for (index, name) in buttonArray.enumerated() {
        
            

//            totalLength = currentLength
            // 50 margin

            if currentX  < self.frame.size.width {
           // currentLengtn 不对，2017/10/26改的currentX
                let button = UIButton(frame: CGRect(x: currentX, y: currentY, width: currenWidth, height: 30))
                
                button.setTitle(name, for: .normal)
                button.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
                self.addSubview(button)
                button.backgroundColor = UIColor(hex6: 0xd9d9d9)
                button.setTitleColor(UIColor.black, for: .normal)
                button.setTitleColor(UIColor.init(hex6: 0x00a1e9), for: .selected)
                buttonAllArray.append(button)

                button.sizeToFit()

                currentLength = currentLength + button.frame.size.width+25
                currentX = currentX + button.frame.size.width+25
               button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            }
            
            else {
                currentY += 40
                currentX = 10
                
                let button = UIButton(frame: CGRect(x: currentX, y: currentY, width:
                    width, height: 30))
                
                button.setTitle(name, for: .normal)
                button.backgroundColor = UIColor(hex6: 0xd9d9d9)
                button.setTitleColor(UIColor.white, for: .highlighted)
                button.setTitleColor(UIColor.black, for: .normal)

                button.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
                self.addSubview(button)
                buttonAllArray.append(button)
                button.tag = index

                button.sizeToFit()
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//                totalLength = 0
                currentLength = 0
                currentX =  currentX + button.frame.size.width+25
                
//                print(button.frame.size.width)
            
            }
            
        }
//            contentView.backgroundColor = UIColor(hex6: 0xeeeeee)
            addSubview(label)
            
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.textColor = UIColor(hex6: 0x00a1e9)
            
            label.frame = CGRect(x:10, y:5, width:100, height:20)
        
        
    
    }
 
    @objc func buttonTapped(sender: UIButton) {
        
        
        if let title = sender.titleLabel?.text {
            
            if let index =  buttonArray.index(of: title) {
                
                print(index)
                print(types[index])
                
                self.delegate?.means(input: types[index], key: "detail_type")
                switch types[index] {
                case "1":
                    self.delegate?.function[2] = ["卡号*","姓名*"]
                case "2":
                    self.delegate?.function[2] = ["卡号*","姓名*"]
                case "10":
                    self.delegate?.function[2] = ["卡号*","姓名*"]
                default:
                    self.delegate?.function[2] = []
                    
                }
                
                                
                for indexAll in buttonAllArray
                {
                    indexAll.backgroundColor = UIColor(hex6: 0xd9d9d9)
                    indexAll.setTitleColor(.black, for: .normal)
                    
                    
                }
                
                sender.backgroundColor = UIColor(hex6: 0x00a1e9)
                sender.setTitleColor(.white, for: .normal)
                
                
            }
        }
        self.delegate?.tableView.reloadData()
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
