//
//  FileDownloadLogsDetailViewController.swift
//  Easy Digital Downloads
//
//  Created by Sunny Ratilal on 22/08/2016.
//  Copyright © 2016 Easy Digital Downloads. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class FileDownloadLogsDetailViewController: SiteTableViewController {
    
    private enum CellType {
        case Title
        case MetaHeading
        case Meta
        case ProductHeading
        case Product
        case PaymentHeading
        case Payment
        case CustomerHeading
        case Customer
    }
    
    private var cells = [CellType]()

    var site: Site?
    var log: Log!
    var product: Product?
    var payment: Sales?
    var customer: Customer?
    
    var paymentId: Int64 = 0
    var customerId: Int64 = 0
    var productId: Int64 = 0
    
    init(log: Log) {
        super.init(style: .Plain)
        
        self.site = Site.activeSite()
        self.log = log
        
        self.paymentId = log.paymentId
        self.customerId = log.customerId
        self.productId = log.productId
        
        title = log.productName
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        
        let titleLabel = ViewControllerTitleLabel()
        titleLabel.setTitle(log.productName)
        navigationItem.titleView = titleLabel
        
        setupDataSource()
        networkOperations()
        
        tableView.registerClass(FileDownloadLogsMetaTableViewCell.self, forCellReuseIdentifier: "FileDownloadLogMetaCell")
        tableView.registerClass(FileDownloadLogsCustomerTableViewCell.self, forCellReuseIdentifier: "FileDownloadLogCustomerCell")
        tableView.registerClass(FileDownloadLogsPaymentTableViewCell.self, forCellReuseIdentifier: "FileDownloadLogPaymentCell")
        tableView.registerClass(FileDownloadLogsProductTableViewCell.self, forCellReuseIdentifier: "FileDownloadLogProductCell")
        tableView.registerClass(FileDownloadLogsHeadingTableViewCell.self, forCellReuseIdentifier: "FileDownloadLogsHeadingCell")
        tableView.registerClass(FileDownloadLogsTitleTableViewCell.self, forCellReuseIdentifier: "FileDownloadLogsTitleCell")
        
        cells = [.Title, .MetaHeading, .Meta, .ProductHeading, .Product, .PaymentHeading, .Payment, .CustomerHeading, .Customer]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupDataSource() {
        if let product = Product.productForId(log.productId) {
            self.product = product
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView.reloadData()
            })
        }
        
        if let customer = Customer.customerForId(log.customerId) {
            self.customer = customer
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    func networkOperations() {
        
    }
    
    // MARK: Table View Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    // MARK: Table View Delegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch cells[indexPath.row] {
            case .Title:
                cell = tableView.dequeueReusableCellWithIdentifier("FileDownloadLogsTitleCell", forIndexPath: indexPath) as! FileDownloadLogsTitleTableViewCell
                (cell as! FileDownloadLogsTitleTableViewCell).configure("Log #\(log.ID)")
            case .MetaHeading:
                cell = tableView.dequeueReusableCellWithIdentifier("FileDownloadLogsHeadingCell", forIndexPath: indexPath) as! FileDownloadLogsHeadingTableViewCell
                (cell as! FileDownloadLogsHeadingTableViewCell).configure("Meta")
            case .Meta:
                cell = tableView.dequeueReusableCellWithIdentifier("FileDownloadLogMetaCell", forIndexPath: indexPath) as! FileDownloadLogsMetaTableViewCell
                (cell as! FileDownloadLogsMetaTableViewCell).configure(log)
                (cell as! FileDownloadLogsMetaTableViewCell).layout()
            case .CustomerHeading:
                cell = tableView.dequeueReusableCellWithIdentifier("FileDownloadLogsHeadingCell", forIndexPath: indexPath) as! FileDownloadLogsHeadingTableViewCell
                (cell as! FileDownloadLogsHeadingTableViewCell).configure("Customer")
            case .Customer:
                cell = tableView.dequeueReusableCellWithIdentifier("FileDownloadLogCustomerCell", forIndexPath: indexPath) as! FileDownloadLogsCustomerTableViewCell
                (cell as! FileDownloadLogsCustomerTableViewCell).configureForObject(customer)
            case .PaymentHeading:
                cell = tableView.dequeueReusableCellWithIdentifier("FileDownloadLogsHeadingCell", forIndexPath: indexPath) as! FileDownloadLogsHeadingTableViewCell
                (cell as! FileDownloadLogsHeadingTableViewCell).configure("Payment")
            case .Payment:
                cell = tableView.dequeueReusableCellWithIdentifier("FileDownloadLogPaymentCell", forIndexPath: indexPath) as! FileDownloadLogsPaymentTableViewCell
                (cell as! FileDownloadLogsPaymentTableViewCell).configure(payment)
            case .ProductHeading:
                cell = tableView.dequeueReusableCellWithIdentifier("FileDownloadLogsHeadingCell", forIndexPath: indexPath) as! FileDownloadLogsHeadingTableViewCell
                (cell as! FileDownloadLogsHeadingTableViewCell).configure("Product")
            case .Product:
                cell = tableView.dequeueReusableCellWithIdentifier("FileDownloadLogProductCell", forIndexPath: indexPath) as! FileDownloadLogsProductTableViewCell
                (cell as! FileDownloadLogsProductTableViewCell).configureForObject(product)
            
        }
        
        return cell!
    }

}
