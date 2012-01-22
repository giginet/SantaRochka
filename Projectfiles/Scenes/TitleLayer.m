//
//  TitleLayer.m
//  SantaRochka
//
//  Created by  on 2012/1/22.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "TitleLayer.h"
#import "MainLayer.h"

@implementation TitleLayer

- (id)init {
  self = [super init];
  if (self) {
    __block CCDirector* director = [CCDirector sharedDirector];
    CCSprite* background = [CCSprite spriteWithFile:@"title.png"];
    background.position = director.screenCenter;
    [self addChild:background];
    
    id howto = [CCMenuItemImage itemFromNormalImage:@"howto.png" 
                                      selectedImage:@"howto_selected.png" 
                                              block:^(id sender){} ];
    id story = [CCMenuItemImage itemFromNormalImage:@"story.png" 
                                      selectedImage:@"story_selected.png" 
                                              block:^(id sender){} ];
    id play = [CCMenuItemImage itemFromNormalImage:@"play.png" 
                                     selectedImage:@"play_selected.png" 
                                             block:^(id sender){
                                               CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                                                                 scene:[MainLayer nodeWithScene]];
                                               [[CCDirector sharedDirector] pushScene:transition];
                                             } ];
    
    CCMenu* menu = [CCMenu menuWithItems:howto, story, play, nil];
    [menu alignItemsVertically];
    menu.position = CGPointMake(120, 180);
    [self addChild:menu];
    CCSprite* frame = [CCSprite spriteWithFile:@"title_frame.png"];
    
    frame.position = director.screenCenter;
    [self addChild:frame];
  }
  return self;
}

@end
