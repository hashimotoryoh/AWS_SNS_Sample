//
//  ViewController.swift
//  AWS_SNS_Sample
//
//  Created by Ryoh Hashimoto on 2016/12/08.
//  Copyright © 2016年 Ryoh Hashimoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var _deviceTokenLabel: UILabel!
    @IBOutlet weak var _endpointArnLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _deviceTokenLabel.text = UserDefaults.standard.string(forKey: "deviceToken")
        _endpointArnLabel.text = UserDefaults.standard.string(forKey: "endpointArn")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

