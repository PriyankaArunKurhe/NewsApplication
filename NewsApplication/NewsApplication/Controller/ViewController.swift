import UIKit
import SafariServices
class ViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    var newsDetails = [NewsModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
        self.newsTableView.dataSource = self
        self.newsTableView.delegate = self
        fetchData()
    }
    //MARK: URL Session Method
    private func fetchData() {
        let urlString = "https://newsapi.org/v2/everything?q=Apple&from=2022-06-19&sortBy=popularity&apiKey=a550202068f94d8eb3561d9f734e9624"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) {[weak self] data, response, error in
            if error == nil {
                guard let data = data else {
                    print("Data is nil")
                    return
                }
                do {
                    guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        return
                    }
                    guard let jsonObject = jsonObject["articles"] as? [[String: Any]] else {
                        print("Json not found")
                        return
                    }
                    for dictionary in jsonObject {
                        let eachDictionary = dictionary as? [String: Any]
                        let postTitle = eachDictionary!["title"] as? String ?? ""
                        let postSubtitle = eachDictionary!["description"] as? String ?? ""
                        let postURL = eachDictionary!["url"] as? String ?? ""
                        let postURLImage = eachDictionary!["urlToImage"] as? String ?? ""
                        let news = NewsModel(title: postTitle, description: postSubtitle, url: postURL, urlToImage: postURLImage)
                        self?.newsDetails.append(news)
                    }
                    DispatchQueue.main.async {
                        self?.newsTableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
        dataTask.resume()
        
    }
}
//MARK: DataSource Protocol
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.newsTableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        let newsRecord = newsDetails[indexPath.row]
        cell.titleLabel.text = newsRecord.title
        cell.subTitleLabel.text = newsRecord.description
        let imageURL = URL(string: newsRecord.urlToImage!)
        cell.urlImage.downloadImage(from: imageURL!)
        return cell
    }
}
//MARK: Delegate Protocol
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = newsDetails[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}
//MARK: ImageView
extension UIImageView {
    func downloadImage(from url: URL){
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            let image = UIImage(data: data!)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        dataTask.resume()
    }
}
