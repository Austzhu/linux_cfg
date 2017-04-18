#ifndef __TYPES_H__
#define __TYPES_H__

typedef char                char_t;
typedef signed char         int8_t;
typedef signed short        int16_t;
typedef signed int          int32_t;
typedef signed long         int64_t;
typedef unsigned char       uint8_t;
typedef unsigned short      uint16_t;
typedef unsigned int        uint32_t;
typedef unsigned long       uint64_t;
typedef float               float32_t;
typedef double              float64_t;
typedef long double         float128_t;

typedef signed char         s8;
typedef unsigned char       u8;
typedef signed short        s16;
typedef unsigned short      u16;
typedef signed int          s32;
typedef unsigned int        u32;
typedef signed long long    s64;
typedef unsigned long long  u64;
typedef unsigned char       uchar;

#ifndef true
#define true    1
#endif

#ifndef false
#define false   0
#endif

#ifndef BOOL
#define BOOL int
#endif

#ifndef NULL
#define NULL (void*)0
#endif

#endif    // #ifndef __TYPES_H__
