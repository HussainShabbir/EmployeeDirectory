//
//  EMPLComInfoVwController.m
//  EmployeeList
//
//  Created by Hussain on 5/1/16.
//  Copyright © 2016 com.hussainCode. All rights reserved.
//

#import "EDComDetailVwController.h"
#import "EDCompanyModel.h"

@interface EDComDetailVwController ()
@property (nonatomic,strong)EDCompanyModel *compModel;
@end

@implementation EDComDetailVwController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.compModel = (EDCompanyModel*)self.detail;
    self.imageVw.image = [UIImage imageWithData:self.compModel.image];
    self.navigationItem.title = self.compModel.companyName;
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
            cell.textLabel.text = @"Company Id";
            cell.detailTextLabel.text = self.compModel.companyId;
            break;
            
        case 1:
            cell.textLabel.text = @"Company Name";
            cell.detailTextLabel.text = self.compModel.companyName;
            break;
            
        case 2:
            cell.textLabel.text = @"Website";
            cell.detailTextLabel.text = self.compModel.website;
            break;
            
        case 3:
            cell.textLabel.text = @"Description";
            cell.detailTextLabel.text = self.compModel.industry;
            break;
            
        case 4:
            cell.textLabel.text = @"Revenue";
            cell.detailTextLabel.text = self.compModel.revenue;
            break;
            
        case 5:
            cell.textLabel.text = @"Phone No";
            cell.detailTextLabel.text = self.compModel.phoneNo;
            break;
            
        case 6:
            cell.textLabel.text = @"Address";
            cell.detailTextLabel.text = self.compModel.address;
            break;
            
        case 7:
            cell.textLabel.text = @"Linkedin Url";
            cell.detailTextLabel.text = self.compModel.linkedinUrl;
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


@end
