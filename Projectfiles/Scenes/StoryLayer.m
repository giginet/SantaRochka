//
//  StoryLayer.m
//  SantaRochka
//
//  Created by  on 2012/1/25.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "TitleLayer.h"
#import "StoryLayer.h"

@interface StoryLayer()
- (void)setPhase:(int)phase;
@end

@implementation StoryLayer

- (id)init {
  self = [super init];
  if (self) {
    phase_ = 1;
    storyData_ = [KKLua loadLuaTableFromFile:@"story.lua"];
    max_ = [(NSDictionary*)[storyData_ objectForKey:@"texts"] count];
    
    CCDirector* director = [CCDirector sharedDirector];
    CCSprite* bg = [CCSprite spriteWithFile:@"background_story.jpg"];
    bg.position = director.screenCenter;
    [self addChild:bg];
    
    jed_ = [CCSprite spriteWithFile:@"jed_story.png"];
    jed_.position = ccp(130, 160);
    [self addChild:jed_];
    
    rochka_ = [CCSprite spriteWithFile:@"rochka_story.png"];
    rochka_.position = ccp(330, 160);
    [self addChild:rochka_];
    
    CCSprite* frame = [CCSprite spriteWithFile:@"story_frame.png"];
    frame.position = director.screenCenter;
    [self addChild:frame];
    
    text_ = [CCLabelTTF labelWithString:@"" 
                             dimensions:CGSizeMake(370, 75) 
                              alignment:UITextAlignmentLeft 
                          lineBreakMode:UILineBreakModeWordWrap 
                               fontName:@"HiraKakuProN-W6" 
                               fontSize:9];
    text_.position = ccp(240, 45);
    text_.color = ccc3(220, 220, 220);
    [self addChild:text_];
    
    CCMenuItemImage* title = [CCMenuItemImage itemFromNormalImage:@"title.png" 
                                                    selectedImage:@"title_selected.png" 
                                                            block:^(id sender){
                                                              CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                                                                                scene:[TitleLayer nodeWithScene]];
                                                              [[CCDirector sharedDirector] pushScene:transition];
                                                            }];
    CCMenu* menu = [CCMenu menuWithItems:title, nil];
    menu.position = ccp(415, 290);
    [self addChild:menu];
    
    [self setPhase:phase_];
    self.isTouchEnabled = YES;
  }
  return self;
}

- (void)setPhase:(int)phase {
  NSDictionary* story = [storyData_ objectForKey:@"texts"];
  NSString* text = [story objectForKey:[NSString stringWithFormat:@"%d", phase_]];
  NSDictionary* jed = [storyData_ objectForKey:@"jed"];
  NSDictionary* rochka = [storyData_ objectForKey:@"rochka"];
  [text_ setString:text];
  int jedIndex = [(NSNumber*)[jed objectForKey:[NSString stringWithFormat:@"%d", phase_]] intValue];
  CGSize jedSize = jed_.texture.contentSize;
  int col = jedIndex % 5;
  int row = (int)jedIndex / 5;
  [jed_ setTextureRect:CGRectMake(jedSize.width / 5 * col, 
                                  jedSize.height / 2 * row, 
                                  jedSize.width / 5, 
                                  jedSize.height / 2)];
  
  int rochkaIndex = [(NSNumber*)[rochka objectForKey:[NSString stringWithFormat:@"%d", phase_]] intValue];
  CGSize rochkaSize = rochka_.texture.contentSize;
  [rochka_ setTextureRect:CGRectMake(rochkaSize.width / 7 * rochkaIndex, 
                                     0, 
                                     rochkaSize.width / 7, 
                                     rochkaSize.height)];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  if (phase_ < max_) {
    [self setPhase:++phase_];
  } else {
    CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                      scene:[TitleLayer nodeWithScene]];
    [[CCDirector sharedDirector] pushScene:transition];
  }
  return YES;
}
@end
