//
//  UserRegistrationTableViewController.m
//  AnonymoResurrected
//
//  Created by Ion Silviu-Mihai on 15/05/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "UserRegistrationTableViewController.h"
#import "Constants.h"
#import "AppDelegate.h"




@interface UserRegistrationTableViewController ()

@property (nonatomic, retain) UISwipeGestureRecognizer *swipeGesture;

@end

@implementation UserRegistrationTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.activityIndicator stopAnimating];
    
    
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(gestureFired:)];
    [self.view addGestureRecognizer:self.swipeGesture];
    
    UIColor *color = [UIColor colorWith256RBGAArray:kGrayColor];
    self.firstNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.firstNameTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    self.lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.lastNameTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    self.nicknameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.nicknameTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    self.locationCityTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.locationCityTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    self.mailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.mailTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.passwordTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    self.confirmPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.confirmPasswordTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 8;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark - Text Field delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

#pragma mark -
#pragma mark - Gesture recognizer methods

-(void)gestureFired:(UISwipeGestureRecognizer *)gesture
{

        [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)registerUser:(UIButton *)sender {

    if (!IS_IPHONE_5) {
        [self.tableView setContentOffset:CGPointMake(0, 30) animated:YES];
    }
    
    [self.activityIndicator startAnimating];
}
@end
