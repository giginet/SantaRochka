//
//  TitleLayer.m
//  SantaRochka
//
//  Created by  on 2012/1/22.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "TitleLayer.h"
#import "StoryLayer.h"
#import "HowtoLayer.h"
#import "MainLayer.h"

@implementation TitleLayer

- (id)init {
  self = [super init];
  if (self) {
    __block CCDirector* director = [CCDirector sharedDirector];
    CCSprite* background = [CCSprite spriteWithFile:@"title_bg.png"];
    background.position = director.screenCenter;
    [self addChild:background];
    
    id story = [CCMenuItemImage itemFromNormalImage:@"story.png" 
                                      selectedImage:@"story_selected.png" 
                                              block:^(id sender){
                                                CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                                                                  scene:[StoryLayer nodeWithScene]];
                                                [[CCDirector sharedDirector] pushScene:transition];
                                              } ];
    id howto = [CCMenuItemImage itemFromNormalImage:@"howto.png" 
                                      selectedImage:@"howto_selected.png" 
                                              block:^(id sender){
                                                CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                                                                  scene:[HowtoLayer nodeWithScene]];
                                                [[CCDirector sharedDirector] pushScene:transition];
                                              } ];
    id play = [CCMenuItemImage itemFromNormalImage:@"play.png" 
                                     selectedImage:@"play_selected.png" 
                                             block:^(id sender){
                                               CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                                                                 scene:[MainLayer nodeWithScene]];
                                               [[CCDirector sharedDirector] pushScene:transition];
                                             } ];
    CCMenu* menu = [CCMenu menuWithItems:story, howto, play, nil];
    [menu alignItemsVertically];
    menu.position = CGPointMake(120, 180);
    [self addChild:menu];
    CCSprite* frame = [CCSprite spriteWithFile:@"title_frame.png"];
  
    CCParticleSystemQuad* snow = [CCParticleSystemQuad particleWithFile:@"snow.plist"];
    snow.position = ccp(240, 320);
    [self addChild:snow];
    
    frame.position = director.screenCenter;
    [self addChild:frame];
    
    CCLabelTTF* highScoreLabel = [CCLabelTTF labelWithString:@"HIGH SCORE" 
                                                  dimensions:CGSizeMake(100, 20) 
                                                   alignment:UITextAlignmentRight 
                                                    fontName:@"Marker Felt" 
                                                    fontSize:16];
    highScoreLabel.position = ccp(70, 300);
    highScoreLabel.color = ccc3(128, 128, 128);
    [self addChild:highScoreLabel];
    
    int score = [[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"];
    CCLabelTTF* highScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", score]
                                             dimensions:CGSizeMake(100, 20) 
                                              alignment:UITextAlignmentLeft
                                               fontName:@"Marker Felt" 
                                               fontSize:16];
    highScore.position = ccp(180, 300);
    highScore.color = ccc3(128, 128, 128);
    
    [self addChild:highScore];
  }
  return self;
}

@end
