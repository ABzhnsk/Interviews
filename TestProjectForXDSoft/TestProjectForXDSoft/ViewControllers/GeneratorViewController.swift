//
//  GeneratorViewController.swift
//  TestProjectForXDSoft
//
//  Created by Anna Buzhinskaya on 06.07.2022.
//

import UIKit

class GeneratorViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let reuseIdentifier = "NumbersCollectionViewCell"
    private let apiCaller = APICaller()
        
    private var primeNumbersList = [Int]()
    private var fibonacciNumberList = [Int]()
    private var isSimpleNumbersShow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        apiCaller.fetchPrimeNumbers(pagination: false, completion: { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.primeNumbersList.append(contentsOf: data)
                    self?.collectionView.reloadData()
                }
            case .failure(_):
                break
            }
        })
        
        apiCaller.fetchFibonacciNumbers(pagination: false, completion: { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.fibonacciNumberList.append(contentsOf: data)
                    self?.collectionView.reloadData()
                }
            case .failure(_):
                break
            }
        })
    }
    
    @IBAction func switchNumbers(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            isSimpleNumbersShow = true
            collectionView.reloadData()
        case 1:
            isSimpleNumbersShow = false
            collectionView.reloadData()
        default:
            break
        }
    }
}

extension GeneratorViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if  position > (collectionView.contentSize.height - 100 - scrollView.frame.size.height) {
            guard !apiCaller.isPaginating else { return }
            apiCaller.fetchPrimeNumbers(pagination: true) { [weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.primeNumbersList.append(contentsOf: data)
                        self?.collectionView.reloadData()
                    }
                case .failure(_):
                    break
                }
            }
            
            apiCaller.fetchFibonacciNumbers(pagination: true) { [weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.fibonacciNumberList.append(contentsOf: data)
                        self?.collectionView.reloadData()
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
}

extension GeneratorViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWidth()
        return CGSize(width: width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func calculateWidth() -> CGFloat {
        let estimatedWidth = 160
        let cellMarginSize = 10
        let cellCount = floor(CGFloat(self.view.frame.size.width) / CGFloat(estimatedWidth))
        let width = (self.view.frame.width - CGFloat(cellMarginSize) * (cellCount - 2)) / cellCount
        
        return width
    }
}

extension GeneratorViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSimpleNumbersShow ? primeNumbersList.count : fibonacciNumberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? NumbersCollectionViewCell else {return UICollectionViewCell()}
        
        if isSimpleNumbersShow {
            cell.configure(number: primeNumbersList[indexPath.row])
        } else {
            cell.configure(number: fibonacciNumberList[indexPath.row])
        }
        
        let colorRow = indexPath.row / 2
        if colorRow % 2 == 0 {
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.systemGray3
            } else {
                cell.backgroundColor = UIColor.white
            }
        } else {
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.white
            } else {
                cell.backgroundColor = UIColor.systemGray3
            }
        }
        
        return cell
    }
}
