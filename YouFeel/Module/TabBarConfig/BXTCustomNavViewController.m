//
//  BXTCustomViewController.m
//  YouFeel
//
//  Created by Jason on 16/6/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTCustomNavViewController.h"
#import "BXTGlobal.h"

@interface BXTCustomNavViewController ()<UINavigationControllerDelegate>

@end

@implementation BXTCustomNavViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController])
    {
        self.delegate = self;
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    [[BXTGlobal shareGlobal].interactionController wireToViewController:toVC forOperation:CEInteractionOperationPop];
    [BXTGlobal shareGlobal].animationController.reverse = operation == UINavigationControllerOperationPop;
    return [BXTGlobal shareGlobal].animationController;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController
{
    return [BXTGlobal shareGlobal].interactionController.interactionInProgress ? [BXTGlobal shareGlobal].interactionController : nil;
}

@end
