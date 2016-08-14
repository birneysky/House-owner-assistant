//
//  HARESTfulOperation.h
//  HOAKit
//
//  Created by birneysky on 16/8/14.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "MKNetworkOperation.h"

@interface HARESTfulOperation : MKNetworkOperation

@property (nonatomic, strong) NSError *restError;

@end
