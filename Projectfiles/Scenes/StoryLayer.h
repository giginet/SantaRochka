//
//  StoryLayer.h
//  SantaRochka
//
//  Created by  on 2012/1/25.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "KWLayer.h"

@interface StoryLayer : KWLayer {
  int phase_;
  int max_;
  CCSprite* jed_;
  CCSprite* rochka_;
  CCLabelTTF* text_;
  NSDictionary* storyData_;
}

@end
