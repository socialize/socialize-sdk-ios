
#define SYNTHESIZE_REFCOUNT_TRACE \
- (oneway void)release { \
    NSLog(@"%@: decreasing retainCount from %d to %d", [self class], [self retainCount], [self retainCount] - 1); \
    NSLog(@"%@",[NSThread callStackSymbols]); \
    [super release]; \
} \
- (id)retain { \
    NSLog(@"%@: increasing retainCount from %d to %d", [self class], [self retainCount], [self retainCount] + 1); \
    NSLog(@"%@",[NSThread callStackSymbols]); \
    return [super retain]; \
}



