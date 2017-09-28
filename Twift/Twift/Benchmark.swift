//
//  Benchmark.swift
//  Twift
//
//  Created by 豊川廉 on 2017/03/29.
//  Copyright © 2017年 Raptor Inc. All rights reserved.
//

import Foundation

class Benchmark {
    
    // 開始時刻を保存する変数
    var startTime: NSDate
    var key: String
    
    // 処理開始
    init(key: String) {
        self.startTime = NSDate()
        self.key = key
    }
    
    // 処理終了
    func finish() {
        let elapsed = NSDate().timeIntervalSinceDate(self.startTime) as Double
        let formatedElapsed = String(format: "%.3f", elapsed)
        println("Benchmark: \(key), Elasped time: \(formatedElapsed)(s)")
    }
    
    // 処理をブロックで受け取る
    class func measure(key: String, block: () -> ()) {
        let benchmark = Benchmark(key: key)
        block()
        benchmark.finish()
    }
}
