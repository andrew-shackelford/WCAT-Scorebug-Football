//
//  AppDelegate.m
//  Football Scorebug
//
//  Created by Andrew Shackelford on 5/9/15.
//  Copyright (c) 2015 Andrew Shackelford. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

bool timeoutShowing;
bool touchdownShowing;
bool flagShowing;
bool replayShowing;
bool clockShowing;
bool downShowing;
bool scorebugShowing;
bool locatorShowing;
bool scoreboardShowing;

int homeScore;
int awayScore;
int quarter;
int timeSeconds;
int down;
int distance;

bool andGoal;
bool justDown;

bool clockRunning;

NSTimer *clockTimer;

NSColor *blue;
NSColor *red;
NSColor *yellow;
NSColor *green;
NSColor *black;

NSString *homeName;
NSString *awayName;

NSString *homeRecord;
NSString *awayRecord;

NSString *location;

NSString *replayHide;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self setStartingValues];
    [_displayWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [_controlWindow makeKeyAndOrderFront:self];
    [_displayWindow setFrame:NSMakeRect(100.f, 100.f, 640.f, 480.f) display:YES animate:YES];
    [_controlWindow miniaturize:self];
    [_displayWindow makeKeyAndOrderFront:self];
    [_displayWindow miniaturize:self];
    [_controlWindow deminiaturize:self];
    [_displayWindow deminiaturize:self];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Enter in the away name below"];
    [alert addButtonWithTitle:@"Ok"];
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [input setStringValue:@""];
    [alert setAccessoryView:input];
    NSInteger button = [alert runModal];
    if (button == NSAlertFirstButtonReturn) {
        awayName = [input stringValue];
    }
    
    NSAlert *alert3 = [[NSAlert alloc] init];
    [alert3 setMessageText:@"Enter in the away record below"];
    [alert3 addButtonWithTitle:@"Ok"];
    NSTextField *input3 = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [input3 setStringValue:@""];
    [alert3 setAccessoryView:input3];
    NSInteger button3 = [alert3 runModal];
    if (button3 == NSAlertFirstButtonReturn) {
        awayRecord = [input3 stringValue];
    }
    
    NSAlert *alert2 = [[NSAlert alloc] init];
    [alert2 setMessageText:@"Enter in the home name below"];
    [alert2 addButtonWithTitle:@"Ok"];
    NSTextField *input2 = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [input2 setStringValue:@""];
    [alert2 setAccessoryView:input2];
    NSInteger button2 = [alert2 runModal];
    if (button2 == NSAlertFirstButtonReturn) {
        homeName = [input2 stringValue];
    }

    NSAlert *alert4 = [[NSAlert alloc] init];
    [alert4 setMessageText:@"Enter in the home record below"];
    [alert4 addButtonWithTitle:@"Ok"];
    NSTextField *input4 = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [input4 setStringValue:@""];
    [alert4 setAccessoryView:input4];
    NSInteger button4 = [alert4 runModal];
    if (button4 == NSAlertFirstButtonReturn) {
        homeRecord = [input4 stringValue];
    }
    
    NSAlert *alert5 = [[NSAlert alloc] init];
    [alert5 setMessageText:@"Enter in the location name below"];
    [alert5 addButtonWithTitle:@"Ok"];
    NSTextField *input5 = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [input5 setStringValue:@""];
    [alert5 setAccessoryView:input5];
    NSInteger button5 = [alert5 runModal];
    if (button5 == NSAlertFirstButtonReturn) {
        location = [input5 stringValue];
    }
    
    [_awayNameDisplay setStringValue:awayName];
    [_homeNameDisplay setStringValue:homeName];
    
    scoreboardShowing = true;
    [self concealScoreboard];
    scoreboardShowing = false;
    
    replayShowing = true;
    [self showReplay:self];
    replayShowing = false;
    
}

