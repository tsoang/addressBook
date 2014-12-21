//
//  AddressBookTests.m
//  AddressBookTests
//
//  Created by Steve Chung on 2014-12-16.
//  Copyright (c) 2014 deeway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ContactListTVC.h"



@interface ContactListTVC (Testing)

@property (strong, nonatomic) NSArray * sortedContacts;

- (NSArray*)sortContacts:(NSArray*)contacts;

@end



@interface AddressBookTests : XCTestCase

@property (strong, nonatomic) ContactListTVC *aContactListTVC;
@property (strong, nonatomic) NSArray *inputContacts;
@property (strong, nonatomic) NSArray *expectedContacts;

@end



@implementation AddressBookTests
/******************************
 * An instance method setup for all the test methods in this class.
 * It is executed before every test method.
 ******************************/
- (void)setUp {
    [super setUp];
    // Create a ContactListTVC object.
    self.aContactListTVC = [[ContactListTVC alloc] init];
    
    // Create an input contact array.
    self.inputContacts = @[@{@"user": @{@"name": @{@"first": @"alan", @"last": @"post"}}},
                           @{@"user": @{@"name": @{@"first": @"steve", @"last": @"page"}}},
                           @{@"user": @{@"name": @{@"first": @"angie", @"last": @"dell"}}},
                           @{@"user": @{@"name": @{@"first": @"steve", @"last": @"david"}}},
                           @{@"user": @{@"name": @{@"first": @"john", @"last": @"chan"}}},
                           @{@"user": @{@"name": @{@"first": @"tim", @"last": @"duncan"}}},
                           @{@"user": @{@"name": @{@"first": @"tony", @"last": @"parker"}}},
                           @{@"user": @{@"name": @{@"first": @"matthew", @"last": @"mcconaughey"}}},
                           @{@"user": @{@"name": @{@"first": @"optimus", @"last": @"prime"}}},
                           @{@"user": @{@"name": @{@"first": @"peter", @"last": @"pan"}}},
                           @{@"user": @{@"name": @{@"first": @"billy", @"last": @"beane"}}},
                           @{@"user": @{@"name": @{@"first": @"jon", @"last": @"snow"}}}
                           ];
    
    // A two dimensional array sorted by alphabets. This is the expected output for the inputContacts.
    self.expectedContacts = @[@[@{@"user": @{@"name": @{@"first": @"alan", @"last": @"post"}}}, @{@"user": @{@"name": @{@"first": @"angie", @"last": @"dell"}}}],
                              @[@{@"user": @{@"name": @{@"first": @"billy", @"last": @"beane"}}}],
                              @[@{@"user": @{@"name": @{@"first": @"john", @"last": @"chan"}}}, @{@"user": @{@"name": @{@"first": @"jon", @"last": @"snow"}}}],
                              @[@{@"user": @{@"name": @{@"first": @"matthew", @"last": @"mcconaughey"}}}],
                              @[@{@"user": @{@"name": @{@"first": @"optimus", @"last": @"prime"}}}],
                              @[@{@"user": @{@"name": @{@"first": @"peter", @"last": @"pan"}}}],
                              @[@{@"user": @{@"name": @{@"first": @"steve", @"last": @"david"}}}, @{@"user": @{@"name": @{@"first": @"steve", @"last": @"page"}}}],
                              @[@{@"user": @{@"name": @{@"first": @"tim", @"last": @"duncan"}}}, @{@"user": @{@"name": @{@"first": @"tony", @"last": @"parker"}}}]
                              ];
}

/******************************
 * An instance method tearDown for all the test methods in this class.
 * It is executed before every test method.
 ******************************/
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.aContactListTVC = nil;
    self.inputContacts = nil;
    self.expectedContacts = nil;
}

/******************************
 * A test method for the [ContactListTVC sortContacts:] method. 
 * The return array from the method should equal to the expectedContacts.
 ******************************/
- (void)testSortContacts {
    // Compute
    NSArray *outputContacts = [self.aContactListTVC sortContacts:self.inputContacts];
    
    // convert the arrays into strings so we can compare.
    NSString *output = [outputContacts description];
    NSString *expected = [self.expectedContacts description];
    
    // The outputContacts should equal to the expectedContacts
    XCTAssert([output isEqualToString:expected]);
}

/******************************
 * A test method for the [ContactListTVC sectionIndexTitlesForTableView:] method.
 * The return array from the method should equal to the expectedSectionTitles.
 ******************************/
- (void)testSectionIndexTitlesForTableView {
    // Setup up
    NSArray *expectedSectionTitles = @[@"a", @"b", @"j", @"m", @"o", @"p", @"s", @"t"];
    self.aContactListTVC.sortedContacts = self.expectedContacts;
    
    // Compute.
    NSArray *sections = [self.aContactListTVC sectionIndexTitlesForTableView:self.aContactListTVC.tableView];
    
    // The sections array should equal to the expectedSectionTitles
    XCTAssert([sections isEqualToArray:expectedSectionTitles]);
}

/******************************
 * A performance test for the [ContactListTVC sortContacts:] method.
 * Baselines are stored per-device-configuration, so you can have the same test executing on several 
 * different devices and have each maintain a different baseline dependent upon the specific 
 * configuration’s processor speed, memory, and so forth.
 *
 * Note: Performance measuring tests always report failure on the first run and until a baseline 
 * value is set on a particular device configuration.
 ******************************/
- (void)testSortContactsPerformance {
    // This is an example of a performance test case.
    [self measureBlock:^{
        [self.aContactListTVC sortContacts:self.inputContacts];
    }];
}

@end
