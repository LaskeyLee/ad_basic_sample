#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendURLRequest:@"http://t.cnoam.com/tracking"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)sendURLRequest:(NSString *)url{
    if(url == nil){
        return;
    }
    NSURL *myURL = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [NSURLRequest
                                requestWithURL:myURL
                                cachePolicy:
                                NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                timeoutInterval:12.0f];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString* resultStr = [[NSString alloc] initWithData:data
                                                                           encoding:NSUTF8StringEncoding];
                               NSLog(@"%@",resultStr);
                           }];
}

@end