//
//  TableViewCell.swift
//  ToDoList
//
//  Created by liuxu on 2017/6/13.
//  Copyright © 2017年 liuxu. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate {
    func TableViewCellAction(button: UIButton, model: Model)
}

class TableViewCell: UITableViewCell {
    
    var delegate: TableViewCellDelegate?
    
    var _model: Model?
    
    var model: Model {
        set {
            _model = newValue
//            self.textView?.text = newValue.title! as String
            self.textField?.text = newValue.title! as String
            self.button?.setImage(newValue.status == 1 ? UIImage.init(named: "complete") : UIImage.init(named: "reset"), for: .normal)
            self.button?.tag = newValue.status == 1 ? 1 : 2
            self.button2?.setImage(UIImage.init(named: "delete"), for: .normal)
            
            self.textField?.isUserInteractionEnabled = newValue.status == 1 ? true : false
//            self.textView?.isUserInteractionEnabled = self.textField?.isUserInteractionEnabled == false
            
        }
        get {
            return _model!
        }
    }
    
    
    var textView: UITextView?
    var textField: UITextField?
    var button: UIButton?
    var button2: UIButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        self.contentView.backgroundColor = UIColorFromRGB(0x7edbfc)
                
        self.button2 = UIButton()
        self.button2?.tag = 3
        self.button2?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.contentView.addSubview(self.button2!)
        self.button2?.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView).offset(-10)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        })
        
        self.button = UIButton()
        self.button?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.contentView.addSubview(self.button!)
        self.button?.snp.makeConstraints({ (make) in
            make.right.equalTo(self.button2!.snp.left).offset(-10)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        })
        
        self.textField = UITextField()
        self.textField?.textColor = .black
        self.textField?.delegate = self
        self.textField?.returnKeyType = .done
        self.textField?.font = UIFont.systemFont(ofSize: 15)
        self.textField?.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
        self.contentView.addSubview(self.textField!)
        self.textField?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.button!.snp.left).offset(-10)
            make.top.bottom.equalTo(self.contentView)
        })
        
//        self.textView = UITextView()
//        self.textView?.textColor = .green
//        self.textView?.delegate = self
//        self.textView?.returnKeyType = .done
//        self.textView?.font = UIFont.systemFont(ofSize: 15)
//        self.contentView.addSubview(self.textView!)
//        self.textView?.snp.makeConstraints({ (make) in
//            make.left.equalTo(self.contentView).offset(10)
//            make.right.equalTo(self.button!.snp.right).offset(-10)
//            make.top.bottom.equalTo(self.contentView)
//        })
        
//        self.textField?.isHidden = true
//        self.textView?.isHidden = false
    }
    
    func textFieldAction(textField: UITextField) {
        self.model.title = textField.text
    }
    
    func buttonAction(button: UIButton) {
        if self.model.title!.isEmpty {
            
        } else {
            self.delegate?.TableViewCellAction(button: button, model: self.model)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension TableViewCell: UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.model.title = textField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        self.delegate?.TableViewCellAction(button: UIButton(), model: self.model)
        return textField.endEditing(true)
    }
}
