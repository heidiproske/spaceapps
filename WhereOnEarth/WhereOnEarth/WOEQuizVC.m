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
    UIView* quizView;
    UIView* endView;
    UIView* landedView;
    
    UIImageView* satelliteImage;
    NSMutableArray* answerOptionButtons;
    NSMutableArray* cities;
    
    int currentQuestion;
    int padding;
    
    UIWebView* webView;
    UILabel* statusLabel;
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
        [self shuffleQuizData:cities];
        NSLog(@"We have info about %d cities", (int)[cities count]);
    }
    return self;
}

- (void)playGame
{
    if (endView != nil)
    {
        [endView removeFromSuperview];
    }
    currentQuestion = -1;
    [self showStart];
}

- (void)clickedHint
{
    NSLog(@"Show hint for city %d", currentQuestion);
    
    NSDictionary* currentCity = cities[currentQuestion];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Hint"
                          message:[NSString stringWithFormat:@"Latitude %@\nLongitude %@", currentCity[KEY_LATITUDE], currentCity[KEY_LONGITUDE]]
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [self.view addSubview:alert];
    [alert show];
}

- (void)checkAnswer:(UIButton*)sender
{
    // Reset all button background colors to default
    for (UIButton* currentButton in answerOptionButtons)
    {
        currentButton.backgroundColor = ANSWER_BUTTON_COLOR;
    }

    NSLog(@"answer button %d was chosen: i.e. %@", (int)sender.tag, sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:cities[currentQuestion][KEY_CITY]])
    {
        [self updateLandedViewWithCityWebData];
    }
    else
    {
        sender.backgroundColor = [UIColor redColor];
    }
}

- (void)createQuiz
{
    int numberAnswerOptions = 4;
    int yHalfway = SCREEN_HEIGHT / 2;
    
    quizView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    quizView.backgroundColor = [UIColor lightGrayColor];
    
    //
    // Spaceship window frame
    //
    int spaceWindowSize = yHalfway; // - 2*padding;
    UIImageView* spaceWindowOutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"window_gray"]];
    spaceWindowOutline.frame = CGRectMake((SCREEN_WIDTH - spaceWindowSize)/2, padding   , spaceWindowSize, spaceWindowSize);
    
    //
    // Show current question number, so user has some indication of progress
    //
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, SCREEN_WIDTH/5, 20)];
    [quizView addSubview:statusLabel];
    
    //
    // Satellite image
    //
    satelliteImage = [[UIImageView alloc] initWithFrame:CGRectMake(spaceWindowOutline.frame.origin.x + 10, spaceWindowOutline.frame.origin.y + 10, spaceWindowOutline.frame.size.width - 20, spaceWindowOutline.frame.size.height - 20)];
    satelliteImage.layer.cornerRadius = satelliteImage.frame.size.width / 2;
    satelliteImage.layer.masksToBounds = YES;
    [quizView addSubview:satelliteImage];
    
    satelliteImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [quizView addSubview:spaceWindowOutline];
    
    //
    // HINT Button
    //
    int heightHintButton = 35;
    int widthHintButton = heightHintButton*2;
    int xPos = SCREEN_WIDTH/2 - widthHintButton/2;
    UIButton* hintButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, SCREEN_HEIGHT-heightHintButton-padding, widthHintButton, heightHintButton)];
    hintButton.backgroundColor = [UIColor redColor];
    [hintButton setTitle:@"Hint" forState:UIControlStateNormal];
    hintButton.titleLabel.textColor = [UIColor whiteColor];
    hintButton.layer.cornerRadius = 10; //hintButton.frame.size.width / 2.0;
    [hintButton addTarget:self action:@selector(clickedHint) forControlEvents:UIControlEventTouchUpInside];
    [quizView addSubview:hintButton];
    
    //
    // Answer Option Buttons
    //
    int spaceForAnswerButtons = yHalfway - heightHintButton - padding;
    int heightOfAnswerOption = (spaceForAnswerButtons - (numberAnswerOptions+3)*padding) / numberAnswerOptions;
    int widthOfAnswerOption = SCREEN_WIDTH - 8*padding;
    
    // NSLog(@"heightOfAnswerOption = %d, halfway Y %d, width = %f, height = %f", heightOfAnswerOption, yHalfway, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    answerOptionButtons = [@[] mutableCopy];
    for (int i=0; i<numberAnswerOptions; i++)
    {
        int yPos = yHalfway + (i+3)*padding + i*heightOfAnswerOption;
        //           NSLog(@"Drawing button %d at (%d, %d)", i+1, padding, yPos);
        UIButton* answerOption = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-widthOfAnswerOption)/2, yPos, widthOfAnswerOption, heightOfAnswerOption)];
        answerOption.tag = 1;
        answerOption.backgroundColor = ANSWER_BUTTON_COLOR;
        answerOption.layer.cornerRadius = 6; //answerOption.frame.size.width / 2.0;
        [answerOption addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
        [quizView addSubview:answerOption];
        
        answerOptionButtons[[answerOptionButtons count]] = answerOption;
    }
}

