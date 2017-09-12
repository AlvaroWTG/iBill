//
//  ViewController.m
//  iBill
//
//  Created by WebToGo on 11/13/15.
//  Copyright © 2015 WebToGo GmbH. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

#define kColor9C5821            [UIColor colorWithRed:(156.0/255.0) green:(87.0/255.0) blue:(34.0/255.0) alpha:1.0]
#define kListJacksonFive        @[@"Alvaro", @"Pepe", @"Alfonso", @"Alex", @"Hernan"]
#define kListFantasticFour      @[@"Alvaro", @"Pepe", @"Alfonso", @"Alex"]
#define kListThreeMusketeers    @[@"Alvaro", @"Pepe", @"Alfonso"]
#define kSliderValueZero        @"The Three Musketeers"
#define kSliderValueOne         @"The Fantastic Four"
#define kSliderValueTwo         @"The Backstreet Boys"
#define kEmptyString            @""
#define kButtonTitle            @"Roll the dice"
#define kPreviousIndexKey       @"indexPrevious"
#define kAlertTitle             @"Warning"
#define kAlertDescription       @"Please, select one of the three options first"
#define kAlertDescription2      @"You have already setup a reminder"
#define kNotificationBody       @"Rise and shine %@, you're on the clock."
#define kNotificationTitle      @"It's coffee o'clock"
#define kAlertDescriptionOk     @"Notification request succesfully created"
#define kAlertDescriptionError  @"Error %ld - %@"
#define kAlertButtonTitle       @"Dismiss"
#define APP_NAME                @"iCoffee"
#define kBuybackStatusZero      0.33f
#define kBuybackStatusOne       0.66f
#define kBuybackStatusTwo       1.0f

@interface ViewController ()

/** Property that represents the image view for the first option */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOne;
/** Property that represents the image view for the first option */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwo;
/** Property that represents the image view for the first option */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewThree;
/** Property that represents the result of the check */
@property (weak, nonatomic) IBOutlet UILabel *labelResult;
/** Property that represents the label for the first option */
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
/** Property that represents the label for the first option */
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
/** Property that represents the label for the first option */
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
/** Property that represents the button to calculate */
@property (weak, nonatomic) IBOutlet UIButton *button;
/** Property that represents the selected option */
@property (nonatomic) BOOL hasOption;
/** Property that represents the selected option */
@property (nonatomic, strong) NSArray *currentList;
/** Property that represents the random amount of money */
@property (nonatomic) NSInteger amount;
/** Property that represents the selected option */
@property (nonatomic) BOOL isSet;

/**
 * Function that performs an action when the button is clicked
 * @param sender The identifier of the sender of the action
 * @return action The action performed when clicked
 */
