//
//  ViewController.h
//  EmployeeDirectory
//
//  Created by Hussain on 5/5/16.
//  Copyright (c) 2016 HussainCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface EDMasterViewController : UITableViewController<NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsEmpController;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsCompController;

@end

