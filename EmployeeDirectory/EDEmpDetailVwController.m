//
//  EMPLInfoVwController.m
//  EmployeeList
//
//  Created by Hussain on 5/1/16.
//  Copyright © 2016 com.hussainCode. All rights reserved.
//

#import "EDEmpDetailVwController.h"
#import "EDEmployeeModel.h"

@interface EDEmpDetailVwController ()
@property (nonatomic,strong)EDEmployeeModel *empModel;
@end

@implementation EDEmpDetailVwController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.empModel = (EDEmployeeModel*)self.detail;
    // Get a list of all properties in the class.
    self.imageVw.image = [UIImage imageWithData:self.empModel.image];
    self.name.text = self.empModel.fullName;
    self.designation.text = self.empModel.designation;
    self.address.text = self.empModel.address;
    self.navigationItem.title = self.empModel.fullName;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        
        case 0:
            cell.textLabel.text = @"EmployeeID";
            cell.detailTextLabel.text = self.empModel.employeeId;
            break;
            
        case 1:
            cell.textLabel.text = @"Designation";
            cell.detailTextLabel.text = self.empModel.designation;
            break;
            
        case 2:
            cell.textLabel.text = @"First Name";
            cell.detailTextLabel.text = self.empModel.firstName;
            break;
            
        case 3:
            cell.textLabel.text = @"Last Name";
            cell.detailTextLabel.text = self.empModel.lastName;
            break;
            
        case 4:
            cell.textLabel.text = @"Email ID";
            cell.detailTextLabel.text = self.empModel.email;
            break;
        
        case 5:
            cell.textLabel.text = @"Cell Phone";
            cell.detailTextLabel.text = self.empModel.cellNo;
            break;
            
        case 6:
            cell.textLabel.text = @"Address";
            cell.detailTextLabel.text = self.empModel.address;
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

@end
