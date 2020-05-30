        .include "myMacro.s"
        .global _start

        .text
_start:
        write_str $1, $message, $13
        exit $0
message:
        .ascii  "Hello, world\n"
