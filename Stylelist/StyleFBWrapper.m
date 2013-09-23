//
//  StyleLoginViewController.m
//  Stylelist
//
//  Created by ling on 13/7/9.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleFBWrapper.h"
#import "StyleAppDelegate.h"

@implementation FacebookHelper
{
    NSString *fbID;
    NSString *username;
    NSString *profileimage;
    StyleAppDelegate *appDelegate;
}

@synthesize permissions;
@synthesize isConnected;

- (void) initcontroller
{    
    permissions = [NSArray arrayWithObjects:@"read_stream",@"publish_stream",nil];
    appDelegate = (StyleAppDelegate *)[[UIApplication sharedApplication] delegate];
                       
    //[self checkForPreviouslySavedAccessTokenInfo];
    if(![[FBSession activeSession] isOpen] ){
        
        NSLog(@"FBWrapper initcontroller: session state=%d",FBSession.activeSession.state);
        isConnected=NO;
        
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
        {
            NSLog(@"FBWrapper initcontroller: openSessionWithoutUI because session is FBSessionStateCreatedTokenLoaded");
            [self openSessionWithoutUI];
        }
        /*else if (FBSession.activeSession.state == FBSessionStateCreated)
        {
            NSLog(@"FBWrapper initcontroller: openSession, session state=%d",FBSession.activeSession.state);
            //[self openSession];
            
        }*/
    }
    else
    {
        NSLog(@"FBWrapper session is loaded and is open %@", self.delegate);
        if(![username length])
            [self QueryUserInfo];
        else
            isConnected=YES;
    }

}

-(BOOL)checkIsConnected{
    
    return isConnected;
}

-(void)checkForPreviouslySavedAccessTokenInfo{
    // Initially set the isConnected value to NO.
   
    isConnected = NO;
    
    // Check if there is a previous access token key in the user defaults file.
/*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] &&
        [defaults objectForKey:@"FBExpirationDateKey"]) {
        [[FBSession activeSession] accessToken] = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        
        // Check if the facebook session is valid.
        // If it’s not valid clear any authorization and mark the status as not connected.
        if (![facebook isSessionValid]) {
            [facebook authorize:nil];
            isConnected = NO;
        }
        else {
            isConnected = YES;
        }
    }
    
    NSLog(@"checkForPreviouslySavedAccessTokenInfo %d",(int)isConnected);
*/
}

-(void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    // Keep this just for testing purposes.
    NSLog(@"received response");
}


-(void)request:(FBRequest *)request didLoad:(id)result{
    NSLog(@"FB request OK");
    
    currentApiCallType = FBApiCallNone;
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"FB request Error: %@", [error localizedDescription]);
    currentApiCallType = FBApiCallNone;
}
    
-(void)fbDidNotLogin:(BOOL)cancelled{
    // Keep this for testing purposes.
    NSLog(@"Did not login");
    
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"My test app" message:@"Login cancelled." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [al show];
}

- (void) QueryUserInfo
{
    if(![appDelegate isNetworkConnect])
    {
        //NSString *alertText=[NSString stringWithFormat:@"Access Not Available"];
        //[self.delegate errorResponse:alertText];
        return;
    }
    
    NSLog(@"FBWrapper: query User Info");
    FBRequest *me = [FBRequest requestForMe];
    [me startWithCompletionHandler:^(FBRequestConnection *connection,
                                     id result,
                                     NSError *error) {
        if (error)
        {
          [self.delegate errorResponse:error.localizedDescription];
          NSLog(@"FBWrapper: query User Info error =%@", error.localizedDescription);

        }
        else
        {
            NSDictionary<FBGraphUser> *my = (NSDictionary<FBGraphUser> *) result;
            username = my.username;
            //NSLog(@"User session found: %@", username);
            fbID = my.id;
            //NSLog(@"User ID found: %@", fbID);
            profileimage=[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal",fbID];
            NSLog(@"query User Info, User Link found: %@", profileimage);

            if(!isConnected)
            {
                isConnected=YES;
                [self.delegate updateUserProfile];
                [self.delegate SetLoginButton:isConnected];
                NSLog(@"delegate id%@",(id)self.delegate);
            }
        }
    }];
}

- (NSDictionary*) GetUserInfo
{
    NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:fbID, @"ID", username, @"username",profileimage, @"imagepath",nil];
    NSLog(@"User Link found: %@", [dict objectForKey:@"imagepath"]);
    return dict;
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
                NSLog(@"FBWrapper: FBSessionStateOpen");
                [self QueryUserInfo];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:{
                isConnected = NO;
                NSLog(@"FBWrapper: FBSessionStateClosedLoginFailed %@", self.delegate);
                [self.delegate SetLoginButton:isConnected];

            }
            break;
        default:
            break;
    }
    if (error){
    }
    
}

- (void)openSession
{
    if([appDelegate isNetworkConnect])
    {

        NSLog(@"FBWrapper: openSession");
        [FBSession openActiveSessionWithPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
         ^(FBSession *session,
           FBSessionState state, NSError *error) {
         [  self sessionStateChanged:session state:state error:error];
         }];
    }
}

- (void)openSessionWithoutUI
{
    if([appDelegate isNetworkConnect])
    {
        NSLog(@"FBWrapper: openSessionWithoutUI");
        [FBSession openActiveSessionWithPermissions:permissions
                                   allowLoginUI:NO
                              completionHandler:
         ^(FBSession *session,
           FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error];
         }];
    }
}



