//
//  CitySlideViewController.swift
//  Lab3_Weather
//
//  Created by Jerry Lee on 12/8/17.
//  Copyright © 2017 Jerry Lee. All rights reserved.
//

import UIKit


class CitySlideViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var cityWeatherDataList : [WeatherDataModel]?
    lazy var listCount = cityWeatherDataList?.count
    lazy var tableViewList = [UITableView](repeating: UITableView(), count: listCount!)
    
    var tableView11:UITableView = UITableView()
    var tableView22:UITableView = UITableView()
    var tableView33:UITableView = UITableView()
    
    var cell1 = UITableViewCell()
    var cell2 = UITableViewCell()
    var cell3 = UITableViewCell()
    
    @IBOutlet weak var dynamicScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(375))
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView11.delegate = self
        tableView11.dataSource = self
        
        tableView22.delegate = self
        tableView22.dataSource = self
        
        tableView33.delegate = self
        tableView33.dataSource = self
        
        dynamicScroll()
        initCustomTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1  //返回TableView的Cell数量，可以动态设置；
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        var weatherContent : String = ""
        switch tableView {
            
        case tableView11:
            cell1 = tableView11.dequeueReusableCell(withIdentifier: "cell1") as! UITableViewCell
            weatherContent = cityWeatherDataList![0].cityName + "   "
            weatherContent += String(cityWeatherDataList![0].currentTemp) + "   "
            weatherContent += String(cityWeatherDataList![0].condition)
            //cell1.cityNameLabel.text = weatherContent
            cell1.textLabel!.text = weatherContent
            cell = cell1
            
        case tableView22:
            cell2 = tableView22.dequeueReusableCell(withIdentifier: "cell2") as! UITableViewCell
            weatherContent = cityWeatherDataList![1].cityName + "   "
            weatherContent += String(cityWeatherDataList![1].currentTemp) + "   "
            weatherContent += String(cityWeatherDataList![1].condition)
            //cell2.cityNameLabel.text = weatherContent
            cell2.textLabel!.text = weatherContent
            cell = cell2
            
        case tableView33:
            cell3 = tableView33.dequeueReusableCell(withIdentifier: "cell3") as! UITableViewCell
            weatherContent = cityWeatherDataList![2].cityName + "   "
            weatherContent += String(cityWeatherDataList![2].currentTemp) + "   "
            weatherContent += String(cityWeatherDataList![2].condition)
            //cell3.cityNameLabel.text = weatherContent
            cell3.textLabel!.text = weatherContent
            cell = cell3
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.backgroundColor = .clear
        cell.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
    }
    
    func dynamicScroll() {
        let tableW:CGFloat = self.dynamicScrollView.frame.size.width;
        let tableH:CGFloat = self.dynamicScrollView.frame.size.height;
        var tableY:CGFloat = 0;
        var totalCount:NSInteger = 3;//只有三列；
        
        var tableView1:UITableView = UITableView();
        var tableView2:UITableView = UITableView();
        var tableView3:UITableView = UITableView();
        
        tableView11.frame = CGRect(CGFloat(0) * tableW, tableY, tableW, tableH);
        tableView22.frame = CGRect(CGFloat(1) * tableW, tableY, tableW, tableH);
        tableView33.frame = CGRect(CGFloat(2) * tableW, tableY, tableW, tableH);
        
        dynamicScrollView.addSubview(tableView11);
        dynamicScrollView.addSubview(tableView22);
        dynamicScrollView.addSubview(tableView33);
        
        let contentW:CGFloat = tableW * CGFloat(totalCount);//这个表示整个ScrollView的长度；
        dynamicScrollView.contentSize = CGSize(contentW, 0);
        dynamicScrollView.isPagingEnabled = true;
        dynamicScrollView.delegate = self;
        
    }
    
    func  initCustomTableView(){    //初始化动态信息中的TableView
        
        tableView11.register(UITableViewCell.self, forCellReuseIdentifier:"cell1")
        tableView22.register(UITableViewCell.self, forCellReuseIdentifier:"cell2")
        tableView33.register(UITableViewCell.self, forCellReuseIdentifier:"cell3")
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}
