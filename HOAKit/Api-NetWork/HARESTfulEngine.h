//
//  HARESTfulEngine.h
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "MKNetworkEngine.h"

/*单例类*/

@interface HARESTfulEngine : MKNetworkEngine

+ (HARESTfulEngine*)defaultEngine;


@end
