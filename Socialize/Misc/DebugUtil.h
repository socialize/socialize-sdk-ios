
#define SYNTHESIZE_REFCOUNT_TRACE \
- (oneway void)release { \
    NSLog(@"%@/%x: decreasing retainCount from %d to %d", [self class], (unsigned int)self, [self retainCount], [self retainCount] - 1); \
    NSLog(@"%@",[NSThread callStackSymbols]); \
    [super release]; \
} \
- (id)retain { \
    NSLog(@"%@/%x: increasing retainCount from %d to %d", [self class], (unsigned int)self, [self retainCount], [self retainCount] + 1); \
    NSLog(@"%@",[NSThread callStackSymbols]); \
    return [super retain]; \
}



