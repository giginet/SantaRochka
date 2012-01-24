//
//  MainLayer.h
//  SantaRochka
//
//  Created by  on 2012/1/22.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "heqet.h"

@interface MainLayer : KWLayer {
  int score_;
  double interval_;
  BOOL isYes_;
  BOOL isTouched_;
  CCLabelTTF* scoreLabel_;
  CCSprite* balloon_;
  CCSprite* rochka_;
  CCLayer* mainLayer_;
  KWTimer* timer_;
}

@end