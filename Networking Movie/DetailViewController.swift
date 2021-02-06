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
    
    var movieId: Int = 0
    var movieTitle: String = ""
    var movieDescription: String = ""
    var favMovies: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieDetails()
        descriptionLabel.text = movieDescription
        
        let button = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(addToFav))
        self.navigationItem.rightBarButtonItem = button
        
        favMovies = UserDefaults.standard.stringArray(forKey: "Movie") ?? []
        favMovies.forEach({
            if movieTitle == $0{
                button.image = UIImage(systemName: "star.filled")
            }
        })
    }
    @objc func addToFav(){
        favMovies.append(movieTitle)
        UserDefaults.standard.setValue(favMovies, forKey: "Movie")
        
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
                self.playVideo(key)
            }
        }.resume()
    }
    
    func playVideo(_ key: String){
        let url = URLRequest(url: URL(string: "https://www.youtube.com/embed/\(key)?playsinline=1?autoplay=1")!)
        webView.load(url)
        
    }
}
