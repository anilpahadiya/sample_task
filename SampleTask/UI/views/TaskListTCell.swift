//
//  TaskListTCell.swift
//  SampleTask
//
//  Created by Rajeev Kumar on 05/08/19.
//  Copyright © 2019 anilpahadiya. All rights reserved.
//

import UIKit

class TaskListTCell: UITableViewCell {

    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBg.layer.borderWidth = 0.5
        viewBg.layer.cornerRadius = 10
        viewBg.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected == true
        {
            viewBg.backgroundColor = UIColor(red: 236.0/255, green: 244.0/255, blue: 254.0/255, alpha: 1.0)
            viewBg.layer.borderColor = UIColor(red: 40.0/255, green: 123.0/255, blue: 252.0/255, alpha: 1.0).cgColor
            
        }else
        {
            viewBg.backgroundColor = UIColor.white
            viewBg.layer.borderColor = UIColor.lightGray.cgColor
            
        }
    }

}