- (void)showNextQuestion
{
    [landedView removeFromSuperview];
    
    if (++currentQuestion >= [cities count])
    {
        NSLog(@"User quizzed on all %d cities, going to end screen!", [cities count]);
        
        [self createEndView];
        [self fadeInView:endView];
        [quizView removeFromSuperview];
        
        return;
    }
    
    statusLabel.text = [NSString stringWithFormat:@"%d of %d", currentQuestion+1, [cities count]];
    
    //
    // Update satellite image for current city
    //
    NSMutableDictionary* cityInfo = cities[currentQuestion];
    NSString* cityName = cityInfo[KEY_CITY];
    NSString* countryName = cityInfo[KEY_COUNTRY];
    NSLog(@"current city %@, %@", cityName, countryName);
    
    NSDictionary* returnResult = [WOESatelliteImageryRequest getImageForCity:cityName InCountry:countryName];
    cityInfo[KEY_LATITUDE] = returnResult[KEY_LATITUDE];
    cityInfo[KEY_LONGITUDE] = returnResult[KEY_LONGITUDE];
    UIImage* cityImage = returnResult[KEY_IMAGE];
    satelliteImage.image = cityImage;
    
    //
    // Now populate potential answers
    //
    int correctIndex = arc4random_uniform([answerOptionButtons count]);
    
    UIButton* correctAnswerButton = (UIButton*)(answerOptionButtons[correctIndex]);
    correctAnswerButton.titleLabel.text = cityName;
    [correctAnswerButton setTitle:cityName forState:UIControlStateNormal];
    //    NSLog(@"Storing correct answer %@ on button %d", )
    
    NSMutableArray* redHerringAnswers = [NSMutableArray arrayWithArray:cities];
    [redHerringAnswers removeObject:cities[currentQuestion]]; // get rid of current answers
    [self shuffleQuizData:redHerringAnswers];
    
    int redHerringIndex = 0;
    for (int i=0; i<[answerOptionButtons count]; i++)
    {
        if (i != correctIndex) // don't want to overwrite a button's text if it's already associated
        {
            UIButton* currentButton = answerOptionButtons[i];
            NSString* newTitle = redHerringAnswers[redHerringIndex++][KEY_CITY];
            [currentButton setTitle:newTitle forState:UIControlStateNormal];
            NSLog(@"Updating button %d to set title to %@", i, newTitle);
        }
//        else
//        {
//            NSLog(@"Button %d contains the correct answer %@ so leaving alone!", correctIndex, cityName);
//        }
    }
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
    [self createLandedView];
}

- (void)createEndView
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


