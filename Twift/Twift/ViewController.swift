//
//  ViewController.swift
//  Twift
//
//  Created by 豊川廉 on 2016/11/14.
//  Copyright © 2016年 Raptor Inc. All rights reserved.
//

import UIKit
import SwiftyJSON
import Hydra


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    // Tableで使用する配列を設定する
    private var myTableView: UITableView!
    private let CELL_NAME = NSStringFromClass(TimeLineCell.self)
    
    
    private var TWEET_GET_SUCCESS = false
    
    struct Tweet {
        var icon = UIImageView()
        var iconUrl = String()
        var account = String()
        var userName = String()
        var tweet = String()
    }

    
    var retTimeLine = [Tweet]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let twInfo : TwitterInformation = TwitterInformation()
        let setTimeLine = { (timeline: JSON) -> Void in
            
            // 汚い...
            async({_ -> Void in
                timeline.forEach({(_,timeline) in
                    var addTweet = Tweet()
                    addTweet.tweet = timeline["text"].stringValue
                    addTweet.userName = timeline["name"].stringValue
                    let url = URL(string: timeline["user"]["profile_image_url_https"].stringValue)!
                    try! await (self.getImage(url: url).then{ imageView throws -> () in
                        print(imageView.image?.size.width ?? "nil")
                        print(imageView.image?.size.height ?? "nil")
                        addTweet.icon = imageView
                    })
                    self.retTimeLine.append(addTweet)
                })
            }).then({_ in
                self.tableViewSetting()
            })
    }
    
    twInfo.getTimeLine(action:setTimeLine)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func tableViewSetting() {
        print("start setting table view")
        // Status Barの高さを取得する.
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // TableViewの生成(Status barの高さをずらして表示).
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight))
        // Cell名の登録をおこなう.
        myTableView.register(TimeLineCell.self, forCellReuseIdentifier: CELL_NAME)
        // DataSourceを自身に設定する.
        myTableView.dataSource = self
        // Delegateを自身に設定する.
        myTableView.delegate = self
        
        // Viewに追加する.
        self.view.addSubview(myTableView)
    }
    
    /*
     Cellが選択された際に呼び出される
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(retTimeLine[indexPath.row])")
    }
    
    /*
     Cellの総数を返す.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retTimeLine.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    /*
     Cellに値を設定する
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_NAME, for: indexPath as IndexPath) as! TimeLineCell
        // Cellに値を設定する.
        cell.accountName!.text = "\(retTimeLine[indexPath.row].account)"
        cell.tweet!.text = "\(retTimeLine[indexPath.row].tweet)"
        cell.accountIconView = retTimeLine[indexPath.row].icon
        
        
        
        print("return cell")
        return cell
    }
    
    func getImage(url:URL) -> Promise<UIImageView>{
        return Promise<UIImageView>{resolve,reject, _ in
            print("start get images...")
            let CACHE_SEC : TimeInterval = 5 * 60
            let req = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: CACHE_SEC)
            let conf = URLSessionConfiguration.default
            let session = URLSession(configuration: conf, delegate: nil, delegateQueue: OperationQueue.main)
            session.dataTask(with: req,completionHandler:
                { (data,resp,err) in
                    if let err = err{
                        reject(err)
                    }else{
                        print("Success")
                        resolve(UIImageView(image: UIImage(data:data!)))
                    }
            }).resume()
        }
    }

}

