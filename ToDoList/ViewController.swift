//
//  ViewController.swift
//  ToDoList
//
//  Created by liuxu on 2017/6/13.
//  Copyright © 2017年 liuxu. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    
    var db:Connection?
    let notes = Table("notes")
    let id = Expression<Int>("id")
    let noteTitle = Expression<String>("title")
    let status = Expression<Int>("status")
    var editStatus: Bool = false
    
    var leftArray: NSMutableArray?

    var rightArray: NSMutableArray?

    
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView.init(frame: CGRect.init(x: 0, y: TOPVIEW_HEIGHT, width: SCREEN_WIDTH, height: SCROLLVIEW_HEIGHT))
        scroll.delegate = self
        scroll.backgroundColor = UIColor.clear
        scroll.isPagingEnabled = true
        scroll.contentSize = CGSize.init(width: SCREEN_WIDTH * 2, height: SCROLLVIEW_HEIGHT)
        return scroll
    }()
    
    fileprivate lazy var leftTable: UITableView = {
        let table: UITableView = UITableView.init(frame: CGRect.init(x: 20, y: 0, width: SCREEN_WIDTH - 40, height: SCROLLVIEW_HEIGHT))
        table.backgroundColor = .clear
        table.register(TableViewCell.self, forCellReuseIdentifier: "cell")
//        table.rowHeight = 40
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        return table
    }()
    
    fileprivate lazy var rightTable: UITableView = {
        let table: UITableView = UITableView.init(frame: CGRect.init(x: SCREEN_WIDTH + 20, y: 0, width: SCREEN_WIDTH - 40, height: SCROLLVIEW_HEIGHT))
        table.backgroundColor = .clear
        table.register(TableViewCell.self, forCellReuseIdentifier: "cell")
//        table.rowHeight = 40
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none

        return table
    }()
    
    fileprivate lazy var leftButton: UIButton = {
        let button: UIButton = UIButton.init(frame: CGRect.init(x: 0, y: STATUSBAR_HEIGHT, width: SCREEN_WIDTH / 2, height: MENU_HEIGHT - 1))
        button.tag = 1
        button.setTitle("To Do", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    
    fileprivate lazy var rightButton: UIButton = {
        let button: UIButton = UIButton.init(frame: CGRect.init(x: SCREEN_WIDTH / 2, y: STATUSBAR_HEIGHT, width: SCREEN_WIDTH / 2, height: MENU_HEIGHT - 1))
        button.tag = 2
        button.setTitle("Complete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.isSelected = false
        return button
    }()
    
    fileprivate lazy var addButton: UIButton = {
        let button: UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 40, height: 40))
        button.tag = 3
        button.setImage(UIImage.init(named: "tianjia"), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.isSelected = false
        return button
    }()
    
    fileprivate lazy var lineView: UIView = {
        let line: UIView = UIView.init(frame: CGRect.init(x: 0, y:TOPVIEW_HEIGHT - LINE_HEIGHT, width: SCREEN_WIDTH / 2, height: LINE_HEIGHT))
        line.backgroundColor = .black
        return line
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        

        self.view.backgroundColor = BACKGROUND_COLOR
        
        loadData()
        
        self.view.addSubview(self.leftButton)
        
        self.view.addSubview(self.rightButton)
        
        self.view.addSubview(self.lineView)
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.leftTable)
        self.leftTable.tableFooterView = self.addButton
        self.leftTable.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        
        self.scrollView.addSubview(self.rightTable)
        self.rightTable.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        
    }
    
    func loadData() {
        
        self.leftArray = NSMutableArray()
        self.rightArray = NSMutableArray()
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.db = try? Connection("\(path)/db.sqlite3")
        try! self.db?.run(notes.create(ifNotExists: true, block: { (table) in
            table.column(id, primaryKey: true)
            table.column(noteTitle)
            table.column(status)
        }))
        
        for note in (try! self.db?.prepare(notes))! {
            print("Query:id: \(note[id]), title: \(String(describing: note[noteTitle])), status: \(note[status])")
            let model: Model = Model()
            model.status = note[status]
            model.Id = note[id]
            model.title = note[noteTitle]
            if model.status == 1 {
                self.leftArray?.add(model)
            } else {
                self.rightArray?.add(model)
            }
        }
        

    }

    func buttonAction(button: UIButton) {
        button.isSelected = true
        if button.tag == 1 {
            print("1")
            self.rightButton.isSelected = false
            self.scrollView.contentOffset = CGPoint.init(x: 0, y: 0)
            UIView.animate(withDuration: 0.3, animations: { 
                self.lineView.frame = CGRect.init(x: 0, y:TOPVIEW_HEIGHT - LINE_HEIGHT, width: SCREEN_WIDTH / 2, height: LINE_HEIGHT)
            })
        } else if (button.tag == 2) {
            print("2")
            self.leftButton.isSelected = false
            self.scrollView.contentOffset = CGPoint.init(x: SCREEN_WIDTH, y: 0)
            UIView.animate(withDuration: 0.3, animations: {
                self.lineView.frame = CGRect.init(x: SCREEN_WIDTH / 2, y:TOPVIEW_HEIGHT - LINE_HEIGHT, width: SCREEN_WIDTH / 2, height: LINE_HEIGHT)
            })
        } else if (button.tag == 3) {
            
            if editStatus && self.leftArray!.count > 0 {
                let lastModel:Model = self.leftArray?.lastObject as! Model
                if lastModel.title!.isEmpty {
                    self.leftArray?.remove(lastModel)
                    self.leftTable.reloadData()
                } else {
                    if lastModel.Id == nil {
                        let date = NSDate()
                        let timeInterval = date.timeIntervalSince1970 * 1000
                        lastModel.Id = Int(timeInterval)
                    }
                    let result = notes.filter(id == lastModel.Id!)
                    
                    try! db?.run(result.delete())
                    let insert = notes.insert(id <- lastModel.Id!, noteTitle <- lastModel.title!, status <- lastModel.status!)
                    try! db?.run(insert)
                    print("保存")
                }
                editStatus = false
            }
            
            editStatus = true 
            let model: Model = Model()
            model.status = 1
            model.title = ""
            self.leftArray?.add(model)
            self.leftTable.reloadData();
            let cell: TableViewCell = self.leftTable.cellForRow(at: IndexPath.init(row: 0, section: self.leftArray!.count - 1)) as! TableViewCell
            cell.textField?.becomeFirstResponder()
        }
    }
    
    func caculatorLayerHeight(array: NSMutableArray) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if scrollView.contentOffset.x < SCREEN_WIDTH {
                print("1")
                UIView.animate(withDuration: 0.3, animations: {
                    self.leftButton.isSelected = true
                    self.rightButton.isSelected = false
                    self.lineView.frame = CGRect.init(x: 0, y:TOPVIEW_HEIGHT - LINE_HEIGHT, width: SCREEN_WIDTH / 2, height: LINE_HEIGHT)
                })
            } else {
                print("2");
                UIView.animate(withDuration: 0.3, animations: {
                    self.leftButton.isSelected = false
                    self.rightButton.isSelected = true
                    self.lineView.frame = CGRect.init(x: SCREEN_WIDTH / 2, y:TOPVIEW_HEIGHT - LINE_HEIGHT, width: SCREEN_WIDTH / 2, height: LINE_HEIGHT)
                })
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = TableViewCell.init(style: .value1, reuseIdentifier: "cell")
        cell.delegate = self
        if tableView == self.leftTable {
            cell.model = self.leftArray?[indexPath.section] as! Model
            return cell
        } else {
            cell.model = self.rightArray?[indexPath.section] as! Model
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.leftTable {
            return 1
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.leftTable {
            return (self.leftArray?.count)!
        } else {
            return (self.rightArray?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == self.leftTable {
//            let model: Model = self.leftArray![indexPath.row] as! Model
//            return model.height
//        } else {
//            let model: Model = self.rightArray![indexPath.row] as! Model
//            return model.height
//        }
        return 40
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
//        cell.textField?.isUserInteractionEnabled = true
//        cell.textView?.isHidden = true
//        cell.textField?.isHidden = false
//    }
}

extension ViewController: TableViewCellDelegate {
    func TableViewCellAction(button: UIButton, model: Model) {
        if (button.tag > 0) {
            switch button.tag {
            case 1:
                if model.Id == nil {
                    let date = NSDate()
                    let timeInterval = date.timeIntervalSince1970 * 1000
                    model.Id = Int(timeInterval)
                }
                self.leftArray?.remove(model)
                model.status = 2
                self.rightArray?.add(model)
                
                let result = notes.filter(id == model.Id!)
                try! db?.run(result.delete())
                let insert = notes.insert(id <- model.Id!, noteTitle <- model.title as String!, status <- model.status!)
                try! db?.run(insert)
            case 2:
                if model.Id == nil {
                    let date = NSDate()
                    let timeInterval = date.timeIntervalSince1970 * 1000
                    model.Id = Int(timeInterval)
                }
                self.rightArray?.remove(model)
                model.status = 1
                self.leftArray?.add(model)
                
                let result = notes.filter(id == model.Id!)
                try! db?.run(result.delete())
                let insert = notes.insert(id <- model.Id!, noteTitle <- model.title as String!, status <- model.status!)
                try! db?.run(insert)
            case 3:
                if model.Id == nil {
                    let date = NSDate()
                    let timeInterval = date.timeIntervalSince1970 * 1000
                    model.Id = Int(timeInterval)
                }
                if model.status == 1 {
                    self.leftArray?.remove(model)
                } else {
                    self.rightArray?.remove(model)
                }
                let result = notes.filter(id == model.Id!)
                try! db?.run(result.delete())

            default:
                break;
            }
            self.leftTable.reloadData()
            self.rightTable.reloadData()
        } else {
            if model.title!.isEmpty {
                self.leftArray?.remove(model)
            } else {
                if model.Id == nil {
                    let date = NSDate()
                    let timeInterval = date.timeIntervalSince1970 * 1000
                    model.Id = Int(timeInterval)
                }
                let result = notes.filter(id == model.Id!)
                
                try! db?.run(result.delete())
                let insert = notes.insert(id <- model.Id!, noteTitle <- model.title!, status <- model.status!)
                try! db?.run(insert)
                print("保存")
            }
            self.leftTable.reloadData()
        }
    }
}