- (IBAction)buttonTapped:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // Set the background color for the bar and the views
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.barStyle = (UIBarStyle) UIStatusBarStyleLightContent;
    navigationBar.barTintColor = kColor9C5821;
    navigationBar.translucent = NO;

    // Set the title for the navigation bar
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didPressAdd:)];
    self.navigationController.topViewController.navigationItem.title = APP_NAME;

    // Setup the slider and the button title
    [self.button setTitle:kButtonTitle.uppercaseString forState:UIControlStateNormal];
    [self.button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.button.backgroundColor = kColor9C5821;
    self.hasOption = NO;
    self.isSet = NO;

    // Setup the label and image views
    self.labelOne.adjustsFontSizeToFitWidth = YES;
    self.labelTwo.adjustsFontSizeToFitWidth = YES;
    self.labelThree.adjustsFontSizeToFitWidth = YES;
    self.labelOne.textColor = kColor9C5821;
    self.labelTwo.textColor = kColor9C5821;
    self.labelThree.textColor = kColor9C5821;
    self.labelOne.text = kSliderValueZero;
    self.labelTwo.text = kSliderValueOne;
    self.labelThree.text = kSliderValueTwo;
    self.labelResult.text = kEmptyString;

    // Setup the tap recognizer for both labels and the image
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeGestureWith:)];
    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeGestureWith:)];
    UITapGestureRecognizer *recognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeGestureWith:)];
    recognizer1.numberOfTouchesRequired = 1;
    recognizer2.numberOfTouchesRequired = 1;
    recognizer3.numberOfTouchesRequired = 1;
    recognizer1.numberOfTapsRequired = 1;
    recognizer2.numberOfTapsRequired = 1;
    recognizer3.numberOfTapsRequired = 1;

    // Setup the gesture recognizers to the labels and image
    self.imageViewOne.tag = 0;
    self.imageViewTwo.tag = 1;
    self.imageViewThree.tag = 2;
    self.imageViewOne.userInteractionEnabled = YES;
    self.imageViewTwo.userInteractionEnabled = YES;
    self.imageViewThree.userInteractionEnabled = YES;
    [self.imageViewOne addGestureRecognizer:recognizer1];
    [self.imageViewTwo addGestureRecognizer:recognizer2];
    [self.imageViewThree addGestureRecognizer:recognizer3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBAction method implementation

- (IBAction)buttonTapped:(UIButton *)sender
{
    if (self.hasOption) {
        self.labelResult.text = [self calculatePayer];
    } else [[[UIAlertView alloc] initWithTitle:kAlertTitle message:kAlertDescription delegate:nil cancelButtonTitle:kAlertButtonTitle otherButtonTitles:nil] show];
}

- (void)didPressAdd:(UIBarButtonItem *)button
{
    if (!self.isSet) {
        [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.body = [NSString stringWithFormat:kNotificationBody, [self calculatePayer]];
        content.sound = UNNotificationSound.defaultSound;
        content.title = kNotificationTitle;
        content.badge = @(1);
        NSDateComponents *referenceDate = [[NSDateComponents alloc] init];
        referenceDate.hour = 11;
        referenceDate.minute = 01;
        referenceDate.second = 00;
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:referenceDate repeats:YES];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[NSUUID UUID].UUIDString content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            [self pushAlertWithError:error];
            self.isSet = error == nil;
        }];
    } else [[[UIAlertView alloc] initWithTitle:APP_NAME message:kAlertDescription2 delegate:nil cancelButtonTitle:kAlertButtonTitle otherButtonTitles:nil] show];
}

# pragma mark - Auxiliary functions

/**
 * Auxiliary function that calculates the payer
 * @return payer    The string value for the payer
 */
- (NSString *)calculatePayer
{
    NSInteger index = 0;
    if (!self.currentList) self.currentList = kListThreeMusketeers;
    NSInteger previousIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kPreviousIndexKey];
    if (previousIndex < self.currentList.count - 1) index = previousIndex + 1;
    NSString *result = self.currentList[(NSUInteger) index];
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:kPreviousIndexKey];
    return result;
}

/**
 * Auxiliary function that pushes an alert
 * @param error     The error parameter received
 */
- (void)pushAlertWithError:(NSError *)error
{
    NSString *title = error ? kAlertTitle : APP_NAME;
    NSString *description = error ? [NSString stringWithFormat:kAlertDescriptionError, (long)error.code, error.localizedDescription] : kAlertDescriptionOk;
    dispatch_async(dispatch_get_main_queue(), ^{[[[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:kAlertButtonTitle otherButtonTitles:nil] show];});
}

/**
 * Auxiliary function that recognize the first single gesture
 * @param sender    The sender of the tap recognizer
 */
- (void)recognizeGestureWith:(UITapGestureRecognizer *)sender
{
    self.hasOption = YES;
    switch (sender.view.tag) {
        case 0: // three musketeers
            self.currentList = kListThreeMusketeers;
            self.imageViewOne.backgroundColor = kColor9C5821;
            self.imageViewTwo.backgroundColor = UIColor.whiteColor;
            self.imageViewThree.backgroundColor = UIColor.whiteColor;
            break;
        case 1: // a team
            self.currentList = kListFantasticFour;
            self.imageViewOne.backgroundColor = UIColor.whiteColor;
            self.imageViewTwo.backgroundColor = kColor9C5821;
            self.imageViewThree.backgroundColor = UIColor.whiteColor;
            break;
        case 2: // jackson five
            self.currentList = kListJacksonFive;
            self.imageViewOne.backgroundColor = UIColor.whiteColor;
            self.imageViewTwo.backgroundColor = UIColor.whiteColor;
            self.imageViewThree.backgroundColor = kColor9C5821;
            break;
        default: break;
    }
}

@end
