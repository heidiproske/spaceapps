//
//  WOEQuizVC.m
//  WhereOnEarth
//
//  Created by Heidi Proske on 4/12/14.
//  Copyright (c) 2014 Heidi Proske. All rights reserved.
//

#import "WOEQuizVC.h"
#import "WOESatelliteImageryRequest.h"

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
        UIImageView* spaceWindowOutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"window_gray"]];
        spaceWindowOutline.frame = CGRectMake((SCREEN_WIDTH - spaceWindowSize - padding)/2, padding*2, spaceWindowSize, spaceWindowSize);
        
        //
        // Satellite image
        //
        satelliteImage = [[UIImageView alloc] initWithFrame:CGRectMake(spaceWindowOutline.frame.origin.x + 10, spaceWindowOutline.frame.origin.y + 10, spaceWindowOutline.frame.size.width - 20, spaceWindowOutline.frame.size.height - 20)];
        satelliteImage.layer.cornerRadius = satelliteImage.frame.size.width / 2;
        satelliteImage.layer.masksToBounds = YES;
        [self.view addSubview:satelliteImage];
        
        satelliteImage.contentMode = UIViewContentModeScaleAspectFill;
        
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
        [hintButton addTarget:self action:@selector(clickedHint) forControlEvents:UIControlEventTouchUpInside];
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
        cities = [WOESatelliteImageryRequest populateCities];
        [self shuffle];
        NSLog(@"We have info about %d cities, and %d answerOptionButtons", (int)[cities count], (int)[answerOptionButtons count]);
        currentQuestion = -1;
    }
    return self;
}


- (void)clickedHint
{
    NSLog(@"Show hint for city %d", currentQuestion);
}

- (void)checkAnswer:(UIButton*)sender
{
    NSLog(@"answer button %d was chosen: i.e. %@", (int)sender.tag, sender.titleLabel.text);
- (void)showNextQuestion
{
    if (++currentQuestion >= [cities count])
    {
        NSLog(@"you were quizzed on all %d cities!", [cities count]);
        return;
    }
    
    NSDictionary* cityInfo = cities[currentQuestion];
    NSLog(@"showNextQuestion #%d", currentQuestion);
    
    NSString* cityName = [cityInfo objectForKey:KEY_CITY];
    NSString* countryName = [cityInfo objectForKey:KEY_COUNTRY];
    
    NSLog(@"current city %@, %@", cityName, countryName);
    
    UIImage* cityImage = [WOESatelliteImageryRequest getImageForCity:cityName InCountry:countryName];
    
    satelliteImage.image = cityImage;
    NSLog(@"updated image?!");
    
    int randomIndex = 0;
    UIButton* correctAnswerButton = (UIButton*)(answerOptionButtons[randomIndex]);
    correctAnswerButton.titleLabel.text = cityName;
    [correctAnswerButton setTitle:cityName forState:UIControlStateNormal];
    //
    //    for (UIButton* answerOptionButton in answerOptionButtons)
    //    {
    //       int index = [answerOptionButtons indexOfObject:answerOptionButtons];
    //    }
    //    NSLog(@"answer %d was chosen: i.e. %@", (int)sender.tag, sender.titleLabel.text);
    //    // Do any additional setup after loading the view.
    
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

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void)shuffle
{
    NSLog(@"Before: %@", cities);
    NSUInteger count = [cities count];
    for (NSUInteger i = 0; i < count; ++i) {
        //Select a random element between i and end of array to swap with.
       NSInteger nElements = count - i;
       NSInteger n = arc4random_uniform(nElements) + i;
       [cities exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    NSLog(@"After: %@", cities);
}

@end
