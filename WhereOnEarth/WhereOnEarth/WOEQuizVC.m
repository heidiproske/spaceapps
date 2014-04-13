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
    UIView* splashView;
    UIView* endView;
    UIImageView* satelliteImage;
    NSMutableArray* answerOptionButtons;
    NSMutableArray* cities;
    
    int currentQuestion;
    int padding;
    UILabel* blastOffTimeLabel;
    NSTimer* timer;
    int currSeconds;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        padding = 10;
        
        //
        // Prepare for Quiz
        //
        cities = [WOESatelliteImageryRequest populateCities];
        [self shuffleQuizData];
        NSLog(@"We have info about %d cities, and %d answerOptionButtons", (int)[cities count], (int)[answerOptionButtons count]);
        
        [self playGame];
    }
    return self;
}

- (void)playGame
{
    if (endView != nil)
    {
        NSLog(@"We have a non nil endView");
        [endView removeFromSuperview];
    }
    currentQuestion = -1;
    [self showStart];
}

- (void)clickedHint
{
    NSLog(@"Show hint for cities %d", currentQuestion);
}

- (void)checkAnswer:(UIButton*)sender
{
    NSLog(@"answer %d was chosen: i.e. %@", (int)sender.tag, sender.titleLabel.text);
}

- (void)startQuiz
{
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
}

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

- (void)showStart
{
    splashView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    splashView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:splashView];
    
    UILabel* gameName = [[UILabel alloc] initWithFrame:CGRectMake(padding, 2*padding, splashView.frame.size.width - 2*padding, 3*padding)];
    gameName.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:30];
    gameName.textColor = [UIColor whiteColor];
    gameName.text = @"ASTRID'S LANDING!";
    gameName.textAlignment = UITextAlignmentCenter;
    [splashView addSubview:gameName];
    
    
    UIImage* inFlightImage = [UIImage imageNamed:@"inflight"];
    float ratio = (SCREEN_WIDTH * 0.017);
    float inFlightHeight = inFlightImage.size.height / ratio;
    float inFlightWidth = inFlightImage.size.width / ratio;
    UIImageView* inFlightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 85, inFlightWidth, inFlightHeight)];
    inFlightView.image = inFlightImage;
    [splashView addSubview:inFlightView];
    
    blastOffTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, SCREEN_HEIGHT-5*padding, splashView.frame.size.width - 2*padding, 3*padding)];
    blastOffTimeLabel.textColor = [UIColor whiteColor];
    blastOffTimeLabel.textAlignment = UITextAlignmentCenter;
    blastOffTimeLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:22];
    currSeconds=3;
    [splashView addSubview:blastOffTimeLabel];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(blastOffTimerFired) userInfo:nil repeats:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)showEnding
{
    endView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:endView];
    
    UIImage* theEnd = [UIImage imageNamed:@"ending"];
    
    float ratio = (SCREEN_WIDTH * 0.0115);
    float endHeight = theEnd.size.height / ratio;
    float endWidth = theEnd.size.width / ratio;
    
    UIImageView* endingView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - endWidth, SCREEN_HEIGHT - endHeight, endWidth, endHeight)];
    endingView.image = theEnd;
    [endView addSubview:endingView];
    
    //
    // Play Again Button
    //
    UIButton* playAgainButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-padding-100, 5*padding, 100, 3*padding)];
    playAgainButton.backgroundColor = [UIColor redColor];
    [playAgainButton setTitle:@"Play Again" forState:UIControlStateNormal];
    playAgainButton.titleLabel.textColor = [UIColor whiteColor];
    playAgainButton.layer.cornerRadius = 10; //hintButton.frame.size.width / 2.0;
    [playAgainButton addTarget:self action:@selector(playGame) forControlEvents:UIControlEventTouchUpInside];
    [endView addSubview:playAgainButton];
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

-(void)blastOffTimerFired
{
    NSLog(@"Timer fired");
    if(currSeconds>=0)
    {
        if(currSeconds==0)
        {
            blastOffTimeLabel.text = [NSString stringWithFormat:@"BLAST OFF"];
        }
        else
        {
            blastOffTimeLabel.text = [NSString stringWithFormat:@"%d", currSeconds];
        }
        currSeconds-=1;
    }
    else
    {
        [splashView removeFromSuperview];
        [self startQuiz];
        [timer invalidate];
    }
}

- (void)shuffleQuizData
{
    NSUInteger count = [cities count];
    for (NSUInteger i = 0; i < count; ++i) {
        //Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [cities exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
