//
//  ViewController.m
//  EmployeeDirectory
//
//  Created by Hussain on 5/5/16.
//  Copyright (c) 2016 HussainCode. All rights reserved.
//

#import "EDMasterViewController.h"
#import "EDCompanyModel.h"
#import "EDEmployeeModel.h"
#import "EDTableViewCell.h"
#import "EDComDetailVwController.h"
#import "EDEmpDetailVwController.h"
#import "EDAppDelegate.h"

void (^csvBlock)(NSString*);
@interface EDMasterViewController ()
@property (nonatomic,strong) NSArray *tableViewData;
@property (nonatomic,assign) BOOL isCompany; //If set Yes, then it will display Company information otherWise Employee info.
@property (nonatomic,strong) UIPopoverController *popOverController;
@end

@implementation EDMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(doRefresh)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor darkTextColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Sort" style:UIBarButtonItemStylePlain  target:self action:@selector(doSort)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor darkTextColor];
    EDAppDelegate *appDelegate = (EDAppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    csvBlock  =  ^(NSString *fileName){
        NSURL* appSupportDir = [[NSBundle mainBundle]URLForResource:fileName withExtension:@"csv"];
        NSData *lines = [NSData dataWithContentsOfURL:appSupportDir];
        NSString *str = [[NSString alloc]initWithData:lines encoding:NSUTF8StringEncoding];
        NSArray *fields = [str componentsSeparatedByString:@"\n"];
        NSArray *empDictKeys = nil;
        BOOL isColumn = YES;
        if (fields.count){
            for (NSString *obj in fields){
                NSArray *values = [obj componentsSeparatedByString:@","];
                if (!isColumn){
                    NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:empDictKeys];
                    if ([fileName isEqualToString:@"Employee"]){
                        NSString *value = dict[@"EmployeeID"];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"employeeId CONTAINS[CD] %@", value];
                        NSArray *array = [[self.fetchedResultsEmpController fetchedObjects]filteredArrayUsingPredicate:predicate];
                        if (!array.count){
                            [self insertEmployeeObject:dict];
                        }
                    }
                    else{
                        NSString *value = dict[@"Company Id"];
                        NSLog(@"%@",value);
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"companyId CONTAINS[CD] %@", value];
                        NSArray *array = [[self.fetchedResultsCompController fetchedObjects]filteredArrayUsingPredicate:predicate];
                        if (!array.count){
                            [self insertCompanyObject:dict];
                        }
                    }
                }
                else{
                    isColumn = NO;
                    empDictKeys = values;
                }
            }
        }
    };
//    id <NSFetchedResultsSectionInfo> sectionEmpInfo = [self.fetchedResultsEmpController sections][0];
//    id <NSFetchedResultsSectionInfo> sectionComInfo = [self.fetchedResultsCompController sections][0];
//    if ([sectionEmpInfo numberOfObjects] == 0){
//        [self employeeDummyData];
        csvBlock(@"Employee");
//    }
    
//    if ([sectionComInfo numberOfObjects] == 0){
//        [self companyDummyData];
        csvBlock(@"Company");
