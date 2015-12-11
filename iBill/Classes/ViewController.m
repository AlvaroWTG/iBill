//
//  ViewController.m
//  iBill
//
//  Created by WebToGo on 11/13/15.
//  Copyright © 2015 WebToGo GmbH. All rights reserved.
//

#import "ViewController.h"

#define kListJacksonSix         @[@"Alvaro", @"Eva", @"David", @"Nicola", @"Alfonso", @"Pepe"]
#define kListJacksonFive        @[@"Alvaro", @"David", @"Nicola", @"Alfonso", @"Pepe"]
#define kListFantasticFour      @[@"Alvaro", @"Nicola", @"Alfonso", @"Pepe"]
#define kListThreeMusketeers    @[@"Alvaro", @"Alfonso", @"Pepe"]
#define kSliderValueOne         @"The Three Musketeers"
#define kSliderValueTwo         @"The Fantastic Four"
#define kSliderValueThree       @"The Backstreet Boys"
#define kSliderValueFour        @"Six Wives of Henry VIII"
#define kSliderValueFive        @"Unknown"
#define kBuybackStatusOne       0.25f
#define kBuybackStatusTwo       0.50f
#define kBuybackStatusThree     0.75f
#define kBuybackStatusFour      1.0f

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
    [self.button setTitle:[@"Calculate" uppercaseString] forState:UIControlStateNormal];
    self.labelResult.text = @"";
    self.labelSlider.text = @"";
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
    if (currentValue < kBuybackStatusOne) {
        self.labelSlider.text = kSliderValueOne;
        self.currentList = kListThreeMusketeers;
    } else if (currentValue < kBuybackStatusTwo) {
        self.labelSlider.text = kSliderValueTwo;
        self.currentList = kListFantasticFour;
    } else if (currentValue < kBuybackStatusThree) {
        self.labelSlider.text = kSliderValueThree;
        self.currentList = kListJacksonFive;
    } else if (currentValue < kBuybackStatusFour) {
        self.labelSlider.text = kSliderValueFour;
        self.currentList = kListJacksonSix;
    } else {
        self.labelSlider.text = kSliderValueFive;
        self.flagSelectedOption = NO;
    }
}

# pragma mark - IBAction method implementation

- (IBAction)buttonTapped:(UIButton *)sender
{
    if (self.flagSelectedOption) {
        self.labelResult.text = [self calculatePayer];
    } else [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please, set the slider value before calculating" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}

# pragma mark - Auxiliary functions

- (NSString *)calculatePayer
{
    NSString *result = nil;
    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"indexPrevious"];
    if (index >= self.currentList.count) {
        result = self.currentList[0];
        index = 0;
    } else {
        result = self.currentList[(NSUInteger) index];
        index ++;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"indexPrevious"];
    return result;
}

@end
