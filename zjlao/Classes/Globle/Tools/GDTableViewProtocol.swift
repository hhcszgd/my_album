//
//  GDTableViewProtocol.swift
//  zjlao
//
//  Created by WY on 2017/9/14.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDTableViewProtocol:NSObject , UITableViewDelegate , UITableViewDataSource  {
    
}

extension GDTableViewProtocol{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil  {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "\(indexPath.section)组\(indexPath.row)行"
        return cell ?? UITableViewCell()
    }
}
