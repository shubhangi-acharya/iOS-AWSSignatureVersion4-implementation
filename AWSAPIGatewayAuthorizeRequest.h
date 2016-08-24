//
//  AWSAPIGatewayAuthorizeRequest.h
//  AWSSample
//
//  Created by Shubhangi Pandya on 03/08/16.
//  Copyright © 2016 Shubhangi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeveloperAuthenticatedIdentityProvider.h"
#import <AWSCore/AWSSignature.h>
#import "AppDelegate.h"

@interface AWSAPIGatewayAuthorizeRequest : NSObject
+ (id)sharedInstance;
- (NSString *)getTimeStampForRequest;
- (void)getCanonicalRequestSignature :(NSString *)subURL bodyDict:(NSDictionary *)body method:(NSString *)method WithCompletion:(void (^)(NSString *account,   NSError *error))completion;
@end
