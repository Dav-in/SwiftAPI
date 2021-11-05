//
//  ViewController.swift
//  SimpleAPICall
//
//  Created by Davin Henrik on 11/5/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var tableView : UITableView?
    
    var storedData : [DataModel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView = UITableView(frame: self.view.frame)
        self.view.addSubview(self.tableView!)
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.getAPIData()
        
    }

    func getAPIData () {
        let url = URL(string: "https://www.gamerpower.com/api/giveaways")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error", error)
                return
            }
            
            guard let httpRes = response as? HTTPURLResponse, (200...299).contains(httpRes.statusCode) else {
                print("Error")
                return
            }
            
            if let data = data {
                let dataResponse = try? JSONDecoder().decode([DataModel].self, from: data)
                self.storedData = dataResponse ?? []
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
                print(dataResponse?.first?.title)
            
            }
        }
        
        task.resume()
        
    }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return storedData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "cell"))!
            cell.textLabel?.text = self.storedData[indexPath.row].title
            
            return cell
        }
    
}


struct DataModel : Codable {
    let title : String
    let worth : String
    
    
}