- (void)setStartingValues {
    green = [NSColor colorWithCalibratedRed:0.365 green:0.78 blue:0.337 alpha:1];
    red = [NSColor redColor];
    blue = [NSColor blueColor];
    yellow = [NSColor colorWithCalibratedRed:0.9725 green:0.8705 blue:0.1843 alpha:1];
    black = [NSColor blackColor];
    
    timeoutShowing = false;
    touchdownShowing = false;
    flagShowing = false;
    replayShowing = false;
    clockShowing = true;
    downShowing = true;
    scorebugShowing = true;
    scoreboardShowing = false;
    locatorShowing = false;
    
    [_timeoutControl setStringValue:@"Hidden"];
    [_touchdownControl setStringValue:@"Hidden"];
    [_flagControl setStringValue:@"Hidden"];
    [_replayControl setStringValue:@"Hidden"];
    [_clockShowingControl setStringValue:@"Showing"];
    [_downShowingControl setStringValue:@"Showing"];
    [_scorebugShowingControl setStringValue:@"Showing"];
    down = 1;
    distance = 10;
    timeSeconds = 720;
    andGoal = false;
    justDown = false;
    clockRunning = false;
    quarter = 1;
    homeScore = 0;
    awayScore = 0;
    [_awayScoreControl setStringValue:@"Away: 0"];
    [_homeScoreControl setStringValue:@"Home: 0"];
    [_clockControl setStringValue:@"12:00"];
    [_quarterControl setStringValue:@"1st Qtr"];
    [_downAndDistanceControl setStringValue:@"1st & 10"];
    [_downControl setStringValue:@"1"];
    [_distanceControl setStringValue:@"10"];
    
    [_scorebugShowingControl setTextColor:green];
    [_downShowingControl setTextColor:green];
    [_clockShowingControl setTextColor:green];
    
    [self updateDisplayClock];
    [self updateDisplayDown];
    [self updateDisplayQuarter];
    [self updateDisplayScore];
    
    [_locatorAwayName setStringValue:@""];
    [_locatorAwayScore setStringValue:@""];
    [_locatorHomeName setStringValue:@""];
    [_locatorHomeScore setStringValue:@""];
    [_locatorQuarter setStringValue:@""];
}

