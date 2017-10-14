//
//  TwitterInformation.swift
//  Twift
//
//  Created by 豊川廉 on 2016/11/14.
//  Copyright © 2016年 Raptor Inc. All rights reserved.
//

import Foundation
import Accounts
import Social
import SwiftyJSON
import Hydra

class TwitterInformation {
    
    var accountStore: ACAccountStore = ACAccountStore()
    var twAccount: ACAccount = ACAccount()
    private var my_id: String = String()
    
    // initializeation twitter information
    init(){
        getAccounts(callBack: { (accounts: [ACAccount]) -> Void in
            self.twAccount = accounts[0]
            print("twitter Account get successfull")
        })
    }
    
    
    // get account kick Twitter API
    func getAccounts(callBack: @escaping ([ACAccount]) -> Void){
        // アカウントのタイプを取得する
        //let promise = Promise<Profile,NSError>()
        print("start Account Get.....")
        
        let accountType: ACAccountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccounts(with: accountType, options: nil) {(granted: Bool, error: Error?) -> Void in
            if error != nil {
                // エラー処理
                print("error! \(String(describing: error))")
                return
            }
            if !granted {
                print("error! Twitterアカウントの利用が許可されていません")
                return
            }
            let accounts = self.accountStore.accounts(with: accountType) as! [ACAccount]
            if accounts.count == 0 {
                print("error! 設定画面からアカウントを設定してください")
                return
            }
            callBack(accounts)
        }
        
        print("End Account Get.....")

    }
    
    func getAccountData(action:@escaping (JSON) -> Void){
        let url:URL = URL(string:"https://api.twitter.com/1.1/account/verify_credentials.json")!
        getTwInfo(url: url, action: action)
    }
    
    func getFollowers(action:@escaping (JSON) -> Void){
        let url:URL = URL(string:"https://api.twitter.com/1.1/account/verify_credentials.json")!
        getTwInfo(url: url, action: action)
    }
    
    private func getUserId(){
        waitAcquireAccount()
        let url:URL = URL(string:"https://api.twitter.com/1.1/users/show.json")!
        getTwInfo(url: url, action: { (json: JSON) -> Void in
            print("getUserId")
            print(json)
        })
    }
    
    /**
        TimeLineを取得する。
        - returns: Void
     */
    func getTimeLine(action:@escaping (JSON) -> Void ){
        let url:URL = URL(string:"https://api.twitter.com/1.1/statuses/home_timeline.json")!
        getTwInfo(url: url, action: action)
    }
    
    func getFollowersData(action:@escaping (JSON) -> Void){
        let url:URL = URL(string:"https://api.twitter.com/1.1/followers/list.json?")!
        getTwInfo(url : url,action : action)
    }
    
    private func getTwInfo(url: URL ,action:@escaping (JSON) -> Void){
        if(twAccount.username == nil){
          waitAcquireAccount()
        }
        
        print(twAccount.username)
        sendRequest(url: url, requestMethod: .GET , params: nil){(responseData,urlResponse) -> Void in
            do{
                let result = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                let resultJSON = JSON(result)
                // わたされたclosure によって　値の加工等をする
                // どういったことをするのかは、呼び出し元に委ねる
                action(resultJSON)
            }catch{
                print("エラーが発生しました。")
            }
        }
        
    }
    
    
    // send to http request
    private func sendRequest(url: URL, requestMethod: SLRequestMethod, params: AnyObject?, responseHandler: @escaping (_ responseData: Data,_ urlResponse: HTTPURLResponse?) -> Void){
        let request:SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter,
                                          requestMethod: requestMethod,
                                          url: url,
                                          parameters: nil)
        request.account = twAccount
        request.perform { (responseData: Data?,urlResponse: HTTPURLResponse?,error: Error?) -> Void in
            if(error != nil) {
                print("error is \(String(describing: error))")
            } else {
                responseHandler(responseData!,urlResponse)
            }
        }
    }

    
    
    // アカウントが認証されるまで待機させるメソッド
    private func waitAcquireAccount(){
        sleep(1)
        if twAccount.username == nil{
            print("Account Loding...")
            waitAcquireAccount()
        }else{
            print("Account Get Success Full")
        }
        
    }
    
}
