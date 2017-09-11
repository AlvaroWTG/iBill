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
#define kSliderValueFive        @"Unknown"
#define kEmptyString            @""
#define kButtonTitle            @"Roll the dice"
#define kPreviousIndexKey       @"indexPrevious"
#define kAlertTitle             @"Warning"
#define kAlertDescription       @"Please, set the slider value before calculating"
#define kAlertDescriptionError  @"Error %ld - %@"
#define kAlertButtonTitle       @"Dismiss"
#define APP_NAME                @"iCoffee"
#define kBuybackStatusZero      0.33f
#define kBuybackStatusOne       0.66f
#define kBuybackStatusTwo       1.0f

@interface ViewController ()

/** Property that represents the result of the check */
@property (weak, nonatomic) IBOutlet UILabel *labelResult;
/** Property that represents the result of the slider */
@property (weak, nonatomic) IBOutlet UILabel *labelSlider;
/** Property that represents the button to calculate */
@property (weak, nonatomic) IBOutlet UIButton *button;
/** Property that represents the slider of the options */
@property (weak, nonatomic) IBOutlet UISlider *slider;
/** Property that represents the selected option */
@property (nonatomic) BOOL flagSelectedOption;
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
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.button setTitle:kButtonTitle.uppercaseString forState:UIControlStateNormal];
    self.button.backgroundColor = kColor9C5821;
    self.labelSlider.textColor = kColor9C5821;
    self.slider.tintColor = kColor9C5821;
    self.labelResult.text = kEmptyString;
    self.labelSlider.text = kEmptyString;
    self.flagSelectedOption = NO;
    self.isSet = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBAction slider method implementation

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    self.flagSelectedOption = YES;
    float currentValue = sender.value;
    if (currentValue < kBuybackStatusZero) {
        self.labelSlider.text = kSliderValueZero;
        self.currentList = kListThreeMusketeers;
    } else if (currentValue < kBuybackStatusOne) {
        self.labelSlider.text = kSliderValueOne;
        self.currentList = kListFantasticFour;
    } else {
        self.labelSlider.text = kSliderValueTwo;
        self.currentList = kListJacksonFive;
    }
}

# pragma mark - IBAction method implementation

- (IBAction)buttonTapped:(UIButton *)sender
{
    if (self.flagSelectedOption) {
        self.labelResult.text = [self calculatePayer];
    } else [[[UIAlertView alloc] initWithTitle:kAlertTitle message:kAlertDescription delegate:nil cancelButtonTitle:kAlertButtonTitle otherButtonTitles:nil] show];
}

# pragma mark - Auxiliary functions

/**
 * Auxiliary function that calculates the payer
 * @return payer    The string value for the payer
 */
- (NSString *)calculatePayer
{
    NSInteger index = 0;
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
    NSString *description = @"Notification request succesfully created";
    if (error) description = [NSString stringWithFormat:kAlertDescriptionError, (long)error.code, error.localizedDescription];
    dispatch_async(dispatch_get_main_queue(), ^{[[[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:kAlertButtonTitle otherButtonTitles:nil] show];});
}

@end