- (NSString*)getTimeString:(int)timeSeconds {
    NSString *timeLabel;
    if (timeSeconds/36000 > 0) {
        NSInteger ti = (NSInteger)timeSeconds;
        NSInteger seconds = ti % 60;
        NSInteger minutes = (ti / 60) % 60;
        NSInteger hours = (ti / 3600);
        timeLabel = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    } else if (timeSeconds/3600 >= 1) {
        NSInteger ti = (NSInteger)timeSeconds;
        NSInteger seconds = ti % 60;
        NSInteger minutes = (ti / 60) % 60;
        NSInteger hours = (ti / 3600);
        timeLabel = [NSString stringWithFormat:@"%1ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    } else if (timeSeconds/600 >= 1) { //are we talking two-digit minutes?
        NSInteger ti = (NSInteger)timeSeconds;
        NSInteger seconds = ti % 60;
        NSInteger minutes = (ti / 60) % 60;
        timeLabel = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    } else if (timeSeconds/60 >= 1) { //are we talking one-digit minutes?
        NSInteger ti = (NSInteger)timeSeconds;
        NSInteger seconds = ti % 60;
        NSInteger minutes = (ti / 60) % 60;
        timeLabel = [NSString stringWithFormat:@"%1ld:%02ld", (long)minutes, (long)seconds];
    } else if (timeSeconds > 0) { // are we talking seconds?
        NSInteger ti = (NSInteger)timeSeconds;
        NSInteger seconds = ti % 60;
        timeLabel = [NSString stringWithFormat:@"0:%02ld", (long)seconds];
    } else {
        timeLabel = @"0:00";
    }
    return timeLabel;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)awayPlusSix:(id)sender {
    awayScore += 6;
    [_awayScoreControl setStringValue:[NSString stringWithFormat:@"Away: %d", awayScore]];
    [self updateDisplayScore];
}

- (IBAction)awayPlusThree:(id)sender {
    awayScore += 3;
    [_awayScoreControl setStringValue:[NSString stringWithFormat:@"Away: %d", awayScore]];
    [self updateDisplayScore];
}

- (IBAction)awayPlusOne:(id)sender {
    awayScore += 1;
    [_awayScoreControl setStringValue:[NSString stringWithFormat:@"Away: %d", awayScore]];
    [self updateDisplayScore];
}

- (IBAction)awayMinusOne:(id)sender {
    if (awayScore > 0) {
        awayScore -= 1;
        [_awayScoreControl setStringValue:[NSString stringWithFormat:@"Away: %d", awayScore]];
    }
    [self updateDisplayScore];
}

- (IBAction)homePlusSix:(id)sender {
    homeScore += 6;
    [_homeScoreControl setStringValue:[NSString stringWithFormat:@"Home: %d", homeScore]];
    [self updateDisplayScore];
}

- (IBAction)homePlusThree:(id)sender {
    homeScore += 3;
    [_homeScoreControl setStringValue:[NSString stringWithFormat:@"Home: %d", homeScore]];
    [self updateDisplayScore];
}

- (IBAction)homePlusOne:(id)sender {
    homeScore += 1;
    [_homeScoreControl setStringValue:[NSString stringWithFormat:@"Home: %d", homeScore]];
    [self updateDisplayScore];
}

- (IBAction)homeMinusOne:(id)sender {
    if (homeScore > 0) {
        homeScore -= 1;
        [_homeScoreControl setStringValue:[NSString stringWithFormat:@"Home: %d", homeScore]];
    }
    [self updateDisplayScore];
}

- (IBAction)minusOneSecond:(id)sender {
    if (timeSeconds > 1) {
        timeSeconds -= 1;
        [_clockControl setStringValue:[self getTimeString:timeSeconds]];
    }
    [self updateDisplayClock];
}

- (IBAction)minusTenSeconds:(id)sender {
    if (timeSeconds > 10) {
        timeSeconds -= 10;
        [_clockControl setStringValue:[self getTimeString:timeSeconds]];
    }
    [self updateDisplayClock];
}

- (IBAction)minusOneMinute:(id)sender {
    if (timeSeconds > 60) {
        timeSeconds -= 60;
        [_clockControl setStringValue:[self getTimeString:timeSeconds]];
    }
    [self updateDisplayClock];
}

- (IBAction)plusOneSecond:(id)sender {
    timeSeconds += 1;
    [_clockControl setStringValue:[self getTimeString:timeSeconds]];
    [self updateDisplayClock];
}

- (IBAction)plusTenSeconds:(id)sender {
    timeSeconds += 10;
    [_clockControl setStringValue:[self getTimeString:timeSeconds]];
    [self updateDisplayClock];
}

- (IBAction)plusOneMinute:(id)sender {
    timeSeconds += 60;
    [_clockControl setStringValue:[self getTimeString:timeSeconds]];
    [self updateDisplayClock];}

- (IBAction)minusQuarter:(id)sender {
    if (quarter > 1) {
        quarter--;
    }
    if (quarter == 1) {
        [_quarterControl setStringValue:@"1st Qtr"];
    } else if (quarter == 2) {
        [_quarterControl setStringValue:@"End 1st"];
    } else if (quarter == 3) {
        [_quarterControl setStringValue:@"2nd Qtr"];
    } else if (quarter == 4) {
        [_quarterControl setStringValue:@"Half"];
    } else if (quarter == 5) {
        [_quarterControl setStringValue:@"3rd Qtr"];
    } else if (quarter == 6) {
        [_quarterControl setStringValue:@"End 3rd"];
    } else if (quarter == 7) {
        [_quarterControl setStringValue:@"4th Qtr"];
    } else if (quarter == 8) {
        [_quarterControl setStringValue:@"Final"];
    } else if (quarter == 9) {
        [_quarterControl setStringValue:@"End Reg"];
    } else if (quarter == 10) {
        [_quarterControl setStringValue:@"OT"];
    } else if (quarter == 11) {
        [_quarterControl setStringValue:@"F/OT"];
    } else if (quarter == 12) {
        [_quarterControl setStringValue:@"End 1OT"];
    } else if (quarter == 13) {
        [_quarterControl setStringValue:@"2 OT"];
    } else if (quarter == 14) {
        [_quarterControl setStringValue:@"F/2OT"];
    }
    [self updateDisplayQuarter];
}

- (IBAction)plusQuarter:(id)sender {
    if (quarter < 14) {
        quarter++;
    }
    if (quarter == 1) {
        [_quarterControl setStringValue:@"1st Qtr"];
    } else if (quarter == 2) {
        [_quarterControl setStringValue:@"End 1st"];
    } else if (quarter == 3) {
        [_quarterControl setStringValue:@"2nd Qtr"];
    } else if (quarter == 4) {
        [_quarterControl setStringValue:@"Half"];
    } else if (quarter == 5) {
        [_quarterControl setStringValue:@"3rd Qtr"];
    } else if (quarter == 6) {
        [_quarterControl setStringValue:@"End 3rd"];
    } else if (quarter == 7) {
        [_quarterControl setStringValue:@"4th Qtr"];
    } else if (quarter == 8) {
        [_quarterControl setStringValue:@"Final"];
    } else if (quarter == 9) {
        [_quarterControl setStringValue:@"End Reg"];
    } else if (quarter == 10) {
        [_quarterControl setStringValue:@"OT"];
    } else if (quarter == 11) {
        [_quarterControl setStringValue:@"F/OT"];
    } else if (quarter == 12) {
        [_quarterControl setStringValue:@"End 1OT"];
    } else if (quarter == 13) {
        [_quarterControl setStringValue:@"2 OT"];
    } else if (quarter == 14) {
        [_quarterControl setStringValue:@"F/2OT"];
    }
    [self updateDisplayQuarter];
}

- (IBAction)showTimeout:(id)sender {
}

- (IBAction)showFlag:(id)sender {
}

- (IBAction)showTouchdown:(id)sender {
}

- (IBAction)startClock:(id)sender {
    if (clockRunning) {
        clockRunning = false;
        [clockTimer invalidate];
        clockTimer = nil;
    } else {
        NSLog(@"hi");
        clockRunning = true;
        clockTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runClock) userInfo:self repeats:YES];
    }
}

