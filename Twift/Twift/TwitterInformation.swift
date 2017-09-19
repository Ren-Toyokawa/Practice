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
import BrightFutures

class TwitterInformation {
    
    var accountStore: ACAccountStore = ACAccountStore()
    var twAccount: ACAccount = ACAccount()
    let TWITTER_TIMELINE_URL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    
    init(){
        let setTwAccount = { (accounts: [ACAccount]) -> Void in
            self.twAccount = accounts[0]
            print("twitter Account get successfull")
        }
        getAccounts(callBack: setTwAccount)
    }
    
    func getAccounts(callBack: @escaping ([ACAccount]) -> Void){
        // アカウントのタイプを取得する
        let promise = Promise<Profile,NSError>()
        
        
        let accountType: ACAccountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        print("Account get")
        accountStore.requestAccessToAccounts(with: accountType, options: nil) {(granted: Bool, error: Error?) -> Void in
            if error != nil {
                // エラー処理
                print("error! \(error)")
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

    }

    
    /**
        TimeLineを取得する。
        - parameter callBack: クロージャ　何するかわかんね
        - returns: Void
     */
    func getTimeLine(){
        let url:URL = URL(string:TWITTER_TIMELINE_URL)!
        Thread.sleep(forTimeInterval: 3)
        sendRequest(url: url, requestMethod: .GET , params: nil){(responseData,urlResponse) -> Void in
            do{
                let result = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                print("TimeLine取得")
                print(result)
            } catch{
                print("エラーが発生しました。")
            }
        }
    
    }
    
    //疑問メモ：Swift3から最初の引数もラベルが必要になったらしい。一貫性のラベルをつけるためらしいけど、これで一貫性は保たれるのか？
    private func sendRequest(url: URL, requestMethod: SLRequestMethod, params: AnyObject?, responseHandler: @escaping (_ responseData: Data,_ urlResponse: HTTPURLResponse?) -> Void){
        let request:SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter,
                                          requestMethod: requestMethod,
                                          url: url,
                                          parameters: nil)
        request.account = twAccount
        request.perform { (responseData: Data?,urlResponse: HTTPURLResponse?,error: Error?) -> Void in
            if(error != nil) {
                print("error is \(error)")
            } else {
                // 疑問メモ　まず、引数に使うクロージャは、属性として、@escapingをつけないといけないらしい。なぜかはわからないが。
                responseHandler(responseData!,urlResponse)
            }
        }
    }
    
    
    
}
