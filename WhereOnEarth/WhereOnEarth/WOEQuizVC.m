//
//  WOEQuizVC.m
//  WhereOnEarth
//
//  Created by Heidi Proske on 4/12/14.
//  Copyright (c) 2014 Heidi Proske. All rights reserved.
//

#import "WOEQuizVC.h"

@implementation WOEQuizVC
{
    UIImageView* satelliteImage;
    NSMutableArray* answerOptionButtons;
    NSMutableArray* cities;

    int currentQuestion;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        int padding = 10;
        int numberAnswerOptions = 4;
        int yHalfway = SCREEN_HEIGHT / 2;
        
        //
        // Spaceship window frame
        //
        int spaceWindowSize = yHalfway - 2*padding; // TODO ask jo re this.. SCREEN_WIDTH-2*padding;
        UIImageView* spaceWindowOutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"window.png"]];
        spaceWindowOutline.frame = CGRectMake((SCREEN_WIDTH - spaceWindowSize - padding)/2, padding*2, spaceWindowSize, spaceWindowSize);
        [self.view addSubview:spaceWindowOutline];
        
        //
        // HINT Button
        //
        int heightHintButton = 40;
        int widthHintButton = heightHintButton*2;
        int xPos = SCREEN_WIDTH/2 - widthHintButton/2;
        UIButton* hintButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, SCREEN_HEIGHT-heightHintButton-padding, widthHintButton, heightHintButton)];
        hintButton.backgroundColor = [UIColor redColor];
        [hintButton setTitle:@"Hint" forState:UIControlStateNormal];
        hintButton.titleLabel.textColor = [UIColor whiteColor];
        hintButton.layer.cornerRadius = 10; //hintButton.frame.size.width / 2.0;
        [hintButton addTarget:self action:@selector(clickedHint:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:hintButton];

        //
        // Answer Option Buttons
        //
        int spaceForAnswerButtons = yHalfway - heightHintButton - 2*padding;
        int heightOfAnswerOption = (spaceForAnswerButtons - (numberAnswerOptions+1)*padding) / numberAnswerOptions;
        int widthOfAnswerOption = SCREEN_WIDTH - 2*padding;
        
//        NSLog(@"heightOfAnswerOption = %d, halfway Y %d, width = %f, height = %f", heightOfAnswerOption, yHalfway, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        answerOptionButtons = [@[] mutableCopy];
        for (int i=0; i<numberAnswerOptions; i++)
        {
            int yPos = yHalfway + (i+1)*padding + i*heightOfAnswerOption;
//            NSLog(@"Drawing button %d at (%d, %d)", i+1, padding, yPos);
            UIButton* answerOption = [[UIButton alloc] initWithFrame:CGRectMake(padding, yPos, widthOfAnswerOption, heightOfAnswerOption)];
            answerOption.tag = 1;
            answerOption.backgroundColor = [UIColor grayColor];
            answerOption.layer.cornerRadius = 6; //answerOption.frame.size.width / 2.0;
            [answerOption addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:answerOption];
            
            answerOptionButtons[[answerOptionButtons count]] = answerOption;
        }
        
        //
        // Prepare for Quiz
        //
        cities =
            [@[
              @{KEY_CITY : @"Durban", KEY_COUNTRY : @"South Africa", KEY_IMAGE : @"images/durban"},
              @{KEY_CITY : @"New York", KEY_COUNTRY : @"USA", KEY_IMAGE : @"images/newyork"},
              @{KEY_CITY : @"Paris", KEY_COUNTRY : @"France", KEY_IMAGE : @"images/paris"},
              @{KEY_CITY : @"Hong Kong", KEY_COUNTRY : @"China", KEY_IMAGE : @"images/hongkong"}
              ] mutableCopy];
            
        NSLog(@"We have info about %d cities, and %d answerOptionButtons", (int)[cities count], (int)[answerOptionButtons count]);
        currentQuestion = 0;
    }
    return self;
}

- (void)checkAnswer:(UIButton*)sender
{
    NSLog(@"answer %d was chosen: i.e. %@", (int)sender.tag, sender.titleLabel.text);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

@end
