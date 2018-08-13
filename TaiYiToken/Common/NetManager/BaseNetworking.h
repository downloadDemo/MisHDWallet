//
//  BaseNetworking.h
//  TRProject
//

//

#import <Foundation/Foundation.h>

@interface BaseNetworking : NSObject

+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void(^)(id repsonseObj, NSError *error))completionHandler;

+ (id)POST:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void(^)(id repsonseObj, NSError *error))completionHandler;

+ (id)POSTImage:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler;
@end













