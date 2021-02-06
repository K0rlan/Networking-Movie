//
//  DetailViewController.swift
//  Networking Movie
//
//  Created by Korlan Omarova on 06.02.2021.
//

import UIKit
import WebKit
class DetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var descriptionLabel: UILabel!
    let child = SpinnerViewController()
    var movieId: Int = 0
    var movieTitle: String = ""
    var movieDescription: String = ""
    var favMovies: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        индикатор загрузки в этой странице можно проверить отключив интернет после прогрузки tableView
//        на главной странице
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        getMovieDetails()
        
        
        let button = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(addToFav))
        self.navigationItem.rightBarButtonItem = button
        
        favMovies = UserDefaults.standard.stringArray(forKey: "Movie") ?? []
        favMovies.forEach({
            if movieTitle == $0{
                button.image = UIImage(systemName: "star.fill")
                button.action = #selector(removeFromFav)
            }
        })
    }
    @objc func removeFromFav(_ sender: UIBarButtonItem){
        let farray = favMovies.filter {$0 != movieTitle}
        UserDefaults.standard.setValue(farray, forKey: "Movie")
        sender.image = UIImage(systemName: "star")
        sender.action = #selector(addToFav)
    }
    @objc func addToFav(_ sender: UIBarButtonItem){
        favMovies.append(movieTitle)
        UserDefaults.standard.setValue(favMovies, forKey: "Movie")
        sender.image = UIImage(systemName: "star.fill")
        sender.action = #selector(removeFromFav)
    }
    
    func getMovieDetails() {
        let api_token = "6c78da2cf41529284dc65d510d302bca"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(self.movieId)/videos?api_key=\(api_token)")
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "cache-control" : "no-cache"
        ]
        let session = URLSession.shared
        session.dataTask(with: request){
            rawdata, response, error in
            if let error = error{
                print(#function, "error", error.localizedDescription)
                return
            }
            guard let data = rawdata,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            else{
                print(#function, "error", "\(String(describing: rawdata))")
                return
            }
            
            guard let trailersJSON = json["results"] as? [[String : Any]], let key = trailersJSON[0]["key"]
            as? String else {
                return
            }
           
            DispatchQueue.main.async {
                self.descriptionLabel.text = self.movieDescription
                self.playVideo(key)
                self.child.willMove(toParent: nil)
                self.child.view.removeFromSuperview()
                self.child.removeFromParent()
            }
        }.resume()
    }
    
    func playVideo(_ key: String){
        let url = URLRequest(url: URL(string: "https://www.youtube.com/embed/\(key)?playsinline=1?autoplay=1")!)
        webView.load(url)
        
    }
}
