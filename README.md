To Add this class,

You need to:

1) Add AWSCore pod/framework.
2) Get accessKey, secretKey and sessionKey from Cognito.

To call this class method you need to:


 - ( void) sampleMethod:(SuccessBlock)success orFailure:( FailureBlock)failure
{
     NSString *path = @'Your_subPath';
    [[ AWSAPIGatewayAuthorizeRequest sharedInstance]  getCanonicalRequestSignature:path  bodyDict: nil  method:@"GET"  WithCompletion:^( NSString *signature,   NSError *error) {
      

  NSMutableURLRequest *request = [ NSMutableURLRequest  requestWithURL:YOUR_URL
                                                            cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval: YOUR_INTERVAL];
    [request  setHTTPMethod:method];
    [request  setValue: appID  forHTTPHeaderField: AppID];
    [request  setValue:@"application/json"  forHTTPHeaderField:@"Content-Type"];
	[request  setValue:@'APP_ID_Add_IF_Required' forHTTPHeaderField:@"X-App-Id"];
    [request  setValue:@'APP_ID_Add_IF_Required' forHTTPHeaderField: @'Auth-Token '];
    [request  setValue:configuration. credentialsProvider. sessionKey  forHTTPHeaderField:@"X-Amz-Security-Token'];//SessionKey returned by Cognito
    [request  setValue:autorization  forHTTPHeaderField:@"Authorization"]; // Signature returned by AWSAPIGatewayAuthorizeRequest class method


     NSDateFormatter *dateFormatter = [ NSDateFormatter  new];
    dateFormatter. timeZone = [ NSTimeZone  timeZoneWithName:@"GMT"];
    dateFormatter. locale = [ NSLocale  localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter  setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
     NSString *dateAWS =  [dateFormatter  stringFromDate:[ NSDate  date]];
    [request  setValue:dateAWS  forHTTPHeaderField:@"X-Amz-Date"];

        request. HTTPMethod =  @"GET";
   
	//Send request.
    }];
}

}