- (void) runClock {
    if (timeSeconds > 1) {
        timeSeconds--;
        [_clockControl setStringValue:[self getTimeString:timeSeconds]];
    } else {
        if (clockRunning) {
            [self startClock:self];
        }
        timeSeconds = 0;
        [_clockControl setStringValue:@"0:00"];
    }
    [self updateDisplayClock];
}

- (IBAction)resetClock:(id)sender {
    if (clockRunning) {
        [self startClock:self];
    }
    timeSeconds = 720;
    [_clockControl setStringValue:@"12:00"];
    [self updateDisplayClock];
}

- (IBAction)showReplay:(id)sender {
    if (replayShowing) {
        [_replayImage setHidden:YES];
        replayShowing = false;
        [_replayButton setTitle:@"Show Replay"];
        [_replayControl setStringValue:@"Hidden"];
        [_replayControl setTextColor:black];
    } else {
        [_replayImage setHidden:NO];
        replayShowing = true;
        [_replayButton setTitle:@"Hide Replay"];
        [_replayControl setStringValue:@"Showing"];
        [_replayControl setTextColor:red];
    }
}

- (IBAction)hideClock:(id)sender {
    if (clockShowing) {
        clockShowing = false;
        [_clockShowingControl setStringValue:@"Hidden"];
        [_clockShowingControl setTextColor:red];
        [_clockButton setTitle:@"Show Clock"];
        [self updateDisplayClock];
    } else {
        clockShowing = true;
        [_clockShowingControl setStringValue:@"Showing"];
        [_clockShowingControl setTextColor:green];
        [_clockButton setTitle:@"Show Clock"];
        [self updateDisplayClock];
    }
}

