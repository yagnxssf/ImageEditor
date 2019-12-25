
// .h文件
#define SASingletonH(name) +(instancetype)shared##name;

// .m文件
#define SASingletonM(name) static id _instance;\
static dispatch_once_t onceToken;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
\
\
+(instancetype)shared##name\
{\
if (!_instance) {\
_instance = [[self alloc] init];\
}\
return _instance;\
}
