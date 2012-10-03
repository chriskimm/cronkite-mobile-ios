#import "Environment.h"

@implementation Environment

static Environment *sharedInstance = nil;

@synthesize apiBase;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)initializeSharedInstance
{
    NSString* configuration = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuration"];
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* envsPListPath = [bundle pathForResource:@"Environments" ofType:@"plist"];
    NSDictionary *environments = [[NSDictionary alloc] initWithContentsOfFile:envsPListPath];
    NSDictionary *environment = [environments objectForKey:configuration];
    
    self.apiBase = [environment valueForKey:@"apiBase"];
}

#pragma mark - Lifecycle Methods

+ (Environment *)sharedInstance
{
  @synchronized(self) {
    if (sharedInstance == nil) {
      sharedInstance = [[self alloc] init];
      [sharedInstance initializeSharedInstance];
    }
    return sharedInstance;
  }
}

@end