- (IBAction)hideScorebug:(id)sender {
    if (scorebugShowing) {
        [self concealScorebug];
        scorebugShowing = false;
        [_scorebugButton setTitle:@"Show Scorebug"];
        [_scorebugShowingControl setStringValue:@"Hidden"];
        [_scorebugShowingControl setTextColor:red];
    } else {
        if (locatorShowing) {
            [self showLocator:self];
        }
        if (scoreboardShowing) {
            [self showScoreboard:self];
        }
        [self concealScorebug];
        [_scorebugButton setTitle:@"Hide Scorebug"];
        [_scorebugShowingControl setStringValue:@"Showing"];
        [_scorebugShowingControl setTextColor:green];
        scorebugShowing = true;
    }
}

- (IBAction)hideDown:(id)sender {
    if (downShowing) {
        downShowing = false;
        [_downShowingControl setStringValue:@"Hidden"];
        [_downShowingControl setTextColor:red];
        [_downButton setTitle:@"Show Do&D"];
        [self updateDisplayDown];
    } else {
        downShowing = true;
        [_downShowingControl setStringValue:@"Showing"];
        [_downShowingControl setTextColor:green];
        [_downButton setTitle:@"Hide Do&D"];
        [self updateDisplayDown];
    }
}

- (IBAction)plusDown:(id)sender {
    justDown = false;
    if (down < 4) {
        down++;
    }
    [_downControl setStringValue:[NSString stringWithFormat:@"%d", down]];
}

- (IBAction)minusDown:(id)sender {
    justDown = false;
    if (down > 1) {
        down--;
    }
    [_downControl setStringValue:[NSString stringWithFormat:@"%d", down]];
}

- (IBAction)plusDistance:(id)sender {
    justDown = false;
    distance++;
    [_distanceControl setStringValue:[NSString stringWithFormat:@"%d", distance]];
    andGoal = false;
}

- (IBAction)minusDistance:(id)sender {
    justDown = false;
    if (distance > 1) {
        distance--;
    }
    [_distanceControl setStringValue:[NSString stringWithFormat:@"%d", distance]];
    andGoal = false;
}

- (IBAction)resetDown:(id)sender {
    justDown = false;
    andGoal = false;
    down = 1;
    distance = 10;
    [_downControl setStringValue:@"1"];
    [_distanceControl setStringValue:@"10"];
    [_downAndDistanceControl setStringValue:@"1st & 10"];
    [self updateDisplayDown];
}

- (IBAction)justDown:(id)sender {
    justDown = true;
    if (down == 1) {
        [_downAndDistanceControl setStringValue:[NSString stringWithFormat:@"1st Down"]];
    }
    if (down == 2) {
        [_downAndDistanceControl setStringValue:[NSString stringWithFormat:@"2nd Down"]];
    }
    if (down == 3) {
        [_downAndDistanceControl setStringValue:[NSString stringWithFormat:@"3rd Down"]];
    }
    if (down == 4) {
        [_downAndDistanceControl setStringValue:[NSString stringWithFormat:@"4th Down"]];
    }
    [self updateDisplayDown];
    justDown = false;
}

