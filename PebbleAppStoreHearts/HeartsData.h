//
//  HeartsData.h
//  PebbleAppStoreHearts
//
//  Created by Patrick Balestra on 10/02/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeartsData : NSObject

@property (nonatomic, strong) NSString *AppID;
@property (nonatomic, strong) NSString *hearts;
@property (nonatomic, strong) NSString *lastUpdated;

- (void)downloadData;

@end
