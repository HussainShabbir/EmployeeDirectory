//
//  EDTableViewCell.h
//  EmployeeDirectory
//
//  Created by dinakar pulakhandam on 5/5/16.
//  Copyright (c) 2016 HussainCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *imageVw;
@property (nonatomic,weak) IBOutlet UILabel *customLbl1;
@property (nonatomic,weak) IBOutlet UILabel *customLbl2;
@property (nonatomic,weak) IBOutlet UILabel *customLbl3;

@end
