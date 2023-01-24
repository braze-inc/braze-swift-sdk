#if BRAZE_DISABLE_DEPRECATIONS
  #define BRZ_DEPRECATED(msg)
#else
  #define BRZ_DEPRECATED(msg) __attribute__((deprecated((msg))))
#endif
