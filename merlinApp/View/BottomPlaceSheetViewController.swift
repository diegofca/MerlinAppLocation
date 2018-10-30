//
//  BottomSheetViewController.swift
//  merlinApp
//
//  Created by Devp.ios on 22/10/18.
//  Copyright © 2018 Devp.ios. All rights reserved.
//

import UIKit
import GoogleMaps

enum SheetLevel{
    case top, bottom, middle
}

protocol BottomSheetDelegate {
    func updateBottomSheet(frame: CGRect)
    func sendQuerySearch(textSearch: String)
    func sendMarkMap(mark: GMSMarker)
    func selectedPlace(_ namePlace: String, location: GMSMarker)
    func sendWayLocation(location: GMSMarker)
}

class BottomPlaceSheetViewController: UIViewController, HomeMapVMDelegate {
 
    @IBOutlet var panView: UIView!
    @IBOutlet var loaderListView: UIView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: BottomPlaceSheetVM!

    var lastY: CGFloat = 0
    var pan: UIPanGestureRecognizer!
    
    var bottomSheetDelegate: BottomSheetDelegate?
    var parentView: UIView!
    
    var initalFrame: CGRect!
    let topY: CGFloat = 140
    var middleY: CGFloat = 300
    var bottomY: CGFloat = 680
    let bottomOffset: CGFloat = 70 //64
    var lastLevel: SheetLevel = .bottom
    var disableTableScroll = false
    var didTapDeleteKey = false
    
    var listItems: [Place] = []
    var headerItems: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BottomPlaceSheetVM()
        setGestures()
        setSearchbar()
    }
    
    func setGestures(){
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        self.panView.addGestureRecognizer(pan)
        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
    }
    
    func setSearchbar(){
        self.searchBar.delegate = self
        self.searchBar.placeholder = NSLocalizedString("bottomplacesheet.searchbar.placeholder", comment: "")
    }
    
    // viewParent delegate  -----------
    func getVM() -> HomeMapVMDelegate {
        viewModel.delegate = self
        return viewModel.delegate!
    }
    
    func updateList(_ places: [Place]) {
        stateEmptyView(true)
        self.listItems = places
        self.tableView.reloadData()
        stateLoadList(true)
    }
    
    func errorUpdateList() {
        stateEmptyView(true)
        stateLoadList(true)
    }
    
    func emptyList() {
        stateLoadList(true)
        stateEmptyView(false)
        self.listItems.removeAll()
        self.tableView.reloadData()
        self.viewModel?.emptyLottieAnim( emptyView! ) { (anim) in anim.play() }
    }
    
    func stateLoadList(_ act: Bool){
        self.loaderListView.isHidden = act
        self.viewModel.clearAnimViews(parent: loaderListView)
    }
    
    func stateEmptyView(_ act: Bool){
        self.emptyView.isHidden = act
        self.viewModel.clearAnimViews(parent: emptyView)
    }
    
    //------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let window = UIApplication.shared.keyWindow
        
        if #available(iOS 12.0, *) {
           self.viewModel.bottomPadding = (window?.safeAreaInsets.bottom)!
        }
        
        self.initalFrame = UIScreen.main.bounds
        self.middleY = initalFrame.height * 0.6
        self.bottomY = initalFrame.height - bottomOffset - self.viewModel.bottomPadding
        self.lastY = self.middleY
        
        bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.bottomY))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else {return}
        if (self.parentView.frame.minY > topY){
            self.tableView.contentOffset.y = 0
        }
    }
    
    
    //this stops unintended tableview scrolling while animating to top
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == tableView else {return}
        
        if disableTableScroll{
            targetContentOffset.pointee = scrollView.contentOffset
            disableTableScroll = false
        }
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        
        if self.tableView.contentOffset.y > 0{return}
        
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        
        let dy = recognizer.translation(in: self.parentView).y
        switch recognizer.state {
        case .changed:
            if self.tableView.contentOffset.y <= 0{
                let maxY = max(topY, lastY + dy)
                let y = min(bottomY, maxY)
                bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: y))
            }
            
            if self.parentView.frame.minY > topY{
                self.tableView.contentOffset.y = 0
            }
        case .failed, .ended, .cancelled:
            self.panView.isUserInteractionEnabled = false
            
            self.disableTableScroll = self.lastLevel != .top
            
            self.lastY = self.parentView.frame.minY
            self.lastLevel = self.nextLevel(recognizer: recognizer)
            self.changeAnimStateLevel()
        default:
            break
        }
    }
    
    func changeAnimStateLevel( ) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseOut, animations: {
            switch self.lastLevel{
            case .top:
                self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.topY))
                self.tableView.contentInset.bottom = self.topY + 50
            case .middle:
                self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.middleY))
            case .bottom:
                self.tableView.contentOffset.y = 0
                self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.bottomY))
            }
        }) { (_) in
            self.panView.isUserInteractionEnabled = true
            self.lastY = self.parentView.frame.minY
        }
    }
    
    func setSheetState(_ state: SheetLevel){
        lastLevel = state
        if self.tableView.contentOffset.y <= 0{
            let maxY = max(topY, lastY )
            let y = min(bottomY, maxY)
            bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: y))
        }
        
       self.changeAnimStateLevel()
       self.disableTableScroll = self.lastLevel != .top
    }
    
    func nextLevel(recognizer: UIPanGestureRecognizer) -> SheetLevel {
        let y = self.lastY
        let velY = recognizer.velocity(in: self.view).y
        if velY < -200{
            return y > middleY ? .middle : .top
        }else if velY > 200{
            return y < (middleY + 1) ? .middle : .bottom
        }else{
            if y > middleY {
                return (y - middleY) < (bottomY - y) ? .middle : .bottom
            }else{
                return (y - topY) < (middleY - y) ? .top : .middle
            }
        }
    }
}