- (void)updateLandedViewWithCityWebData
{
    [self fadeInView:landedView];
    NSString* cityName = [cities[currentQuestion][KEY_CITY] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString* wikiURL = [NSString stringWithFormat:@"https://en.wikipedia.org/wiki/%@", cityName];
    NSLog(@"Looking up WIKI %@", wikiURL);
    // Now load the URL and display
    NSURL *url = [NSURL URLWithString:wikiURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)createLandedView
{
    landedView = [[UIView alloc] initWithFrame:self.view.frame];
    landedView.backgroundColor = COLOR_SKY_BLUE;
    
    CGRect whiteFrame = landedView.frame;
    UILabel* congratsLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, whiteFrame.size.width - 2*padding, 2*padding)];
    congratsLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:22];
    congratsLabel.textColor = [UIColor blackColor];
    congratsLabel.text = @"Great Landing!";
    congratsLabel.textAlignment = UITextAlignmentCenter;
    [landedView addSubview:congratsLabel];
    
    UIView* greenGrass = [[UIView alloc] initWithFrame:CGRectMake(whiteFrame.origin.x, SCREEN_HEIGHT - 3*padding, whiteFrame.size.width, 3*padding)];
    greenGrass.backgroundColor = COLOR_GRASS;
    [landedView addSubview:greenGrass];
    
    UIView* blackBorder = [[UIView alloc] initWithFrame:CGRectMake(
           whiteFrame.origin.x + padding/2,
           congratsLabel.frame.origin.y + congratsLabel.frame.size.height + padding/2,
           whiteFrame.size.width - padding,
           whiteFrame.size.height - congratsLabel.frame.origin.y - congratsLabel.frame.size.height - 5*padding)];
    blackBorder.backgroundColor = [UIColor blackColor];
    [landedView addSubview:blackBorder];
    
    UIButton* nextFlightBtn = [[UIButton alloc] initWithFrame:CGRectMake(padding/2, greenGrass.frame.origin.y-1.2*padding, 100, 35)];
    nextFlightBtn.backgroundColor = [UIColor redColor];
    nextFlightBtn.layer.cornerRadius = 10; //nextFlightBtn.frame.size.width / 2.0;
    nextFlightBtn.titleLabel.textColor = [UIColor whiteColor]; //TODO his screengrab was black
    if (currentQuestion < [cities count] - 1)
    {
        [nextFlightBtn setTitle:@"Next Flight" forState:UIControlStateNormal];
    } else
    {
        [nextFlightBtn setTitle:@"Finish" forState:UIControlStateNormal];
    }
    [nextFlightBtn addTarget:self action:@selector(showNextQuestion) forControlEvents:UIControlEventTouchUpInside];
    [landedView addSubview:nextFlightBtn];
    
    int lineWidth = 3;
    UIView* whiteScreenForData = [[UIView alloc] initWithFrame:CGRectMake(
          blackBorder.frame.origin.x + lineWidth,
          blackBorder.frame.origin.y + lineWidth,
          blackBorder.frame.size.width - 2*lineWidth,
          blackBorder.frame.size.height - 2*lineWidth)];
    
    whiteScreenForData.backgroundColor = [UIColor whiteColor];
    [landedView addSubview:whiteScreenForData];
    
    webView = [[UIWebView alloc] initWithFrame:whiteScreenForData.frame];
    [landedView addSubview:webView];
    
    // Add the girl in bottom right on top of all other views
    UIImage* girl = [UIImage imageNamed:@"Astrid"];
    float ratio = (SCREEN_WIDTH * 0.024);
    float girlHeight = girl.size.height / ratio;
    float girlWidth = girl.size.width / ratio;
    UIImageView* cornerGirl = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - girlWidth, SCREEN_HEIGHT - girlHeight, girlWidth, girlHeight)];
    cornerGirl.image = girl;
    [webView addSubview:cornerGirl];
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
        [timer invalidate];
        [self createQuiz];
        [splashView removeFromSuperview];
        [self fadeInView:quizView];
        [self showNextQuestion];
    }
}

-(void)fadeInView:(UIView*)newView
{
    newView.alpha = 0;
    [self.view addSubview:newView];
    
    [UIView animateWithDuration:0.2 animations:^{
        newView.alpha = 1;
    }];
}

//TODO look up CGContextAddRect()

- (void)shuffleQuizData:(NSMutableArray*)myArray
{
    NSUInteger count = [myArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        //Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [myArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
