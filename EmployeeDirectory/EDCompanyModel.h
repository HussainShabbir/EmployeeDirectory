//
//  EDCompanyModel.h
//  EmployeeDirectory
//
//  Created by dinakar pulakhandam on 5/5/16.
//  Copyright (c) 2016 HussainCode. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface EDCompanyModel : NSManagedObject

@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *companyId;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSNumber *empCount;
@property (nonatomic,strong) NSString *industry;
@property (nonatomic,strong) NSString *linkedinUrl;
@property (nonatomic,strong) NSString *phoneNo;
@property (nonatomic,strong) NSString *revenue;
@property (nonatomic,strong) NSString *website;
@property (nonatomic,strong) NSData *image;
@property (nonatomic,strong) NSSet *employee;


@end
