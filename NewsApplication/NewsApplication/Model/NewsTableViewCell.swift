import UIKit
class NewsTableViewCell: UITableViewCell {
    //MARK: Labels and ImageView
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //MARK: Design of labels
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        subTitleLabel.numberOfLines = 0
        subTitleLabel.font = .systemFont(ofSize: 17, weight: .light)
        urlImage.clipsToBounds = true
        urlImage.contentMode = .scaleAspectFill
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //MARK: Contraints for UI
        titleLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 190, height: 70)
        subTitleLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width - 190, height: contentView.frame.size.height/2)
        urlImage.frame = CGRect(x: contentView.frame.size.width-170, y: 5, width: 140, height: contentView.frame.size.height - 10)
        
    }
}