- (IBAction)updateDown:(id)sender {
    justDown = false;
    if (!andGoal) {
        if (down == 1) {
            [_downAndDistanceControl setStringValue:[NSString stringWithFormat:@"1st & %d", distance]];
        }
        if (down == 2) {
            [_downAndDistanceControl setStringValue:[NSString stringWithFormat:@"2nd & %d", distance]];
        }
        if (down == 3) {
            [_downAndDistanceControl setStringValue:[NSString stringWithFormat:@"3rd & %d", distance]];
        }
        if (down == 4) {
            [_downAndDistanceControl setStringValue:[NSString stringWithFormat:@"4th & %d", distance]];
        }
    } else {
        if (down == 1) {
            [_downAndDistanceControl setStringValue:[NSString stringWithFormat:@"1st & G"]];
        }
        if (down == 2) {
            [_downAndDistanceControl setStringValue:[NSString stringWithFormat:@"2nd & G"]];
        }
        if (down == 3) {
            [_downAndDistanceControl setStringValue:[NSString stringWithFormat:@"3rd & G"]];
        }
        if (down == 4) {
            [_downAndDistanceControl setStringValue:[NSString stringWithFormat:@"4th & G"]];
        }
    }
    [self updateDisplayDown];
}

- (IBAction)andGoal:(id)sender {
    if (!andGoal) {
        andGoal = true;
        [_distanceControl setStringValue:@"G"];
    } else {
        andGoal = false;
        [_distanceControl setStringValue:[NSString stringWithFormat:@"%d", distance]];
    }
}


- (void)updateDisplayClock {
    if (clockShowing) {
        [_clockDisplay setStringValue:[self getTimeString:timeSeconds]];
    } else {
        [_clockDisplay setStringValue:@""];
    }
}

- (void)updateDisplayDown {
    if (downShowing) {
        if (justDown) {
            if (down == 1) {
                [_downDisplay setStringValue:[NSString stringWithFormat:@"1st Down"]];
            }
            if (down == 2) {
                [_downDisplay setStringValue:[NSString stringWithFormat:@"2nd Down"]];
            }
            if (down == 3) {
                [_downDisplay setStringValue:[NSString stringWithFormat:@"3rd Down"]];
            }
            if (down == 4) {
                [_downDisplay setStringValue:[NSString stringWithFormat:@"4th Down"]];
            }
        } else {
            if (!andGoal) {
                if (down == 1) {
                    [_downDisplay setStringValue:[NSString stringWithFormat:@"1st & %d", distance]];
                }
                if (down == 2) {
                    [_downDisplay setStringValue:[NSString stringWithFormat:@"2nd & %d", distance]];
                }
                if (down == 3) {
                    [_downDisplay setStringValue:[NSString stringWithFormat:@"3rd & %d", distance]];
                }
                if (down == 4) {
                    [_downDisplay setStringValue:[NSString stringWithFormat:@"4th & %d", distance]];
                }
            } else {
                if (down == 1) {
                    [_downDisplay setStringValue:[NSString stringWithFormat:@"1st & G"]];
                }
                if (down == 2) {
                    [_downDisplay setStringValue:[NSString stringWithFormat:@"2nd & G"]];
                }
                if (down == 3) {
                    [_downDisplay setStringValue:[NSString stringWithFormat:@"3rd & G"]];
                }
                if (down == 4) {
                    [_downDisplay setStringValue:[NSString stringWithFormat:@"4th & G"]];
                }
            }
        }
    } else {
        [_downDisplay setStringValue:@""];
    }
    
}

- (void)updateDisplayScore {
    [_homeScoreDisplay setStringValue:[NSString stringWithFormat:@"%d", homeScore]];
    [_awayScoreDisplay setStringValue:[NSString stringWithFormat:@"%d", awayScore]];
    if (scoreboardShowing) {
        [self showScoreboard:self];
        [self showScoreboard:self];
    }
}

