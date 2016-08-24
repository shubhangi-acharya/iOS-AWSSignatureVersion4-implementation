//
//  AWSAPIGatewayAuthorizeRequest.m
//  AWSSample
//
//  Created by Shubhangi Pandya on 03/08/16.
//  Copyright © 2016 Shubhangi. All rights reserved.
//

#import "AWSAPIGatewayAuthorizeRequest.h"

#ifdef DevEnv
static NSString* baseURL = @"AWS_URL";
#endif
#ifdef QAEnv
static NSString* baseURL = @"AWS-URL";
#endif
static NSString *appID = @"YOUR_APP_ID";//Add this if you are adding it to ur request otherwise skip this.

#define timoutInterval 60.0
#define AuthToken @"Auth-Token" //Add this if you are adding it to ur request otherwise skip this. As this is used to verify user after login
#define AppID @"X-App-Id"//Add this if you are adding it to ur request otherwise skip this.
#define AmzDate @"X-Amz-Date"// This is required fiels



@implementation AWSAPIGatewayAuthorizeRequest


+ (id)sharedInstance {
    static AWSAPIGatewayAuthorizeRequest *_shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[AWSAPIGatewayAuthorizeRequest alloc] init];
        });
    return _shareInstance;
}

- (void)getCanonicalRequestSignature :(NSString *)subURL bodyDict:(NSDictionary *)body method:(NSString *)method WithCompletion:(void (^)(NSString *account,   NSError *error))completion {
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL, subURL]];;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:timoutInterval];
    [request setHTTPMethod:method];
    [request setValue:appID forHTTPHeaderField:AppID];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *AuthTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:AuthToken];
    if (AuthTokenString) {
        [request setValue:AuthTokenString forHTTPHeaderField:AuthToken];
    }
    [request setValue:[self getTimeStampForRequest] forHTTPHeaderField:AmzDate];
    NSError *error;
    
    if (body) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            [request setHTTPBody:jsonData];
        }
    }
    AWSEndpoint *endPoint = [[AWSEndpoint alloc] initWithRegion:AWSRegionUSEast1 service:AWSServiceAPIGateway URL:[NSURL URLWithString:baseURL]] ;
    AWSSignatureV4Signer *sign = [[AWSSignatureV4Signer alloc] initWithCredentialsProvider:[self awsCognitoCredentialsProvider] endpoint:endPoint];
    [[sign interceptRequest:request]
     continueWithBlock:^id(AWSTask *task) {
         if (task.error) {
             completion(nil, task.error);
         }
         else {
             completion(task.result, nil);
         }
         return nil;
     }];
}

- (NSString *)getTimeStampForRequest {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
    NSString *dateAWS =  [dateFormatter stringFromDate:[NSDate date]];
    return dateAWS;
}

- (AWSCognitoCredentialsProvider *)awsCognitoCredentialsProvider {
    AWSServiceConfiguration *configuration  = [AppDelegate sharedInstance].configuration; // You need to add ur cognoti service configuration object here. Which you  have received from Cognito by adding ur pool id and region.
    return configuration.credentialsProvider;
}

@end
