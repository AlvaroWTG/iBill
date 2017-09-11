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
#define kAlertButtonTitle       @"Dismiss"
#define APP_NAME                @"iBill"
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
    
    // Setup the slider and the button title
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.button setTitle:[kButtonTitle uppercaseString] forState:UIControlStateNormal];

    // Setup labels for the screen
    self.labelResult.text = kEmptyString;
    self.labelSlider.text = kEmptyString;
    self.labelAmount.text = kEmptyString;
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
        self.labelAmount.text = kListAmounts[arc4random() % kListAmounts.count];
    } else [[[UIAlertView alloc] initWithTitle:kAlertTitle message:kAlertDescription delegate:nil cancelButtonTitle:kAlertButtonTitle otherButtonTitles:nil] show];
}

# pragma mark - Auxiliary functions

- (NSString *)calculatePayer
{
    NSString *result = nil;
    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:kPreviousIndexKey];
    if (index >= self.currentList.count) {
        result = self.currentList[0];
        index = 0;
    } else {
        result = self.currentList[(NSUInteger) index];
        index ++;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:kPreviousIndexKey];
    return result;
}

@end
