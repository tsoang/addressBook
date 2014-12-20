//
//  ContactListTVC.m
//  AddressBook
//
//  Created by Steve Chung on 2014-12-16.
//  Copyright (c) 2014 deeway. All rights reserved.
//

#import "ContactListTVC.h"
#import "AddressBookManager.h"
#import "ContactDetailViewController.h"



#pragma mark Constants



#pragma mark - Enumerations



#pragma mark -
@interface ContactListTVC ()

/*******************
 * sortedContacts is a two dimensional array. 
 * The first dimension is an array of secion index sorted alphabetically. One alphabet per section.
 * The second dimension is an array of contacts in a section. The contacts are sorted alphabetically.
 *******************/
@property (strong, nonatomic) NSArray * sortedContacts;

// A loading spinner for the view.
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end



#pragma mark -
@implementation ContactListTVC
#pragma mark - Class Methods



#pragma mark - Properties



#pragma mark - Constructors
/*
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self == nil) {
        return nil;
    }
    
    [self init_];
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

/**************************
 * The storyboard calls this init method.
 **************************/
- (id)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder: coder];
	if (self == nil) {
		return nil;
	}
    
    [self init_];
	return self;
}




#pragma mark - Overridden Methods
/*
- (void)loadView {
    // Don't call super in this method.
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Show the loading spinner.
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView startAnimating];
    [self.view addSubview:self.activityIndicatorView];
    
    
    // Set the navigation bar title.
    self.title = @"Contacts";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

/******************************
 * Prepare for the contact detail before push it onto the screen.
 * @segue The segue object containing information about the view controllers involved in the segue.
 * @sender The object that initiated the segue. You might use this parameter to perform different 
 * actions based on which control (or other object) initiated the segue.
 ******************************/
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    // Retrieve the select contact and pass it to the ContactDetailViewController.
    NSDictionary *contact = self.sortedContacts[indexPath.section][indexPath.row];
    ContactDetailViewController *contactDetailVC = (ContactDetailViewController*)segue.destinationViewController;
    contactDetailVC.contactDict = contact;
    
    // Delselect the cell in table view.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/



#pragma mark - Public Methods



#pragma mark - Private Methods
/******************************
 * A private init method to initialize the class.
 ******************************/
- (void)init_ {
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self loadContacts];
}

/******************************
 * Sort an array of contacts from the server and return a two dimensional array.
 * @contacts an unsorted contacts to sort. 
 * @return a two dimensional array.
 * The first dimension is an array of secion index sorted alphabetically. One alphabet per section.
 * The second dimension is an array of contacts in a section. The contacts are sorted alphabetically.
 ******************************/
- (NSArray*)sortContacts:(NSArray*)contacts {
    // Sort the contacts by first name and then sort it by last name for the same first name.
    NSArray *sortedContacts = [contacts sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        // Compare two names by first name.
        NSComparisonResult result = [[obj1 valueForKeyPath:@"user.name.first"] caseInsensitiveCompare:[obj2 valueForKeyPath:@"user.name.first"]];
        
        // If it's the same first name, return the result by last name.
        if (result == NSOrderedSame) {
            result = [[obj1 valueForKeyPath:@"user.name.last"] caseInsensitiveCompare:[obj2 valueForKeyPath:@"user.name.last"]];
        }
        return result;
    }];
    
    // Now that we have a sorted array, we separate the contacts into sections.
    NSMutableArray *sectionedContacts = [NSMutableArray array];
    NSMutableArray *tempContacts = [NSMutableArray array];
    [sectionedContacts addObject:tempContacts];
    
    // Section the contacts by the first alphabet letter.
    unichar firstLetterReference = [((NSString*)[sortedContacts[0] valueForKeyPath:@"user.name.first"]) characterAtIndex:0];
    unichar firstLetter;
    NSDictionary *contactDict;
    NSInteger contactsCount = [sortedContacts count];
    
    // Loop through the sort contacts to create a two dimensional array.
    for (int i=0; i<contactsCount; i++) {
        contactDict = sortedContacts[i];
        firstLetter = [((NSString*)[contactDict valueForKeyPath:@"user.name.first"]) characterAtIndex:0];
        
        // If it's a new alphabet letter, we know we are done the the previous alphabet,
        // create a section array and put it in to the sectionedContacts.
        if (firstLetterReference != firstLetter) {
            firstLetterReference = firstLetter;
            tempContacts = [NSMutableArray array];
            [sectionedContacts addObject:tempContacts];
        }
        
        [tempContacts addObject:contactDict];
    }

    return sectionedContacts;
}

/******************************
 * Load the contacts from the AddressBookManager. If it retrieves the contacts successfully from the 
 * manager, it inserts the contacts to the table view. If it fails to retrieve the contacts, it 
 * shows a popup alert.
 ******************************/
- (void)loadContacts {
    [[AddressBookManager sharedInstance] retrieveContactsWithCompletionHandler:^(NSArray *contacts, NSError *connectionError) {
        // Check to see if there's an error
        if (!connectionError) { // Successfully retrieves the contacts.
            self.sortedContacts = [self sortContacts:contacts];
            
            // Update the UI on the main thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                // Hide the loading spinner.
                [self.activityIndicatorView stopAnimating];
                self.activityIndicatorView.hidden = true;
                
                // Insert the contacts to the table view with animation.
                [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.sortedContacts count])]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        } else {    // Failed to retrieve the contacts.
            // Update the UI on the main thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                // Hide the loading spinner.
                [self.activityIndicatorView stopAnimating];
                self.activityIndicatorView.hidden = true;
                
                // Show the popup alert.
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:[connectionError localizedDescription]
                                           delegate:self
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:@"Try Again", nil] show];
            });
        }
    }];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.sortedContacts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.sortedContacts[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactTitleCell" forIndexPath:indexPath];
    
    NSDictionary *contactDict = self.sortedContacts[indexPath.section][indexPath.row];
    
    // Set the cell name text.
    cell.textLabel.text = [[NSString stringWithFormat:@"%@ %@",
                            [contactDict valueForKeyPath:@"user.name.first"],
                            [contactDict valueForKeyPath:@"user.name.last"]]
                           capitalizedString];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Return the first alphabet letter from the first name as the section title.
    return [[[self.sortedContacts[section][0] valueForKeyPath:@"user.name.first"] substringToIndex:1] uppercaseString];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *titles = [NSMutableArray array];
    
    // Loop through the sortedContacts first dimension to get the first name first alphabet for
    // index on the right hand side of the table view.
    for (NSArray *array in self.sortedContacts) {
        [titles addObject:[[array[0] valueForKeyPath:@"user.name.first"] substringToIndex:1]];
    }
    
    return titles;
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    return index;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



/*
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
*/



/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // If the user taps the try again button, load the contacts again.
    if (buttonIndex == 1) {
        self.activityIndicatorView.hidden = false;
        [self.activityIndicatorView startAnimating];
        
        [self loadContacts];
    }
}



@end
