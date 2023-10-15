run
set logging overwrite on
set logging file /out/gdb.bt
set logging on
set pagination off
handle SIG33 pass nostop noprint
echo backtrace:\n
backtrace full
set logging enabled off
quit
