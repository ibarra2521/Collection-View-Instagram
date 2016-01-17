//
//  MainCollectionViewController.swift
//  Collection View, Instagram
//
//  Created by Nivardo Ibarra on 12/17/15.
//  Copyright © 2015 Nivardo Ibarra. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController, WebserviceHelperDelegate {

    @IBOutlet weak var txtfSearch: UITextField!
    var images:[Section] = [Section]()
    let connection = WebserviceHelper()
    var contex: NSManagedObjectContext? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connection.delegate = self
        self.contex = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

        let entitySection = NSEntityDescription.entityForName("Section", inManagedObjectContext: self.contex!)
        let request = entitySection?.managedObjectModel.fetchRequestTemplateForName("requestSections")
        do {
            let sectionsEntity = try self.contex?.executeFetchRequest(request!)
            for section in sectionsEntity! {
                let sectionName = section.valueForKey("name") as! String
                let imagesEntity = section.valueForKey("has") as! Set<NSObject>
                var images2 = [UIImage]()
                for imageTemp in imagesEntity {
                    let image = UIImage(data: imageTemp.valueForKey("content") as! NSData)
                    images2.append(image!)
                    print("images2 \(images2)")
                }
                let section = Section(nombre: sectionName, imagesUrl: [])
                    section.images = images2
                self.images.append(section)
            }
        }catch{
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print(images.count)
        return images.count
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
            // Check this
//        return images[section].imagesUrl.count
        return images[section].images!.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCellCollectionViewCell
    
        // Configure the cell
        cell.cllImage.layer.masksToBounds = true
        cell.cllImage.layer.cornerRadius = CGRectGetWidth(cell.cllImage.bounds)/2

        /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let imageData = NSData(contentsOfURL: NSURL(string: self.images[indexPath.section].imagesUrl[indexPath.item])!)
            dispatch_async(dispatch_get_main_queue(), {
                cell.cllImage?.image = UIImage(data: imageData!)
                // new
                // Crear posiblemente una variable global cuando llegue igual al numero de elementos del array de la seccion mandar a llamar createImagesEntity
//                self.images[indexPath.section].images![indexPath.item] = (cell.cllImage?.image)!

            })
        })*/
        cell.cllImage?.image = images[indexPath.section].images![indexPath.item]
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Cell2", forIndexPath: indexPath) as! HeadCollectionReusableView
        cell.lblHead.text = images[indexPath.section].nombre
        return cell
    }
    
    @IBAction func txtfSearch(sender: UITextField) {
        let entitySection = NSEntityDescription.entityForName("Section", inManagedObjectContext: self.contex!)
        let request = entitySection?.managedObjectModel.fetchRequestFromTemplateWithName("requestSection", substitutionVariables: ["name": sender.text!])
        do {
            let entitySection2 = try self.contex?.executeFetchRequest(request!)
            if entitySection2?.count > 0 {
                sender.text = nil
                return
            }
        }catch{
            abort()
        }
        self.connection.loadDataFromWebService(sender.text!)
        sender.resignFirstResponder()
    }

    func webserviceHelper (itemsSection: Section) {
        let newEntitySection = NSEntityDescription.insertNewObjectForEntityForName("Section", inManagedObjectContext: self.contex!)
        newEntitySection.setValue(txtfSearch.text!, forKey: "name")
        newEntitySection.setValue(createImagesEntity(itemsSection.images!), forKey: "has")
        do {
            try self.contex?.save()
        }catch{
            abort()
        }
        images.append(itemsSection)
        self.collectionView!.reloadData()
    }
    
    func createImagesEntity(images: [UIImage]) -> Set<NSObject> {
        var entities = Set<NSObject>()
        for image in images {
            let entityImage = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: self.contex!)
            entityImage.setValue(UIImagePNGRepresentation(image), forKey: "content")
            entities.insert(entityImage)
        }
        return entities
    }

}