extension BottomPlaceSheetViewController: UISearchBarDelegate{

    //Buttons cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        if (searchBar == self.searchBar) {
            searchBar.endEditing(true)
            searchBar.showsCancelButton = false
            setSheetState( .bottom)
        }
    }
    
    // button search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        stateLoadList(false)
        stateEmptyView(true)
        self.viewModel?.loadLottieAnim( loaderListView! ) { (anim) in anim.play() }
        self.bottomSheetDelegate?.sendQuerySearch(textSearch: searchBar.text!)
        setSheetState( .middle)
    }
    
    // On actived
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        if (searchBar == self.searchBar) {
            searchBar.showsCancelButton = true
            setSheetState( .top)
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        didTapDeleteKey = text.isEmpty
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !didTapDeleteKey && searchText.isEmpty {
            setSheetState( .middle)
        }
        didTapDeleteKey = false
    }
    
}

extension BottomPlaceSheetViewController: UITableViewDelegate, UITableViewDataSource{
    // LENG LIST
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    // SELECT ITEM
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.tableView.contentOffset.y = 0
        let place = listItems[indexPath.row]
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        bottomSheetDelegate?.selectedPlace( place.name, location: place.location.mark)
        setSheetState( .bottom)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetCell", for: indexPath) as! BottomSheetCell
        
        let place = listItems[indexPath.row]
        let mark = cell.viewModel.getMark( place.name, place.location.address, place.location.lat, place.location.long )
        let model = PlaceCell(
            idCell: place.id,
            image: nil,
            name: place.name!,
            location: place.location.address,
            distance: String(place.location.distance)
        )
        
        cell.configure(model: model)
        cell.wayLocationBtn.tag = indexPath.row
        
        cell.wayLocationBtn.addTarget(self , action: #selector(clickWaylocation), for: .touchUpInside)
        place.location.mark = mark
        bottomSheetDelegate?.sendMarkMap(mark: mark)
        listItems[indexPath.row] = viewModel.getImage( cell, place )
        return cell
    }
    
    @objc func clickWaylocation(_ btn: UIButton){
       let place = listItems[btn.tag]
       bottomSheetDelegate?.sendWayLocation(location: place.location.mark)
    }
    
}

extension BottomPlaceSheetViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
