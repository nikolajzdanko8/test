import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    // MARK: UI
    private var customImage = UIImage()
    private lazy var segmentControl: UISegmentedControl = {
       let segmentControl = UISegmentedControl(items: ["original", "filter"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.layer.borderColor = UIColor.yellow.cgColor
        segmentControl.layer.borderWidth = 2
        segmentControl.layer.cornerRadius = 12
        segmentControl.alpha = 0
        segmentControl.addTarget(self, action: #selector(selectedItemAction), for: .valueChanged)
        return segmentControl
    }()
    
    private lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.alpha = 0
        scrollView.layer.borderColor = UIColor.yellow.cgColor
        scrollView.layer.borderWidth = 2
        scrollView.layer.cornerRadius = 12
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
       let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var addButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.borderColor = UIColor.yellow.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: Lyfecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        layout()
        setupBarButtonItem()
    }
}

// MARK: - Private methods
private extension MainViewController {
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(addButton)
        view.addSubview(scrollView)
        view.addSubview(segmentControl)
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
    
    func layout() {
        addButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(70)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(250)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(view.frame.size.height / 2)
        }
        segmentControl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(140)
            $0.leading.trailing.equalToSuperview().inset(100)
            $0.height.equalTo(70)
        }
    }
    
    func setupBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
                    title: "Save Image",
                    style: .plain,
                    target: self,
                    action: #selector(saveButtonTapped)
                )
    }
    
    func showImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentFrame = imageView.frame
        
        if contentFrame.size.width < boundsSize.width {
            contentFrame.origin.x = (boundsSize.width - contentFrame.size.width) / 2
        } else {
            contentFrame.origin.x = 0
        }
        
        if contentFrame.size.height < boundsSize.height {
            contentFrame.origin.y = (boundsSize.height - contentFrame.size.height) / 2
        } else {
            contentFrame.origin.y = 0
        }
        
        imageView.frame = contentFrame
    }
    
    func grayscaleImage(image: UIImage) -> UIImage {
        let ciImage = CIImage(image: image)
        let grayscale = ciImage?.applyingFilter("CIColorControls", parameters: [ kCIInputSaturationKey: 0.0 ])
        return UIImage(ciImage: grayscale ?? CIImage())
    }
    
    func saveImage()  {
        UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, true, UIScreen.main.scale)
        let offset = scrollView.contentOffset
        
        let getCurrentContext = UIGraphicsGetCurrentContext()
        
        
        getCurrentContext?.translateBy(x: -offset.x, y: -offset.y)
        if let getCurrentContext {
            scrollView.layer.render(in: getCurrentContext)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image ?? UIImage(), nil, nil, nil)
        
        showAlert("Photo saved", message: "You can see it in the album")
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func stateAlpha() {
        segmentControl.alpha = 1
        scrollView.alpha = 1
        addButton.alpha = 0
    }
}

// MARK: - Private action methods
private extension MainViewController {
    
    @objc func addButtonTapped() {
        showImagePicker()
    }
    
    @objc func selectedItemAction() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            if scrollView.alpha != 0 {
                imageView.image = customImage
            }
        case 1:
            if scrollView.alpha != 0 {
                imageView.image = grayscaleImage(image: self.customImage)
            }
        default:
            break
        }
    }
    
    @objc func saveButtonTapped() {
        if scrollView.alpha != 0 {
            saveImage()
        } else {
            showAlert("No photo", message: "Please add photo")
        }
    }
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.customImage = image
            imageView.image = image
            imageView.contentMode = .center
            imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            scrollView.contentSize = image.size
            
            
            let scrollViewFrame = scrollView.frame
            let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
            let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
            let minScale = min(scaleHeight, scaleWidth)
            
            scrollView.minimumZoomScale = minScale
            scrollView.maximumZoomScale = 1
            scrollView.zoomScale = minScale
            
            stateAlpha()
            
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

//MARK: - UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) { centerScrollViewContents() }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }
}
