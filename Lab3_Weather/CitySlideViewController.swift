//
//  CitySlideViewController.swift
//  Lab3_Weather
//
//  Created by Jerry Lee on 12/8/17.
//  Copyright © 2017 Jerry Lee. All rights reserved.
//

import UIKit


class CitySlideViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    //var cityWeatherDataList : [WeatherDataModel]?
    lazy var listCount = cityDataDictionary.count
    lazy var tableViewList = [UITableView]()
    lazy var cellList = [UITableViewCell]()
    var weatherList = [Int: [String]]()
    
    @IBOutlet weak var dynamicScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(375))
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        for i in 0...listCount-1 {
            
            let cellTemp = UITableViewCell()
            let tableTemp = UITableView()
            cellList.insert(cellTemp, at: i)
            tableViewList.insert(tableTemp, at: i)
        }
        
        for eachView in tableViewList{
            eachView.delegate = self
            eachView.dataSource = self
        }
        pageControl.numberOfPages = listCount
        loadDataToStringList()
        dynamicScroll()
        initCustomTableView()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9  //返回TableView的Cell数量，可以动态设置；
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        var i = 0
        for tableItem in tableViewList {
            if tableView === tableItem {
                cellList[i] = tableItem.dequeueReusableCell(withIdentifier: "cell\(i)", for: indexPath as IndexPath)
                cellList[i].textLabel!.text = weatherList[i]![indexPath.row]
                cell = cellList[i]
            } else {
                i += 1
            }
        }
        return cell
        
    }
    func loadDataToStringList(){

        
        for i in 0...listCount-1{
            var weatherArray = [String]()
            weatherArray.append("\(cityDataDictionary[cityIndexDictionary[i]!]!.cityName)  \(cityDataDictionary[cityIndexDictionary[i]!]!.localtime)")
            for j in [0,2,4,6]{
                weatherArray.append("Day1: \(cityDataDictionary[cityIndexDictionary[i]!]!.oneDayWeather[j]) \(cityDataDictionary[cityIndexDictionary[i]!]!.oneDayTemp[j]) \(cityDataDictionary[cityIndexDictionary[i]!]!.oneDayWeather[j+1]) \(cityDataDictionary[cityIndexDictionary[i]!]!.oneDayTemp[j+1])")
            }
            for k in 0...3{
                weatherArray.append("Day\(k+2):\(cityDataDictionary[cityIndexDictionary[i]!]!.fourDayWeather[k]) \(cityDataDictionary[cityIndexDictionary[i]!]!.fourDayTempLow[k]) \(cityDataDictionary[cityIndexDictionary[i]!]!.fourDayTempHigh[k])")
            }
            
            weatherList[i] = weatherArray
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
    
    func dynamicScroll() {
        let tableW:CGFloat = self.dynamicScrollView.frame.size.width;
        let tableH:CGFloat = self.dynamicScrollView.frame.size.height;
        let tableY:CGFloat = 0;
        let totalCount: NSInteger = listCount;//只有三列；
        
        var i = 0
        for eachView in tableViewList{
            eachView.frame = CGRect(CGFloat(i) * tableW, tableY, tableW, tableH);
            i += 1
            dynamicScrollView.addSubview(eachView)
        }

        let contentW:CGFloat = tableW * CGFloat(totalCount);//这个表示整个ScrollView的长度；
        dynamicScrollView.contentSize = CGSize(contentW, 0);
        dynamicScrollView.isPagingEnabled = true;
        dynamicScrollView.delegate = self;
        
    }
    
    func  initCustomTableView(){    //初始化动态信息中的TableView
        var i = 0
        for eachView in tableViewList{
            eachView.register(UITableViewCell.self, forCellReuseIdentifier:"cell\(i)")
            i += 1
        }

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
