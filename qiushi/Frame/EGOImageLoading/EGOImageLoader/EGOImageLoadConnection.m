//
//  EGOImageLoadConnection.m
//  EGOImageLoading
//
//  Created by Shaun Harrison on 12/1/09.
//  Copyright (c) 2009-2010 enormego
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGOImageLoadConnection.h"


@implementation EGOImageLoadConnection
@synthesize imageURL=_imageURL, response=_response, delegate=_delegate, timeoutInterval=_timeoutInterval;
@synthesize downloadedByteCount = _downloadedByteCount;
@synthesize expectedByteCount = _expectedByteCount;

#if __EGOIL_USE_BLOCKS
@synthesize handlers;
#endif

- (id)initWithImageURL:(NSURL*)aURL delegate:(id)delegate {
	if((self = [super init])) {
		_imageURL = [aURL retain];
		self.delegate = delegate;
		_responseData = [[NSMutableData alloc] init];
		self.timeoutInterval = 30;
		
		#if __EGOIL_USE_BLOCKS
		handlers = [[NSMutableDictionary alloc] init];
		#endif
	}
	
	return self;
}

- (void)start {
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:self.imageURL
																cachePolicy:NSURLRequestReturnCacheDataElseLoad
															timeoutInterval:self.timeoutInterval];
	[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];  
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	[request release];
    
    //Reset progress bar
    self.downloadedByteCount = 0;
    self.expectedByteCount = 0;
}

- (void)cancel {
	[_connection cancel];
    
    //Reset progress bar
    self.downloadedByteCount = 0;
    self.expectedByteCount = 0;
}

- (NSData*)responseData {
	return _responseData;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if(connection != _connection) return;
	[_responseData appendData:data];
    
    self.downloadedByteCount += data.length;
    DLog(@"已经下载了：%.2f%",((CGFloat)self.downloadedByteCount/(CGFloat)self.expectedByteCount));
    //Update progress bar in front view
//    [self performSelectorOnMainThread:@selector(updateProgressBar) withObject:nil waitUntilDone:YES];
//    [self.delegate updateProgressBar:((CGFloat)self.downloadedByteCount/(CGFloat)self.expectedByteCount)];
    
    if ([self.delegate respondsToSelector:@selector(imageLoadConnection:progressBar:)]) {
        [self.delegate imageLoadConnection:self progressBar:((CGFloat)self.downloadedByteCount/(CGFloat)self.expectedByteCount)];
    }
    
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if(connection != _connection) return;
	self.response = response;
    self.expectedByteCount = [response expectedContentLength];
    self.downloadedByteCount = 0;
    NSLog(@"总大小：%d",self.expectedByteCount);
    DLog(@"开始获取==1");
    if ([self.delegate respondsToSelector:@selector(imageLoadConnection:progressBar:)]) {
        [self.delegate imageLoadConnection:self progressBar:0];
    }
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if(connection != _connection) return;

    DLog(@"获取完成==2");
    self.expectedByteCount = 0;
    self.downloadedByteCount = 0;
    if ([self.delegate respondsToSelector:@selector(imageLoadConnection:progressBar:)]) {
        [self.delegate imageLoadConnection:self progressBar:0];
    }
    
    //respondsToSelector判断是否实现了某方法
	if([self.delegate respondsToSelector:@selector(imageLoadConnectionDidFinishLoading:)]) {
		[self.delegate imageLoadConnectionDidFinishLoading:self];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if(connection != _connection) return;

    DLog(@"获取失败==3：%@",error);
    
    self.expectedByteCount = 0;
    self.downloadedByteCount = 0;
    if ([self.delegate respondsToSelector:@selector(imageLoadConnection:progressBar:)]) {
        [self.delegate imageLoadConnection:self progressBar:0];
    }
    
    //respondsToSelector判断是否实现了某方法
	if([self.delegate respondsToSelector:@selector(imageLoadConnection:didFailWithError:)]) {
		[self.delegate imageLoadConnection:self didFailWithError:error];
	}
}




- (void)dealloc {
	self.response = nil;
	self.delegate = nil;
	
	#if __EGOIL_USE_BLOCKS
	[handlers release], handlers = nil;
	#endif

	[_connection release];
	[_imageURL release];
	[_responseData release];
	[super dealloc];
}

@end
