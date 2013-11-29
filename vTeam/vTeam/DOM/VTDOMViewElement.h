//
//  VTDOMViewElement.h
//  vTeam
//
//  Created by zhang hailong on 13-8-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/vTeam.h>

@interface VTDOMViewElement : VTDOMElement<IVTAction>

@property(nonatomic,retain) UIView * view;

@property(nonatomic,readonly,getter = isViewLoaded) BOOL viewLoaded;

@end
