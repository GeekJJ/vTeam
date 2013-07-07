//
//  VTTabBarController.m
//  vTeam
//
//  Created by zhang hailong on 13-7-5.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTabBarController.h"

#import "NSURL+QueryValue.h"

@interface VTTabBarController ()

@end

@implementation VTTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@synthesize context = _context;
@synthesize parentController = _parentController;
@synthesize config = _config;
@synthesize alias = _alias;
@synthesize url = _url;
@synthesize styleContainer = _styleContainer;
@synthesize dataOutletContainer = _dataOutletContainer;
@synthesize basePath = _basePath;
@synthesize layoutContainer = _layoutContainer;
@synthesize scheme = _scheme;

-(BOOL) isDisplaced{
    return _parentController == nil && ( ![self isViewLoaded] || self.view.superview == nil);
}

-(void) dealloc{
    [_config release];
    [_alias release];
    [_url release];
    [_basePath release];
    [_styleContainer release];
    [_dataOutletContainer release];
    [_layoutContainer release];
    [_scheme release];
    [super dealloc];
}


-(void) setConfig:(id)config{
    if(_config != config){
        [_config release];
        _config = [config retain];
        
        id v = [config valueForKey:@"scheme"];
        
        if(v){
            self.scheme = v;
        }
        
        NSArray * items = [config valueForKeyPath:@"items"];
        
        NSMutableArray * viewControllers = [NSMutableArray arrayWithCapacity:4];
        
        for (id item in items) {
            if([item valueForKey:@"url"]){
                id viewController = [self.context getViewController:[NSURL URLWithString:[item valueForKey:@"url"]] basePath:@"/"];
                if(viewController){
                    if([item valueForKey:@"title"]){
                        [[viewController tabBarItem] setTitle:[item valueForKey:@"title"]];
                    }
                    if([item valueForKey:@"image"]){
                        [[viewController tabBarItem] setImage:[UIImage imageNamed:[item valueForKey:@"image"]]];
                    }
                    [viewController setParentController:self];
                    [viewControllers addObject:viewController];
                }
                
            }
        }
        
        [self setViewControllers:viewControllers];
    }
}

-(void) reloadURL{

}

-(BOOL) canOpenUrl:(NSURL *)url{
    
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"tab";
    }
    
    if([url.scheme isEqualToString:scheme]){
        
        return YES;
    }
    
    return NO;
}

-(BOOL) openUrl:(NSURL *)url animated:(BOOL)animated{
    
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"tab";
    }
    
    if([url.scheme isEqualToString:scheme]){
        
        NSString * path = [url firstPathComponent:@"/"];
        
        id viewController = nil;
        
        for(viewController in self.viewControllers){
            if([[viewController alias] isEqualToString:path]){
                break;
            }
        }
        
        if(viewController){
            if(self.selectedViewController != viewController){
                [self setSelectedViewController:viewController];
            }
        }

        return YES;
    }
    
    return NO;
}



-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return [[self selectedViewController] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate{
    return [[self selectedViewController] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations{
    return [[self selectedViewController] supportedInterfaceOrientations];
}

-(UIInterfaceOrientation) preferredInterfaceOrientationForPresentation{
    return [[self selectedViewController] preferredInterfaceOrientationForPresentation];
}


-(void) receiveUrl:(NSURL *) url source:(id) source{
    if([self.selectedViewController respondsToSelector:@selector(receiveUrl:source:)]){
        [(id)self.selectedViewController receiveUrl:url source:source];
    }
}

@end