//
//  EMPLInfoVwController.h
//  EmployeeList
//
//  Created by Hussain on 5/1/16.
//  Copyright © 2016 com.hussainCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDEmpDetailVwController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) id detail;

@property (nonatomic,weak) IBOutlet UIImageView *imageVw;
@property (nonatomic,weak) IBOutlet UILabel *name;
@property (nonatomic,weak) IBOutlet UILabel *designation;
@property (nonatomic,weak) IBOutlet UILabel *address;

@end
