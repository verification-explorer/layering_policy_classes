`define NUM_PORTS 8

typedef enum bit {OFF, ON} rand_mode_t;
typedef enum int {NOFL, OPEN, OVRC, SHRT} failure_type;
typedef enum int {LOW, MEDIUM, HIGH, CRITICAL, HIGHEST} priority_type;
typedef enum int {CONS_10=10, CONS_20=20, CONS_30=30, CONS_40=40, CONS_50=50} power_request_type;