- (void)updateDisplayQuarter {
    if (quarter == 1) {
        [_quarterDisplay setStringValue:@"1st Qtr"];
    } else if (quarter == 2) {
        [_quarterDisplay setStringValue:@"End 1st"];
    } else if (quarter == 3) {
        [_quarterDisplay setStringValue:@"2nd Qtr"];
    } else if (quarter == 4) {
        [_quarterDisplay setStringValue:@"Half"];
    } else if (quarter == 5) {
        [_quarterDisplay setStringValue:@"3rd Qtr"];
    } else if (quarter == 6) {
        [_quarterDisplay setStringValue:@"End 3rd"];
    } else if (quarter == 7) {
        [_quarterDisplay setStringValue:@"4th Qtr"];
    } else if (quarter == 8) {
        [_quarterDisplay setStringValue:@"Final"];
    } else if (quarter == 9) {
        [_quarterDisplay setStringValue:@"End Reg"];
    } else if (quarter == 10) {
        [_quarterDisplay setStringValue:@"OT"];
    } else if (quarter == 11) {
        [_quarterDisplay setStringValue:@"F/OT"];
    } else if (quarter == 12) {
        [_quarterDisplay setStringValue:@"End 1OT"];
    } else if (quarter == 13) {
        [_quarterDisplay setStringValue:@"2 OT"];
    } else if (quarter == 14) {
        [_quarterDisplay setStringValue:@"F/2OT"];
    }
    if (scoreboardShowing) {
        [self showScoreboard:self];
        [self showScoreboard:self];
    }
}




- (IBAction)enterFullScreen:(id)sender {
    [_displayWindow toggleFullScreen:nil];
}


- (IBAction)displayEnterFullScreen:(id)sender {
    [_displayFullScreenButton setTransparent:YES];
    [_displayFullScreenButton setEnabled:NO];
    [_displayWindow toggleFullScreen:nil];

}
- (IBAction)showLocator:(id)sender {
    if (locatorShowing) {
        [self concealScoreboard];
        [_locatorShowingControl setStringValue:@"Hidden"];
        [_locatorShowingControl setTextColor:black];
        [_locatorHomeName setStringValue:@""];
        [_locatorHomeScore setStringValue:@""];
        [_locatorAwayName setStringValue:@""];
        [_locatorAwayScore setStringValue:@""];
        [_locatorQuarter setStringValue:@""];
        [_locatorShowingControl setTextColor:black];
        [_locatorShowingControl setStringValue:@"Hidden"];
        [_showLocatorButton setTitle:@"Show Locator"];
        locatorShowing = false;
    } else {
        [_locatorShowingControl setStringValue:@"Showing"];
        [_locatorShowingControl setTextColor:green];
        if (scoreboardShowing) {
            [self showScoreboard:self];
        }
        if (scorebugShowing) {
            [self hideScorebug:self];
        }
        [self concealScoreboard];
        [_locatorHomeName setStringValue:homeName];
        [_locatorHomeScore setStringValue:homeRecord];
        [_locatorAwayName setStringValue:awayName];
        [_locatorAwayScore setStringValue:awayRecord];
        [_locatorQuarter setStringValue:location];
        [_locatorShowingControl setTextColor:red];
        [_locatorShowingControl setStringValue:@"Showing"];
        [_showLocatorButton setTitle:@"Hide Locator"];
        locatorShowing = true;
    }
}

