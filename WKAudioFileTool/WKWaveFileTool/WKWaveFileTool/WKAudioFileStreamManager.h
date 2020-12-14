//
//  WKAudioFileStreamManager.h
//  WKWaveFileTool
//
//  Created by apple on 2020/12/14.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKAudioParsedTool : NSObject
@property (nonatomic,readonly) NSData *data;
@property (nonatomic,readonly) AudioStreamPacketDescription packetDescription;

+ (instancetype)wk_parsedAudioDataWithBytes:(const void *)bytes
                       packetDescription:(AudioStreamPacketDescription)packetDescription;

@end


@class WKAudioFileStreamManager;
@protocol WKAudioFileStreamDelegate <NSObject>
@required
- (void)audioFileStream:(WKAudioFileStreamManager *)audioFileStream audioDataParsed:(NSArray *)audioData;
@optional
- (void)audioFileStreamReadyToProducePackets:(WKAudioFileStreamManager *)audioFileStream;
@end

@interface WKAudioFileStreamManager : NSObject
@property (nonatomic,assign) AudioFileTypeID fileType;
@property (nonatomic,assign) BOOL available;
@property (nonatomic,assign) BOOL readyToProducePackets;
@property (nonatomic,weak) id<WKAudioFileStreamDelegate> delegate;

@property (nonatomic,assign) AudioStreamBasicDescription format;
@property (nonatomic,assign) unsigned long long fileSize;
@property (nonatomic,assign) NSTimeInterval duration;
@property (nonatomic,assign) UInt32 bitRate;
@property (nonatomic,assign) UInt32 maxPacketSize;
@property (nonatomic,assign) UInt64 audioDataByteCount;
@property (nonatomic,assign) UInt64 audioDataLength;


- (instancetype)initWithFileType:(AudioFileTypeID)fileType fileSize:(unsigned long long)fileSize error:(NSError **)error;

- (BOOL)wk_parseData:(NSData *)data error:(NSError **)error;

- (SInt64)seekToTime:(NSTimeInterval *)time;

- (NSData *)fetchMagicCookie;

- (void)close;

@end

NS_ASSUME_NONNULL_END
