//
//  TitleLayer.m
//  SantaRochka
//
//  Created by  on 2012/1/22.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "TitleLayer.h"

@implementation TitleLayer

- (id)init {
  self = [super init];
  if (self) {
    CCDirector* director = [CCDirector sharedDirector];
    //CCLayer* mainLayer = [[CCLayer alloc] init];
    CCSprite* background = [CCSprite spriteWithFile:@"title.png"];
    background.position = director.screenCenter;
    [self addChild:background];
    
    id play = [CCMenuItemImage itemFromNormalImage:@"play.png" 
                                     selectedImage:@"play_selected.png" 
                                             block:^(id sender){} ];
    id howto = [CCMenuItemImage itemFromNormalImage:@"howto.png" 
                                      selectedImage:@"howto_selected.png" 
                                              block:^(id sender){} ];
    id story = [CCMenuItemImage itemFromNormalImage:@"story.png" 
                                      selectedImage:@"story_selected.png" 
                                              block:^(id sender){} ];
    
    CCMenu* menu = [CCMenu menuWithItems:play, howto, story, nil];
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