- (IBAction)showScoreboard:(id)sender {
    if (scoreboardShowing) {
        [self concealScoreboard];
        [_scoreboardShowingControl setStringValue:@"Hidden"];
        [_scoreboardShowingControl setTextColor:black];
        [_locatorHomeName setStringValue:@""];
        [_locatorHomeScore setStringValue:@""];
        [_locatorAwayName setStringValue:@""];
        [_locatorAwayScore setStringValue:@""];
        [_locatorQuarter setStringValue:@""];
        [_showScoreboardButton setTitle:@"Show Scoreboard"];
        [_scoreboardShowingControl setStringValue:@"Hidden"];
        [_scoreboardShowingControl setTextColor:black];
        scoreboardShowing = false;
    } else {
        [_scoreboardShowingControl setStringValue:@"Showing"];
        [_scoreboardShowingControl setTextColor:green];
        if (locatorShowing) {
            [self showLocator:self];
        }
        if (scorebugShowing) {
            [self hideScorebug:self];
        }
        [self concealScoreboard];
        [_locatorHomeName setStringValue:homeName];
        [_locatorHomeScore setStringValue:[NSString stringWithFormat:@"%d", homeScore]];
        [_locatorAwayName setStringValue:awayName];
        [_locatorAwayScore setStringValue:[NSString stringWithFormat:@"%d", awayScore]];
        if (quarter == 1) {
            [_locatorQuarter setStringValue:@"1st Quarter"];
        } else if (quarter == 2) {
            [_locatorQuarter setStringValue:@"End 1st Quarter"];
        } else if (quarter == 3) {
            [_locatorQuarter setStringValue:@"2nd Quarter"];
        } else if (quarter == 4) {
            [_locatorQuarter setStringValue:@"Halftime"];
        } else if (quarter == 5) {
            [_locatorQuarter setStringValue:@"3rd Quarter"];
        } else if (quarter == 6) {
            [_locatorQuarter setStringValue:@"End 3rd Quarter"];
        } else if (quarter == 7) {
            [_locatorQuarter setStringValue:@"4th Quarter"];
        } else if (quarter == 8) {
            [_locatorQuarter setStringValue:@"Final"];
        } else if (quarter == 9) {
            [_locatorQuarter setStringValue:@"End Regulation"];
        } else if (quarter == 10) {
            [_locatorQuarter setStringValue:@"Overtime"];
        } else if (quarter == 11) {
            [_locatorQuarter setStringValue:@"Final/Overtime"];
        } else if (quarter == 12) {
            [_locatorQuarter setStringValue:@"End 1 Overtime"];
        } else if (quarter == 13) {
            [_locatorQuarter setStringValue:@"2 Overtime"];
        } else if (quarter == 14) {
            [_locatorQuarter setStringValue:@"Final/2 Overtime"];
        }
        [_showScoreboardButton setTitle:@"Hide Scoreboard"];
        [_scoreboardShowingControl setStringValue:@"Showing"];
        [_scoreboardShowingControl setTextColor:red];
        scoreboardShowing = true;
    }
}

- (void) concealScorebug {
    if (scorebugShowing) {
        [_awayNameDisplay setHidden:YES];
        [_awayScoreDisplay setHidden:YES];
        [_homeNameDisplay setHidden:YES];
        [_homeScoreDisplay setHidden:YES];
        [_downDisplay setHidden:YES];
        [_quarterDisplay setHidden:YES];
        [_clockDisplay setHidden:YES];
        [_scorebugBackground setHidden:YES];
    } else {
        [_awayNameDisplay setHidden:NO];
        [_awayScoreDisplay setHidden:NO];
        [_homeNameDisplay setHidden:NO];
        [_homeScoreDisplay setHidden:NO];
        [_downDisplay setHidden:NO];
        [_quarterDisplay setHidden:NO];
        [_clockDisplay setHidden:NO];
        [_scorebugBackground setHidden:NO];
    }

}

- (void) concealScoreboard {
    if (scoreboardShowing || locatorShowing) {
        [_locatorAwayName setHidden:YES];
        [_locatorAwayScore setHidden:YES];
        [_locatorHomeName setHidden:YES];
        [_locatorHomeScore setHidden:YES];
        [_locatorQuarter setHidden:YES];
        [_scoreboardBackground setHidden:YES];
    } else {
        [_locatorAwayName setHidden:NO];
        [_locatorAwayScore setHidden:NO];
        [_locatorHomeName setHidden:NO];
        [_locatorHomeScore setHidden:NO];
        [_locatorQuarter setHidden:NO];
        [_scoreboardBackground setHidden:NO];
    }
    
}

@end