- (void)LoginOrLogout :(BOOL)isLogin
{
    // If the user is not connected (logged in) then connect.
    // Otherwise logout.
    /*
    if (!isConnected) {
        [facebook authorize:permissions];
    }
    else {
        [facebook logout:self];
    }
    */
    if(![appDelegate isNetworkConnect])
    {
        NSString *alertText=[NSString stringWithFormat:@"Access Not Available"];
        [self.delegate errorResponse:alertText];
        return;
    }

    if (isLogin)
    {
       
        if(!isConnected)
            [self openSession];
        /*[FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                              allowLoginUI:YES
                                         completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error];
         }];*/
    }
    else
    {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

/*
- (void)Publish {
    // Create the parameters dictionary that will keep the data that will be posted.
    NSLog(@"post event");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"My test app", @"name",
                                   @"http://www.google.com", @"link",
                                   @"FBTestApp app for iPhone!", @"caption",
                                   @"This is a description of my app", @"description",
                                   @"Hello!\n\nThis is a test message\nfrom my test iPhone app!", @"message",
                                   nil];
    
    // Publish.
    // This is the most important method that you call. It does the actual job, the message posting.
    [facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
    currentApiCallType = FBApiCallPostMessage;
}
*/
- (void)PublishImage:(UIImage *)image :(int)DBid :(int)index :(NSString*)note{
   
    if (![appDelegate isNetworkConnect])
    {
        return;
    }
    NSLog(@"post Image %d",DBid);
    NSString *message=[NSString stringWithFormat:@"%@\n\n",note];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   image, @"source",
                                   message, @"message",
                                   nil];
    
    // Publish.
    // This is the most important method that you call. It does the actual job, the message posting.
    [FBRequestConnection
     startWithGraphPath:@"me/photos"
     parameters:params 
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"PublishImage error: domain = %@, code = %d",
                          error.domain, error.code];
            [self.delegate errorResponse:alertText];

         }
         else {
             NSLog(@"result back %d",DBid);

             if([self.delegate respondsToSelector:@selector(finishPostImageResponse:::)])
                 [self.delegate finishPostImageResponse:result:DBid:index];
             else
                 NSLog(@"delegate not implement finishPostImageResponse");

         }
        }];
    //[facebook requestWithGraphPath:@"me/photos" andParams:params andHttpMethod:@"POST" andDelegate:self];
    currentApiCallType = FBApiCallPostPicture;
}

- (void) QueryImageLike:(NSString*)FBID :(int)DBid :(int)index{
    //NSLog(@"Query Image %d", DBid);
    if (![appDelegate isNetworkConnect])
    {
        //NSString *alertText=[NSString stringWithFormat:@"Access Not Available"];
        //[self.delegate errorResponse:alertText];
        return;
    }

    NSString *fql = [NSString stringWithFormat:@"select caption, like_info from photo where object_id= '%@'", FBID];
    //NSString *fql = [NSString stringWithFormat:@"select caption, like_info from photo where object_id= '624475877570220'"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:fql, @"q",nil];
    
    //[facebook requestWithGraphPath:@"/fql" andParams:params andHttpMethod:@"GET" andDelegate:self];
    [FBRequestConnection
     startWithGraphPath:@"/fql"
     parameters:params
     HTTPMethod:@"GET"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"QueryImageLike error: domain = %@, code = %d",
                          error.domain, error.code];
            [self.delegate errorResponse:alertText];
             
         }
         else {
             if([self.delegate respondsToSelector:@selector(finishQueryImageResponse:::)])
                 [self.delegate finishQueryImageResponse:result:DBid:index];
             else
                 NSLog(@"delegate not implement finishQueryImageResponse");
         }
     }];
    
    currentApiCallType = FBApiCallQueryPicture;

}

- (void) QueryImageComment:(NSString*)FBID :(int)DBid :(int)index{
    //NSLog(@"Query Image %d", DBid);
    if (![appDelegate isNetworkConnect])
    {
        //NSString *alertText=[NSString stringWithFormat:@"Access Not Available"];
        //[self.delegate errorResponse:alertText];
        return;
    }

    
    NSString *fql = [NSString stringWithFormat:@"select fromid, text, time, post_id FROM comment WHERE post_id = '%@'", FBID];
    //NSString *fql = [NSString stringWithFormat:@"select caption, like_info from photo where object_id= '624475877570220'"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:fql, @"q",nil];
    
    //[facebook requestWithGraphPath:@"/fql" andParams:params andHttpMethod:@"GET" andDelegate:self];
    [FBRequestConnection
     startWithGraphPath:@"/fql"
     parameters:params
     HTTPMethod:@"GET"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"QueryImageComment error: domain = %@, code = %d",
                          error.domain, error.code];
            [self.delegate errorResponse:alertText];
             
         }
         else {
             if([self.delegate respondsToSelector:@selector(finishQueryCommentResponse:::)])
                 [self.delegate finishQueryCommentResponse:result:DBid:index];
             else
                 NSLog(@"delegate not implement finishQueryCommentResponse");
         }
     }];
    
    currentApiCallType = FBApiCallQueryComment;
    
}

- (BOOL)handleOpenURL:(NSURL*)url
{
    BOOL ret=[FBSession.activeSession handleOpenURL:url];
    return ret;
}

- (void)handleDidBecomeActive
{
    [FBSession.activeSession handleDidBecomeActive];
}

@end
