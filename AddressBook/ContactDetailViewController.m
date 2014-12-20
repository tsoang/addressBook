//
//  ContactDetailViewController.m
//  AddressBook
//
//  Created by Steve Chung on 2014-12-19.
//  Copyright (c) 2014 deeway. All rights reserved.
//

#import "ContactDetailViewController.h"



#pragma mark Constants



#pragma mark - Enumerations



#pragma mark -
@interface ContactDetailViewController ()

// IBOutlet connections on the storeyboard.
@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressZipLabel;

@end



#pragma mark -
@implementation ContactDetailViewController
#pragma mark - Class Methods



#pragma mark - Properties



#pragma mark - Constructors
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
/*
- (id)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    [self init_];
    return self;
}
*/
/*
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder: coder];
    if (self == nil) {
        return nil;
    }
    
    [self init_];
    return self;
}
*/



#pragma mark - Overridden Methods
/*
- (void)loadView {
    // Don't call super in this method.
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - Public Methods



#pragma mark - Private Methods
/***********************
 * Initialize the UI element on the view.
 ***********************/
- (void)initView {
    NSDictionary *user = self.contactDict[@"user"];
    
    // Contact image
    NSURL *imageURL = [NSURL URLWithString:[user valueForKeyPath:@"picture.thumbnail"]];
    self.contactImageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:imageURL]];
    
    // Full name
    self.fullNameLabel.text = [[NSString stringWithFormat:@"%@ %@",
                                [user valueForKeyPath:@"name.first"],
                                [user valueForKeyPath:@"name.last"]]
                               capitalizedString];
    
    // Phone
    self.phoneLabel.text = user[@"phone"];
    
    // Mobile
    self.mobileLabel.text = user[@"cell"];
    
    // Email
    self.emailLabel.text = user[@"email"];
    
    // Address
    NSDictionary *addressDict = user[@"location"];
    self.addressStreetLabel.text = [addressDict[@"street"] capitalizedString];
    self.addressCityLabel.text = [addressDict[@"city"] capitalizedString];
    self.addressStateLabel.text = [addressDict[@"state"] capitalizedString];
    self.addressZipLabel.text = [addressDict[@"zip"] capitalizedString];
}



#pragma mark - Protocol



@end
