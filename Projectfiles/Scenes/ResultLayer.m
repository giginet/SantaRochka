//
//  ResultLayer.m
//  SantaRochka
//
//  Created by  on 2012/1/22.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "TitleLayer.h"
#import "MainLayer.h"
#import "ResultLayer.h"

@interface ResultLayer()
- (int)getRank:(int)score;
@end

@implementation ResultLayer

- (id)init {
  self = [self initWithScore:0];
  return self;
}

- (id)initWithScore:(int)score {
  self = [super init];
  if (self) {
    CCSprite* bg = [CCSprite spriteWithFile:@"result.png"];
    bg.position = ccp(240, 180);
    [self addChild:bg];
    
    CGSize labelSize = CGSizeMake(300, 20);
    ccColor3B labelColor = ccc3(20, 20, 20);
    NSString* labelFont = @"HiraKakuProN-W6";
    CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d円", score]
                                              dimensions:labelSize 
                                               alignment:UITextAlignmentLeft
                                                fontName:labelFont
                                                fontSize:10];
    scoreLabel.position = ccp(270, 185);
    scoreLabel.color = labelColor;
    [self addChild:scoreLabel];
    
    int rank = [self getRank:score];
    NSString* ranks[] = {@"D", @"C", @"B", @"A", @"S", @"SSS"};
    NSString* titles[] = {
      @"へたれ見習いサンタ", 
      @"お手伝いさん", 
      @"期待の新人", 
      @"サンタ試験 1級（ジェドよりすごい）", 
      @"レジェンド・オブ・サンタ", 
      @"全てを超えし者（神）"
    }; // 時間があったらLuaに移植したい
    int rochkas[] = {1, 4, 3, 0, 5, 5};
    
    CCLabelTTF* rankLabel = [CCLabelTTF labelWithString:ranks[rank] 
                                             dimensions:labelSize 
                                              alignment:UITextAlignmentLeft 
                                               fontName:labelFont
                                               fontSize:10];
    rankLabel.position = ccp(270, 168);
    rankLabel.color = labelColor;
    [self addChild:rankLabel];
    CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:titles[rank] 
                                              dimensions:labelSize 
                                               alignment:UITextAlignmentLeft 
                                                fontName:labelFont
                                                fontSize:10];
    titleLabel.position = ccp(270, 151);
    titleLabel.color = labelColor;
    [self addChild:titleLabel];
    
    CCSprite* rochka = [CCSprite spriteWithFile:@"rochka_story.png"];
    float width = rochka.textureRect.size.width / 7;
    [rochka setTextureRect:CGRectMake(width * rochkas[rank], 
                                      0, 
                                      width, 
                                      rochka.textureRect.size.height)];
    rochka.position = ccp(390, 180);
    [self addChild:rochka];
    
    CCSprite* frame = [CCSprite spriteWithFile:@"result_frame.png"];
    frame.position = ccp(240, 160);
    [self addChild:frame];
    
    __block CCDirector* director = [CCDirector sharedDirector];
    CCMenuItemImage* replay = [CCMenuItemImage itemFromNormalImage:@"replay.png" 
                                                     selectedImage:@"replay_selected.png" 
                                                             block:^(id sender){
                                                               [director popScene];
                                                             }];
    CCMenuItemImage* title = [CCMenuItemImage itemFromNormalImage:@"title.png" 
                                                    selectedImage:@"title_selected.png" 
                                                            block:^(id sender){
                                                              CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                                                                                scene:[TitleLayer nodeWithScene]];
                                                              [director replaceScene:transition];
                                                            }];
    CCMenu* menu = [CCMenu menuWithItems:replay, title, nil];
    [menu alignItemsHorizontally];
    menu.position = ccp(380, 20);
    [self addChild:menu];
    
  }
  return self;
}

- (int)getRank:(int)score {
  if (score < 500){
    return 0;
  } else if (score < 1000){
    return 1;
  } else if (score < 5000){
    return 2;
  } else if (score < 10000){
    return 3;
  } else if (score <= 100000){
    return 4;
  }
  return 5;
}

@end
