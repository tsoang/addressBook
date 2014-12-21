//
//  AddressBookManager.m
//  AddressBook
//
//  Created by Steve Chung on 2014-12-16.
//  Copyright (c) 2014 deeway. All rights reserved.
//

#import "AddressBookManager.h"



#pragma mark Constants
static AddressBookManager *sharedInstance_ = nil;

static NSString * const kServerURLBase = @"http://api.randomuser.me/";
static NSString * const kServerParamKey = @"ABCD-1234-EFGH-5678";
static NSInteger kNumberOfContactsToRetrieve = 50;
static NSInteger kHTTPStatusCodeOK = 200;
static NSString * const kErrorDomainServer = @"Server";


#pragma mark - Enumerations



#pragma mark -
@interface AddressBookManager ()
@end



#pragma mark -
/*****************************
 * A singleton class to manage the address book retrieval and parsing of the data.
 *****************************/
@implementation AddressBookManager
#pragma mark - Class Methods
+ (AddressBookManager*)sharedInstance {
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        sharedInstance_ = [[self alloc] init];
    });
    
    return sharedInstance_;
}



#pragma mark - Properties



#pragma mark - Constructors
- (id)init {
    // Stop the program if this class is being initialized again.
    NSAssert(!sharedInstance_, @"%@ is a singleton and it has been initialized. It is being init again which it should NOT be.", NSStringFromClass([self class]));
    
	self = [super init];
	if (self == nil) {
		return nil;
	}
    
    [self init_];
	return self;
}



#pragma mark - Overridden Methods



#pragma mark - Public Methods
/*****************************
 * Download the address book data and return an array of contacts in the completion handler block.
 * @handler A completion handler blcok to execute when it returns the data to the caller. 
 *          If it retrieves the data successfully, it returns an array in the variable contacts. 
 *          If it fails to retrieve the data, it returns an error in the variable connectionError.
 *****************************/
- (void)retrieveContactsWithCompletionHandler:(void (^)(NSArray *contacts, NSError *connectionError))handler {
    
    // Define the request completion handler for [NSURLConnection sendAsynchronousRequest:queue:completionHandler:]
    void (^requestHandler)(NSURLResponse*, NSData*, NSError*) = ^void(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // Check to see if there's a connection error.
        if (connectionError) {
            handler(nil, connectionError);
        } else {
            // Check for the response status code.
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            if (httpResponse.statusCode == kHTTPStatusCodeOK) {
                NSError *aJSONError;
                
                // parse the JSON data to an object.
                id aJSONObj = [NSJSONSerialization JSONObjectWithData:data
                                                              options:0
                                                                error:&aJSONError];
                
                // Check for JSON parsing error.
                if (aJSONError) {
                    handler(nil, aJSONError);
                } else {
                    // Check for the object structure. It should be an NSDictionary at the root.
                    if ([aJSONObj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *resultsDict = (NSDictionary*)aJSONObj;
                        NSArray *results = resultsDict[@"results"];
                        
                        // Check to see if the dictionary contain the "results" key.
                        if (results == nil) {
                            NSString *description = @"Server's response does not contant the key 'results'.";
                            if (resultsDict[@"error"]) {
                                description = resultsDict[@"error"];
                            }
                            
                            NSError *error = [NSError errorWithDomain:kErrorDomainServer
                                                                 code:-1
                                                             userInfo:@{NSLocalizedDescriptionKey:description}];
                            handler(nil, error);
                        } else {    // Got the results successfully.
                            handler(results, nil);
                        }
                    } else {    // The object returned is not an NSDictionary.
                        NSString *description = @"Server's response is not in a correct format.";
                        NSError *error = [NSError errorWithDomain:kErrorDomainServer
                                                             code:-2
                                                         userInfo:@{NSLocalizedDescriptionKey:description}];
                        handler(nil, error);
                    }
                }
            } else {    // HTTP status code is not 200 (OK)
                NSString *description = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSError *error = [NSError errorWithDomain:kErrorDomainServer
                                                     code:httpResponse.statusCode
                                                 userInfo:@{NSLocalizedDescriptionKey:description}];
                handler(nil, error);
            }
        }
    };
    
    // Send the request to get the contacts.
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[self getURLWithNumberOfContacts:kNumberOfContactsToRetrieve]]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:requestHandler];
}



#pragma mark - Private Methods
- (void)init_ {
}

/*****************************
 * Create and return an NSURL to the server with the given number of contacts and server parameter key.
 * @numberOfContacts The number of contacts to put in the URL parameter.
 *****************************/
- (NSURL*)getURLWithNumberOfContacts:(NSInteger)numberOfContacts {
    NSString *requestURLString = [NSString stringWithFormat:@"%@?results=%ld&key=%@", kServerURLBase, (long)numberOfContacts, kServerParamKey];
    return [NSURL URLWithString:requestURLString];
}


#pragma mark - Protocol



@end
