
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


#include <stdlib.h>
#include <string.h>

static inline int SocializeDebugLevel() {
    char *var = getenv("SocializeDebug");
    if (var == NULL)
        return 0;
    
    if (strcmp(var, "YES") == 0)
        return 1;
    
    int level = (int)strtol(var, NULL, 10);
    return level;
}


#define SDebugLog0( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define SDebugLog(lvl, s, ...) if (SocializeDebugLevel() >= lvl) SDebugLog0( s, ##__VA_ARGS__)

#ifdef DEBUG
#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DebugLog( s, ... ) 
#endif