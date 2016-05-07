//
//  EDEmplModel.h
//  EmployeeDirectory
//
//  Created by dinakar pulakhandam on 5/5/16.
//  Copyright (c) 2016 HussainCode. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface EDEmployeeModel : NSManagedObject

@property (nonatomic,strong) NSString *fullName;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *employeeId;
@property (nonatomic,strong) NSString *designation;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *cellNo;
@property (nonatomic,strong) NSData *image;
@property (nonatomic,strong) NSSet *company;

@end
