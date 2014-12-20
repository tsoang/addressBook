//
//  AddressBookManager.h
//  AddressBook
//
//  Created by Steve Chung on 2014-12-16.
//  Copyright (c) 2014 deeway. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AddressBookManager : NSObject

+ (AddressBookManager*)sharedInstance;

- (void)retrieveContactsWithCompletionHandler:(void (^)(NSArray *contacts, NSError *connectionError))handler;

@end