//    }
    self.tableViewData = (self.isCompany) ? self.fetchedResultsCompController.fetchedObjects : self.fetchedResultsEmpController.fetchedObjects;
    // Do any additional setup after loading the view, typically from a nib.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // In this case the device is an iPad.
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)insertCompanyObject:(id)object
{
    NSManagedObjectContext *context = [self.fetchedResultsCompController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsCompController fetchRequest]entity];
    EDCompanyModel *comModel = [[EDCompanyModel alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
    comModel.companyId = object[@"Company Id"];
    comModel.companyName = object[@"Company Name"];
    comModel.address = object[@"Address"];
    comModel.empCount = @([object[@"EmpCount"]integerValue]);
    comModel.industry = object[@"Industry"];
    comModel.linkedinUrl = object[@"Linkedin Url"];
    comModel.phoneNo = object[@"PhoneNo"];
    comModel.revenue = object[@"Revenue"];
    comModel.website = object[@"Website"];
    comModel.image = UIImagePNGRepresentation([UIImage imageNamed:object[@"Image"]]);
    //Save the context
    NSError *error = nil;
    if (![context save:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(void)insertEmployeeObject:(id)object
{
    NSManagedObjectContext *context = [self.fetchedResultsEmpController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsEmpController fetchRequest]entity];
    EDEmployeeModel *empModel = [[EDEmployeeModel alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
    empModel.fullName = object[@"Full Name"];
    empModel.firstName = object[@"First Name"];
    empModel.lastName = object[@"Last Name"];
    empModel.address = object[@"Address"];
    empModel.employeeId = object[@"EmployeeID"];
    empModel.designation = object[@"Designation"];
    empModel.image = UIImagePNGRepresentation([UIImage imageNamed:object[@"Image"]]);
    empModel.email = object[@"Email"];
    empModel.cellNo = object[@"Cell No"];
    //Save the context
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (NSFetchedResultsController *)fetchedResultsEmpController
{
    if (_fetchedResultsEmpController != nil) {
        return _fetchedResultsEmpController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullName" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsEmpController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsEmpController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsEmpController;
}

- (NSFetchedResultsController *)fetchedResultsCompController{
    if (_fetchedResultsCompController != nil) {
        return _fetchedResultsCompController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"companyName" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsCompController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsCompController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsCompController;
    
}


/*-(void)employeeDummyData{
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"john_Smith.jpeg"]);
    NSData *imageData1 = UIImagePNGRepresentation([UIImage imageNamed:@"rayan_John.jpeg"]);
    NSData *imageData2 = UIImagePNGRepresentation([UIImage imageNamed:@"peter_Mark.jpeg"]);
    NSData *imageData3 = UIImagePNGRepresentation([UIImage imageNamed:@"ricky_Richter.jpeg"]);
    NSData *imageData4 = UIImagePNGRepresentation([UIImage imageNamed:@"peter_Hosey.jpeg"]);
    NSData *imageData5 = UIImagePNGRepresentation([UIImage imageNamed:@"ross_Jerry.jpeg"]);
    NSData *imageData6 = UIImagePNGRepresentation([UIImage imageNamed:@"tim_Coterill.jpeg"]);
    NSData *imageData7 = UIImagePNGRepresentation([UIImage imageNamed:@"richard_Rosa.jpeg"]);
    NSData *imageData8 = UIImagePNGRepresentation([UIImage imageNamed:@"mark_David.jpeg"]);
    NSData *imageData9 = UIImagePNGRepresentation([UIImage imageNamed:@"sheryyl_Rose.jpeg"]);
    
    NSDictionary *empDict = [NSDictionary dictionaryWithObjects:@[@"John Smith",@"John",@"Smith",@"1901 Halford Ave Santa Clara CA 95051",@"123",imageData,@"Sales Manager",@"+1-786123456",@"john_Smith@gmail.com"] forKeys:@[@"fullName",@"firstName",@"lastName",@"address",@"employeeId",@"image",@"designation",@"cellNo",@"email"]];
    
    NSDictionary *empDict1 = [NSDictionary dictionaryWithObjects:@[@"Rayan John",@"Rayan",@"John",@"2006 Klamath Ave Santa Clara CA 95032",@"124",imageData1,@"QA Manager",@"+1-386123456",@"rayan_John@gmail.com"] forKeys:@[@"fullName",@"firstName",@"lastName",@"address",@"employeeId",@"image",@"designation",@"cellNo",@"email"]];
    
    NSDictionary *empDict2 = [NSDictionary dictionaryWithObjects:@[@"Peter Mark",@"Peter",@"Mark",@"2006 Redwood City Belmont CA 95042",@"125",imageData2,@"Product Manager",@"+1-586123456",@"peter_Mark@gmail.com"] forKeys:@[@"fullName",@"firstName",@"lastName",@"address",@"employeeId",@"image",@"designation",@"cellNo",@"email"]];
    
    NSDictionary *empDict3 = [NSDictionary dictionaryWithObjects:@[@"Ricky Ritcher",@"Ricky",@"Ritcher",@"1230 Showers Drive Mountain View CA 94043",@"126",imageData3,@"Software Engineer",@"+1-686123426",@"ricky_Ritcher@gmail.com"] forKeys:@[@"fullName",@"firstName",@"lastName",@"address",@"employeeId",@"image",@"designation",@"cellNo",@"email"]];
    
    NSDictionary *empDict4 = [NSDictionary dictionaryWithObjects:@[@"Peter Hosey",@"Peter",@"Hosey",@"600 Showers Drive Mountain View CA 94041",@"127",imageData4,@"Software Engineer",@"+1-586111456",@"peter_Hosey@gmail.com"] forKeys:@[@"fullName",@"firstName",@"lastName",@"address",@"employeeId",@"image",@"designation",@"cellNo",@"email"]];
    
    NSDictionary *empDict5 = [NSDictionary dictionaryWithObjects:@[@"Ross Jerry",@"Ross",@"Jerry",@"921 Palo Alto San Antonio CA 94053",@"128",imageData5,@"QA Engineer",@"+1-916123456",@"ross_Jerry@gmail.com"] forKeys:@[@"fullName",@"firstName",@"lastName",@"address",@"employeeId",@"image",@"designation",@"cellNo",@"email"]];
    
    NSDictionary *empDict6 = [NSDictionary dictionaryWithObjects:@[@"Tim Coterill",@"Tim",@"Coterill",@"345 Potrero SunnyVale CA 94153",@"129",imageData6,@"Software Engineer",@"+1-216123456",@"tim_Coterill@gmail.com"]  forKeys:@[@"fullName",@"firstName",@"lastName",@"address",@"employeeId",@"image",@"designation",@"cellNo",@"email"]];
    
    NSDictionary *empDict7 = [NSDictionary dictionaryWithObjects:@[@"Richard Rosa",@"Richard",@"Rosa",@"145 Arques Ave CA 94253",@"130",imageData7,@"Software Engineer",@"+1-216122256",@"richard_Rosa@gmail.com"] forKeys:@[@"fullName",@"firstName",@"lastName",@"address",@"employeeId",@"image",@"designation",@"cellNo",@"email"]];
    
    NSDictionary *empDict8 = [NSDictionary dictionaryWithObjects:@[@"Mark David",@"Mark",@"David",@"245 Isabella Ave CA 94053",@"131",imageData8,@"Vice President",@"+1-216122253",@"mark_David@gmail.com"] forKeys:@[@"fullName",@"firstName",@"lastName",@"address",@"employeeId",@"image",@"designation",@"cellNo",@"email"]];
    
    NSDictionary *empDict9 = [NSDictionary dictionaryWithObjects:@[@"Sheryyl Rose",@"Sheryyl",@"Rose",@"45 Milpitas Ave CA 94853",@"132",imageData9,@"Vice President",@"+1-336122253",@"sheryyl_Rose@gmail.com"] forKeys:@[@"fullName",@"firstName",@"lastName",@"address",@"employeeId",@"image",@"designation",@"cellNo",@"email"]];
    
    NSArray *empList = @[empDict,empDict1,empDict2,empDict3,empDict4,empDict5,empDict6,empDict7,empDict8,empDict9];
    for (NSDictionary *empDictionary in empList)
    {
        [self insertEmployeeObject:empDictionary];
    }
}*/

-(void)companyDummyData{
    NSData *appleImgData = UIImagePNGRepresentation([UIImage imageNamed:@"apple.jpeg"]);
    NSData *tcsImgData = UIImagePNGRepresentation([UIImage imageNamed:@"tcs.jpeg"]);
    NSData *wiproImgData = UIImagePNGRepresentation([UIImage imageNamed:@"wipro.jpeg"]);
    NSData *cognizantImgData = UIImagePNGRepresentation([UIImage imageNamed:@"cognizant.jpeg"]);
    NSData *infosysImgData = UIImagePNGRepresentation([UIImage imageNamed:@"infosys.jpeg"]);
    
    NSDictionary *comDict = [NSDictionary dictionaryWithObjects:@[@"201",@"Apple Technologies INC.",@"11 Infinite loop CA 23012",@(2000),@"Apple developed Software and Hardware",@"https://Apple.com",@"+1-786123456",@"250 Billion USD",@"www.apple.com",appleImgData] forKeys:@[@"companyId",@"companyName",@"address",@"empCount",@"industry",@"linkedinUrl",@"phoneNo",@"revenue",@"website",@"image"]];
    
    NSDictionary *comDict1 = [NSDictionary dictionaryWithObjects:@[@"202",@"TCS Consulting Services INC.",@"12 Juhu Mumbai India 2301223",@(100000),@"TCS developed Software and provide services",@"https://tcs.com",@"+91-586123456",@"250 Million USD",@"www.tcs.com",tcsImgData] forKeys:@[@"companyId",@"companyName",@"address",@"empCount",@"industry",@"linkedinUrl",@"phoneNo",@"revenue",@"website",@"image"]];
    
    NSDictionary *comDict2 = [NSDictionary dictionaryWithObjects:@[@"203",@"Wipro Technologies INC.",@"12 Marathalli Bangalore India 2301221",@(95000),@"Wipro developed Software and provide services",@"https://wiprotechnologies.com",@"+91-466123456",@"200 Million USD",@"www.wiprotechnologies.com",wiproImgData] forKeys:@[@"companyId",@"companyName",@"address",@"empCount",@"industry",@"linkedinUrl",@"phoneNo",@"revenue",@"website",@"image"]];
    
    NSDictionary *comDict3 = [NSDictionary dictionaryWithObjects:@[@"204",@"Cognizant Technologies INC.",@"213 RedWood bridge Chicago IL 5301221",@(50000),@"Cognizant developed Software and provide services",@"https://cognizant.com",@"+1-466123456",@"100 Million USD",@"www.cognizant.com",cognizantImgData] forKeys:@[@"companyId",@"companyName",@"address",@"empCount",@"industry",@"linkedinUrl",@"phoneNo",@"revenue",@"website",@"image"]];
    
    NSDictionary *comDict4 = [NSDictionary dictionaryWithObjects:@[@"205",@"Infosys Technologies INC.",@"120 Mysore Road 7301221",@(100000),@"Infosys developed Software and provide services",@"https://Infosys.com",@"+1-466123456",@"250 Million USD",@"www.Infosys.com",infosysImgData] forKeys:@[@"companyId",@"companyName",@"address",@"empCount",@"industry",@"linkedinUrl",@"phoneNo",@"revenue",@"website",@"image"]];
    
    NSArray *companyList = @[comDict,comDict1,comDict2,comDict3,comDict4];
    for (NSDictionary *compDictionary in companyList)
    {
        [self insertCompanyObject:compDictionary];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDTableViewCell *cell = (EDTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isCompany){
        [self performSegueWithIdentifier:@"companyVwIdentifier" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"employeeVwIdentifier" sender:self];
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(EDTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(EDTableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath{
    if (self.tableViewData && self.tableViewData.count > indexPath.row)
    {
        if (self.isCompany){
            EDCompanyModel *comModel = [self.tableViewData objectAtIndex:indexPath.row];
            cell.customLbl1.text = comModel.companyName;
            cell.customLbl2.text = comModel.website;
            cell.customLbl3.text = comModel.industry;
            cell.imageVw.image = [UIImage imageWithData:comModel.image];
        }
        else{
            EDEmployeeModel *empModel = [self.tableViewData objectAtIndex:indexPath.row];
            cell.imageVw.image = [UIImage imageWithData:empModel.image];
            cell.customLbl1.text = empModel.fullName;
            cell.customLbl2.text = empModel.designation;
            cell.customLbl3.text = empModel.address;
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (!self.isCompany)
    {
        EDEmpDetailVwController *destinationVwController = segue.destinationViewController;
        EDEmployeeModel *empModel = self.tableViewData[self.tableView.indexPathForSelectedRow.row];
        destinationVwController.detail = empModel;
    }
    else
    {
        EDComDetailVwController *destinationVwController = segue.destinationViewController;
        EDCompanyModel *companyModel = self.tableViewData[self.tableView.indexPathForSelectedRow.row];
        destinationVwController.detail = companyModel;
    }
}

-(void)doSort{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorted By" message:@"Select the below options:" preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (self.isCompany){
        UIAlertAction *sortedNmAction = [UIAlertAction actionWithTitle:@"Company Name" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self sortByCompany:@"companyName"];
        }];
        [alertController addAction:sortedNmAction];
        
        UIAlertAction *sortedIdAction = [UIAlertAction actionWithTitle:@"Company Id" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self sortByCompany:@"companyId"];
        }];
        [alertController addAction:sortedIdAction];
    }
    
    else{
        UIAlertAction *sortedNmAction = [UIAlertAction actionWithTitle:@"Name" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self sortByEmployee:@"fullName"];
        }];
        [alertController addAction:sortedNmAction];
        
        UIAlertAction *sortedEmlAction = [UIAlertAction actionWithTitle:@"Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self sortByEmployee:@"email"];
        }];
        [alertController addAction:sortedEmlAction];
        
        UIAlertAction *sortedAddrAction = [UIAlertAction actionWithTitle:@"Address" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self sortByEmployee:@"address"];
        }];
        [alertController addAction:sortedAddrAction];
        
        UIAlertAction *sortedDesigntnAction = [UIAlertAction actionWithTitle:@"Designation" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self sortByEmployee:@"designation"];
        }];
        [alertController addAction:sortedDesigntnAction];
        
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:^{
        [self.view endEditing:YES];
    }];
}

-(void)sortByEmployee:(NSString*)sortedOption{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortedOption ascending:YES];
    [[self.fetchedResultsEmpController fetchRequest]setSortDescriptors:@[sortDescriptor]];
    NSError *error;
    if (![[self fetchedResultsEmpController] performFetch:&error]) {
        // Handle you error here
    }
    else{
        self.tableViewData = self.fetchedResultsEmpController.fetchedObjects;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)sortByCompany:(NSString*)sortedOption{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortedOption ascending:YES];
    [[self.fetchedResultsCompController fetchRequest]setSortDescriptors:@[sortDescriptor]];
    NSError *error;
    if (![[self fetchedResultsCompController] performFetch:&error]) {
        // Handle you error here
    }
    else{
        self.tableViewData = self.fetchedResultsCompController.fetchedObjects;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *filterText = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.isCompany){
        self.tableViewData = self.fetchedResultsCompController.fetchedObjects;
        if (filterText.length > 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"companyName CONTAINS[CD] %@", filterText];
            NSArray *array = [[self.fetchedResultsCompController fetchedObjects]filteredArrayUsingPredicate:predicate];
            if (array && array.count > 0)
            {
                self.tableViewData = array;
//                self.errLabel.hidden = YES;
            }
            else
            {
                self.tableViewData = nil;
//                self.errLabel.hidden = NO;
            }
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    else{
        self.tableViewData = self.fetchedResultsEmpController.fetchedObjects;
        if (filterText.length > 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullName CONTAINS[CD] %@", filterText];
            NSArray *array = [[self.fetchedResultsEmpController fetchedObjects]filteredArrayUsingPredicate:predicate];
            if (array && array.count > 0)
            {
                self.tableViewData = array;
//                self.errLabel.hidden = YES;
            }
            else
            {
                self.tableViewData = nil;
//                self.errLabel.hidden = NO;
            }
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    [searchBar resignFirstResponder];
}


-(IBAction)changeSegmentControl:(UISegmentedControl*)sender
{
    //For Company
    if (sender.selectedSegmentIndex){
        self.isCompany = YES;
        self.tableViewData = self.fetchedResultsCompController.fetchedObjects;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    //For Employee
    else{
        self.isCompany = NO;
        self.tableViewData = self.fetchedResultsEmpController.fetchedObjects;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
//    self.errLabel.hidden = YES;
    [self.view endEditing:YES];
}

-(void)doRefresh
{
    if (self.isCompany){
        self.tableViewData = self.fetchedResultsCompController.fetchedObjects;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    else{
        self.tableViewData = self.fetchedResultsEmpController.fetchedObjects;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
//    self.errLabel.hidden = YES;
    [self.view endEditing:YES];
}

@end
