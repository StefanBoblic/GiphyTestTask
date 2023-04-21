//
//  HomeViewController.swift
//  giphyAppTestTask
//
//  Created by Stefan Boblic on 21.04.2023.
//

import UIKit

class HomeViewController: UIViewController, UINavigationBarDelegate {

    var GIFs = [GiphyData]() {
        didSet {
            print(GIFs.count)
        }
    }
    var pagenation: Pagenation?
    var isRefresh = false

    let customNavigation = NavigationStack()
    let categoryScrollView = CategoryScrollView()
    let gifCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())

    private var viewModel: HomeViewModelProtocol

    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        fetchGIFs()
    }

    private func fetchGIFs(offset: Int = 0) {
        Task {
            do {
                let result = try await viewModel.fetchGIFs(with: offset)

                if let error = result.2 {
                    print(error)
                } else {
                    guard let safeGIFs = result.0 else {
                        print("Optional response")
                        return
                    }

                    self.GIFs.append(contentsOf: safeGIFs)
                    self.pagenation = result.1

                    self.reloaCollectionView()
                }
            } catch {
                debugPrint("Show alert here: \(error.localizedDescription)")
            }
        }
    }


    private func reloaCollectionView() {
        DispatchQueue.main.async {
            self.gifCollectionView.reloadData()
            self.isRefresh = false
        }
    }
}

// MARK: - Layout Configuration
extension HomeViewController {

    private func setupLayout() {
        self.gifCollectionView.backgroundColor = UIColor(named: "backgroundColor")

        setupNavigation()
        setupCategoryScroll()
        setupCollectionView()
        setupConstraints()
    }

    private func setupNavigation() {
        navigationController?.navigationBar.barTintColor = UIColor(named: "backgroundColor")
        navigationController?.navigationBar.backgroundColor = UIColor(named: "backgroundColor")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)

        self.navigationItem.titleView = customNavigation
        self.view.addSubview(customNavigation)
    }

    private func setupCategoryScroll() {
        self.view.addSubview(categoryScrollView)
    }

    private func setupCollectionView() {
        gifCollectionView.delegate = self
        gifCollectionView.dataSource = self
        gifCollectionView.register(GIFCell.self)
        gifCollectionView.collectionViewLayout = GiphyLayout()
        gifCollectionView.showsVerticalScrollIndicator = false

        if let layout = gifCollectionView.collectionViewLayout as? GiphyLayout {
            layout.delegate = self
        }

        self.view.addSubview(gifCollectionView)
    }

    private func setupConstraints() {
        customNavigation.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }

        categoryScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(52)
        }

        gifCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryScrollView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.setGIF(imageUrl: self.GIFs[indexPath.row].images?.original?.url)
        self.present(detailVC, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GIFs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GIFCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setImage(imageUrl: GIFs[indexPath.row].images?.fixedWidth?.url)
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            // Scrolling down
            if scrollView.contentOffset.y >= (self.gifCollectionView.contentSize.height - self.gifCollectionView.bounds.size.height) {
                // Scrolled to bottom of collection view
                guard let totalCount = pagenation?.totalCount, totalCount > self.GIFs.count, !isRefresh else {
                    return
                }

                self.isRefresh = true
                fetchGIFs(offset: self.GIFs.count)
            }
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

// MARK: - MosaicLayoutDelegate
extension HomeViewController: MosaicLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let downSized = GIFs[indexPath.row].images?.fixedWidth,
              let width = downSized.width, let height = downSized.height else {
            return 0
        }

        let downloadedImageWidth = CGFloat(NSString(string: width).floatValue)
        let downloadedImageHeight = CGFloat(NSString(string: height).floatValue)
        let collectionViewHalfWidth = (collectionView.bounds.width / 2)
        let ratio = collectionViewHalfWidth / CGFloat(downloadedImageWidth)

        return downloadedImageHeight * ratio
    }
}
