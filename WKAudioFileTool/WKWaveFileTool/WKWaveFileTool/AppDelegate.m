//
//  AppDelegate.m
//  WKWaveFileTool
//
//  Created by apple on 2020/12/14.
//

#import "AppDelegate.h"
#import "WKAudioFileStreamManager.h"

@interface AppDelegate ()<WKAudioFileStreamDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"m12_do(1)(1)" ofType:@"wav"];
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
    NSError *error = nil;
    WKAudioFileStreamManager *streamManager = [[WKAudioFileStreamManager alloc] initWithFileType:kAudioFileWave64Type fileSize:fileSize error:&error];
    streamManager.delegate = self;
    
    if (error) {//文件打开错误
        streamManager = nil;
        NSLog(@"create audio file stream failed, error: %@",[error description]);
    } else{
        if (file) {
            NSUInteger lengthPerRead = 10000;
            while (fileSize > 0) {
                NSData *data = [file readDataOfLength:lengthPerRead];
                fileSize -= [data length];
                [streamManager wk_parseData:data error:&error];
                if (error) {
                    if (error.code == kAudioFileStreamError_NotOptimized) {
                    }
                    break;
                }
            }
            
            NSLog(@"audio format: bitrate = %u, duration = %lf. ,dataLength == %llu",(unsigned int)streamManager.bitRate,streamManager.duration,streamManager.audioDataLength);
            //关闭
            [streamManager close];
            streamManager = nil;
            [file closeFile];
        }
    }
    
    
    return YES;
}


- (void)audioFileStreamReadyToProducePackets:(WKAudioFileStreamManager *)audioFileStream {
    
}

- (void)audioFileStream:(WKAudioFileStreamManager *)audioFileStream audioDataParsed:(NSArray *)audioData {
    NSLog(@"audioData === %zd",audioData.count);
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
